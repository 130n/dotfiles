#!/usr/bin/env python3
"""Strip workmux sidebar panes from a tmux-resurrect save.

The sidebar pane runs `workmux _sidebar-run`, which resurrect does not know how
to restore, so it comes back as an empty shell. The workmux sidebar daemon then
adds its own sidebar on top, leaving a dead vertical split in every window.
Removing the pane from the save (line, pane index, window layout and captured
pane contents) lets the daemon own the sidebar alone.
"""

from __future__ import annotations

import os
import re
import subprocess
import sys
import tarfile
import tempfile
from dataclasses import dataclass, field
from pathlib import Path

SIDEBAR_COMMANDS = {"workmux"}

# Pane line fields, tab separated (see tmux-resurrect scripts/save.sh).
F_TYPE, F_SESSION, F_WINDOW, F_WIN_ACTIVE, F_WIN_FLAGS = 0, 1, 2, 3, 4
F_PANE_INDEX, F_PANE_TITLE, F_PATH, F_PANE_ACTIVE, F_COMMAND = 5, 6, 7, 8, 9

CELL_RE = re.compile(r"(\d+)x(\d+),(\d+),(\d+)")


@dataclass
class Cell:
    width: int
    height: int
    x: int
    y: int
    pane_id: int | None = None
    split: str | None = None  # "{" for horizontal, "[" for vertical
    children: list["Cell"] = field(default_factory=list)


def parse_layout(layout: str) -> tuple[str, Cell]:
    checksum, _, body = layout.partition(",")
    cell, pos = _parse_cell(body, 0)
    if pos != len(body):
        raise ValueError(f"trailing layout data: {body[pos:]!r}")
    return checksum, cell


def _parse_cell(s: str, pos: int) -> tuple[Cell, int]:
    m = CELL_RE.match(s, pos)
    if not m:
        raise ValueError(f"bad layout cell at {pos}: {s[pos : pos + 20]!r}")
    cell = Cell(*(int(g) for g in m.groups()))
    pos = m.end()
    if pos < len(s) and s[pos] in "{[":
        cell.split = s[pos]
        closing = "}" if cell.split == "{" else "]"
        pos += 1
        while True:
            child, pos = _parse_cell(s, pos)
            cell.children.append(child)
            if s[pos] == ",":
                pos += 1
                continue
            if s[pos] == closing:
                return cell, pos + 1
            raise ValueError(f"bad layout separator at {pos}: {s[pos]!r}")
    if pos < len(s) and s[pos] == ",":
        m = re.match(r",(\d+)", s[pos:])
        if m:
            cell.pane_id = int(m.group(1))
            pos += m.end()
    return cell, pos


def serialize(cell: Cell) -> str:
    out = f"{cell.width}x{cell.height},{cell.x},{cell.y}"
    if cell.split:
        closing = "}" if cell.split == "{" else "]"
        return out + cell.split + ",".join(serialize(c) for c in cell.children) + closing
    if cell.pane_id is not None:
        out += f",{cell.pane_id}"
    return out


def checksum(body: str) -> str:
    csum = 0
    for ch in body:
        csum = (csum >> 1) + ((csum & 1) << 15)
        csum = (csum + ord(ch)) & 0xFFFF
    return f"{csum:04x}"


def dump_layout(cell: Cell) -> str:
    body = serialize(cell)
    return f"{checksum(body)},{body}"


def panes_in_order(cell: Cell) -> list[Cell]:
    if not cell.split:
        return [cell]
    return [p for c in cell.children for p in panes_in_order(c)]


def drop_pane(cell: Cell, target: Cell) -> Cell | None:
    """Remove `target` from the tree, collapsing single-child containers."""
    if cell is target:
        return None
    if not cell.split:
        return cell
    kept = [c for c in (drop_pane(c, target) for c in cell.children) if c is not None]
    if not kept:
        return None
    if len(kept) == 1:
        only = kept[0]
        only.x, only.y = cell.x, cell.y
        only.width, only.height = cell.width, cell.height
        return only
    cell.children = kept
    return cell


