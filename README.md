# Dotfiles

Personal shell configuration and helpers.

## Setup

```bash
./setup_dotfiles.sh
```

## Worktree Helpers

`worktree-helpers.sh` provides commands for managing git worktrees for AI-EmailToOrder.

### wt-new

Create a new worktree with all necessary setup.

```bash
wt-new <name> [branch] [--claude]
```

**Examples:**
```bash
wt-new mermaid feature/mermaid-visualization    # existing branch
wt-new price-check                               # new branch from dev
wt-new price-check feature/283 --claude          # also start claude
```

**What it does:**
1. Creates worktree at `~/dev/AI-EmailToOrder-<name>`
2. Copies `.env` files (backend, frontend)
3. Symlinks shared files (see below)
4. Copies VS Code settings as template

### wt

Select and switch to an existing worktree.

```bash
wt
```

## Shared Files

### Symlinked (shared across all worktrees)

| File | Source |
|------|--------|
| `backend/.venv` | Main repo's virtualenv |
| `LOCAL-CLAUDE.md` | Personal Claude instructions |
| `.vscode/tasks.json` | `~/dotfiles/.vscode/tasks.json` |
| `.vscode/launch.json` | `~/dotfiles/.vscode/launch.json` |

### Copied (local per worktree)

| File | Source |
|------|--------|
| `backend/.env` | Main repo |
| `frontend/.env` | Main repo |
| `.vscode/settings.json` | `~/dotfiles/.vscode/settings.json` |

Settings are copied (not symlinked) so each worktree can have custom colors to visually distinguish them.

## Tmux

Uses [gpakosz/.tmux](https://github.com/gpakosz/.tmux) which lives as its own git repo in `~/.tmux/`.

The `.tmux.conf.local` file in this repo contains personal overrides (theme, keybindings, etc.) and is symlinked into the gpakosz repo:

```
~/.tmux/.tmux.conf.local -> ~/dotfiles/.tmux.conf.local
```

**Prerequisites:** Clone gpakosz/.tmux first, then run `setup_dotfiles.sh`:

```bash
git clone https://github.com/gpakosz/.tmux.git ~/.tmux
ln -sf ~/.tmux/.tmux.conf ~/.tmux.conf
```

## Neovim

Config lives in `~/dotfiles/nvim/` and is symlinked:

```
~/.config/nvim -> ~/dotfiles/nvim
```

Uses [lazy.nvim](https://github.com/folke/lazy-loading) for plugin management. `lazy-lock.json` is checked in to pin plugin versions.

See **[NVIM-README.md](NVIM-README.md)** for all keybindings and plugins.

## VS Code Configuration

The main repo's `.vscode/` symlinks to `~/dotfiles/.vscode/`:

```
AI-EmailToOrder/.vscode/
├── launch.json   -> ~/dotfiles/.vscode/launch.json
├── settings.json -> ~/dotfiles/.vscode/settings.json
└── tasks.json    -> ~/dotfiles/.vscode/tasks.json
```

Edit configs in `~/dotfiles/.vscode/` - changes apply to main repo and future worktrees.

### Worktree-specific colors

To set a unique window color for a worktree, edit its local `.vscode/settings.json`:

```json
{
  "workbench.colorCustomizations": {
    "titleBar.activeBackground": "#4a1f5c",
    "titleBar.activeForeground": "#ffffff"
  }
}
```