def reflow(cell: Cell, width: int, height: int, x: int, y: int) -> None:
    """Rescale a subtree to fit the given box, keeping child proportions."""
    cell.width, cell.height, cell.x, cell.y = width, height, x, y
    if not cell.split:
        return
    horizontal = cell.split == "{"
    n = len(cell.children)
    old = [c.width if horizontal else c.height for c in cell.children]
    total = (width if horizontal else height) - (n - 1)  # separator lines
    old_total = sum(old) or n
    sizes = [max(1, size * total // old_total) for size in old]
    # Fix rounding drift on the last child.
    sizes[-1] += total - sum(sizes)
    while sizes[-1] < 1:
        donor = max(range(n - 1), key=lambda i: sizes[i])
        sizes[donor] -= 1
        sizes[-1] += 1
    offset = x if horizontal else y
    for child, size in zip(cell.children, sizes, strict=True):
        if horizontal:
            reflow(child, size, height, offset, y)
        else:
            reflow(child, width, size, x, offset)
        offset += size + 1


def strip(save_file: Path) -> dict[tuple[str, str], dict[int, int]]:
    """Rewrite the save file in place. Returns per-window old->new pane indices."""
    lines = save_file.read_text(encoding="utf-8", errors="surrogateescape").splitlines()

    removed: dict[tuple[str, str], list[int]] = {}
    base_index: dict[tuple[str, str], int] = {}
    kept_lines: list[str] = []
    for line in lines:
        parts = line.split("\t")
        if parts[F_TYPE] != "pane":
            kept_lines.append(line)
            continue
        key = (parts[F_SESSION], parts[F_WINDOW])
        index = int(parts[F_PANE_INDEX])
        base_index[key] = min(base_index.get(key, index), index)
        removed.setdefault(key, [])
        if parts[F_COMMAND] in SIDEBAR_COMMANDS:
            removed[key].append(index)
        else:
            kept_lines.append(line)
    if not any(removed.values()):
        return {}

    # Renumber the surviving panes of each touched window.
    renumber: dict[tuple[str, str], dict[int, int]] = {}
    seen: dict[tuple[str, str], int] = {}
    out_lines: list[str] = []
    for line in kept_lines:
        parts = line.split("\t")
        if parts[F_TYPE] != "pane":
            out_lines.append(line)
            continue
        key = (parts[F_SESSION], parts[F_WINDOW])
        if not removed.get(key):
            out_lines.append(line)
            continue
        old_index = int(parts[F_PANE_INDEX])
        new_index = base_index[key] + seen.get(key, 0)
        seen[key] = seen.get(key, 0) + 1
        renumber.setdefault(key, {})[old_index] = new_index
        parts[F_PANE_INDEX] = str(new_index)
        out_lines.append("\t".join(parts))

    final: list[str] = []
    for line in out_lines:
        parts = line.split("\t")
        if parts[0] != "window":
            final.append(line)
            continue
        key = (parts[1], parts[2])
        dropped = removed.get(key)
        if not dropped:
            final.append(line)
            continue
        if not seen.get(key):
            continue  # window held nothing but the sidebar
        try:
            _, root = parse_layout(parts[6])
            ordered = panes_in_order(root)
            base = base_index[key]
            for old_index in sorted(dropped, reverse=True):
                root_new = drop_pane(root, ordered[old_index - base])
                if root_new is None:
                    break
                root = root_new
            reflow(root, root.width, root.height, root.x, root.y)
            parts[6] = dump_layout(root)
        except (ValueError, IndexError) as exc:
            print(f"layout rewrite skipped for {key}: {exc}", file=sys.stderr)
        final.append("\t".join(parts))

    save_file.write_text(
        "\n".join(final) + "\n", encoding="utf-8", errors="surrogateescape"
    )
    return renumber


def live_renumber() -> dict[tuple[str, str], dict[int, int]]:
    """Old->new pane indices per window, derived from the running server.

    The captured pane contents are dumped from live state, so they must be
    remapped even when resurrect deduplicated the save file away.
    """
    fmt = "#{session_name}\t#{window_index}\t#{pane_index}\t#{pane_current_command}"
    try:
        out = subprocess.run(
            ["tmux", "list-panes", "-a", "-F", fmt],
            capture_output=True,
            text=True,
            check=True,
        ).stdout
    except (OSError, subprocess.CalledProcessError):
        return {}

    windows: dict[tuple[str, str], list[tuple[int, str]]] = {}
    for line in out.splitlines():
        session, window, index, command = line.split("\t")
        windows.setdefault((session, window), []).append((int(index), command))

    renumber: dict[tuple[str, str], dict[int, int]] = {}
    for key, panes in windows.items():
        if not any(command in SIDEBAR_COMMANDS for _, command in panes):
            continue
        next_index = min(index for index, _ in panes)
        mapping: dict[int, int] = {}
        for index, command in sorted(panes):
            if command in SIDEBAR_COMMANDS:
                continue
            mapping[index] = next_index
            next_index += 1
        renumber[key] = mapping
    return renumber


def rewrite_pane_contents(archive: Path, renumber) -> None:
    if not archive.is_file() or not renumber:
        return
    with tempfile.TemporaryDirectory() as tmp:
        tmpdir = Path(tmp)
        with tarfile.open(archive, "r:gz") as tar:
            tar.extractall(tmpdir)  # noqa: S202 - our own archive
        renames: list[tuple[Path, Path]] = []
        for path in sorted(tmpdir.rglob("pane-*")):
            name = path.name[len("pane-") :]
            session, _, rest = name.rpartition(":")
            window, _, index = rest.partition(".")
            mapping = renumber.get((session, window))
            if mapping is None:
                continue
            new_index = mapping.get(int(index))
            if new_index is None:
                path.unlink()
            elif str(new_index) != index:
                renames.append((path, path.with_name(f"pane-{session}:{window}.{new_index}")))
        # Two phases, because a rename target can still be an unprocessed source.
        for source, _ in renames:
            source.rename(source.with_name(source.name + ".renaming"))
        for source, target in renames:
            source.with_name(source.name + ".renaming").rename(target)

        with tarfile.open(archive, "w:gz") as tar:
            for child in sorted(tmpdir.iterdir()):
                tar.add(child, arcname=f"./{child.name}")


def resurrect_dir() -> Path:
    for candidate in (
        Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))
        / "tmux/resurrect",
        Path.home() / ".tmux/resurrect",
    ):
        if candidate.is_dir():
            return candidate
    raise SystemExit("no resurrect directory found")


def main() -> None:
    if len(sys.argv) > 1:
        save_file = Path(sys.argv[1])
        directory = save_file.parent
    else:
        directory = resurrect_dir()
        save_file = (directory / "last").resolve()
    if save_file.is_file():
        strip(save_file)
    rewrite_pane_contents(directory / "pane_contents.tar.gz", live_renumber())


if __name__ == "__main__":
    main()
