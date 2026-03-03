#!/usr/bin/env zsh
# Worktree helpers for AI-EmailToOrder
# Source this from .zshrc: source ~/dev/worktree-helpers.sh

ETO_ROOT="$HOME/dev/AI-EmailToOrder"
ETO_WORKTREES="$ETO_ROOT/.worktrees"

# Create a new worktree, checkout branch, copy .env files, optionally start claude
# Usage:
#   wt-new mermaid feature/mermaid-visualization
#   wt-new mermaid feature/mermaid-visualization --claude   # also start claude
#   wt-new mermaid                                          # creates new branch: mermaid (from dev)
wt-new() {
  local name="$1"
  local branch="$2"
  local start_claude=false

  if [[ -z "$name" ]]; then
    echo "Usage: wt-new <name> [branch] [--claude]"
    echo "  name:    short name for worktree (creates .worktrees/<name>)"
    echo "  branch:  branch to checkout (default: creates new branch '<name>' from dev)"
    echo "  --claude: start claude after setup"
    return 1
  fi

  # Check for --claude flag in any position
  for arg in "$@"; do
    [[ "$arg" == "--claude" ]] && start_claude=true
  done

  local wt_dir="${ETO_WORKTREES}/${name}"

  if [[ -d "$wt_dir" ]]; then
    echo "Error: $wt_dir already exists. Use wt to switch to it."
    return 1
  fi

  # Ensure .worktrees directory exists
  mkdir -p "$ETO_WORKTREES"

  echo "Creating worktree at $wt_dir..."

  if [[ -n "$branch" && "$branch" != "--claude" ]]; then
    # Check if branch exists
    if git -C "$ETO_ROOT" rev-parse --verify "$branch" &>/dev/null; then
      git -C "$ETO_ROOT" worktree add "$wt_dir" "$branch"
    elif git -C "$ETO_ROOT" rev-parse --verify "origin/$branch" &>/dev/null; then
      git -C "$ETO_ROOT" worktree add "$wt_dir" "origin/$branch"
    else
      echo "Branch '$branch' not found locally or on remote. Create new branch from dev? [y/N]"
      read -r confirm
      [[ "$confirm" != [yY] ]] && return 1
      git -C "$ETO_ROOT" worktree add -b "$branch" "$wt_dir" dev
    fi
  else
    # No branch specified, create new branch from dev
    echo "No branch specified, creating new branch '$name' from dev..."
    git -C "$ETO_ROOT" worktree add -b "$name" "$wt_dir" dev
  fi

  if [[ $? -ne 0 ]]; then
    echo "Failed to create worktree."
    return 1
  fi

  # Copy .env files
  local copied=()
  if [[ -f "$ETO_ROOT/backend/.env" ]]; then
    cp "$ETO_ROOT/backend/.env" "$wt_dir/backend/.env"
    copied+=(backend/.env)
  fi
  if [[ -f "$ETO_ROOT/frontend/.env" ]]; then
    cp "$ETO_ROOT/frontend/.env" "$wt_dir/frontend/.env"
    copied+=(frontend/.env)
  fi

  # Symlink shared files to avoid duplication
  local linked=()
  # NOTE: .venv is NOT symlinked — each worktree gets its own via `uv sync`
  # to avoid cross-contamination of sys.path via .pth files
  if [[ -f "$ETO_ROOT/LOCAL-CLAUDE.md" ]]; then
    ln -s "$ETO_ROOT/LOCAL-CLAUDE.md" "$wt_dir/LOCAL-CLAUDE.md"
    linked+=(LOCAL-CLAUDE.md)
  fi

  # Setup .vscode: symlink shared configs, copy settings as template
  local dotfiles_vscode="$HOME/dotfiles/.vscode"
  if [[ -d "$dotfiles_vscode" ]]; then
    mkdir -p "$wt_dir/.vscode"
    if [[ -f "$dotfiles_vscode/tasks.json" ]]; then
      ln -s "$dotfiles_vscode/tasks.json" "$wt_dir/.vscode/tasks.json"
      linked+=(.vscode/tasks.json)
    fi
    if [[ -f "$dotfiles_vscode/launch.json" ]]; then
      ln -s "$dotfiles_vscode/launch.json" "$wt_dir/.vscode/launch.json"
      linked+=(.vscode/launch.json)
    fi
    if [[ -f "$dotfiles_vscode/settings.json" ]]; then
      cp "$dotfiles_vscode/settings.json" "$wt_dir/.vscode/settings.json"
      copied+=(.vscode/settings.json)
    fi
  fi

  echo "Worktree created: $wt_dir"
  [[ ${#copied[@]} -gt 0 ]] && echo "Copied: ${copied[*]}"
  [[ ${#linked[@]} -gt 0 ]] && echo "Symlinked: ${linked[*]}"

  if $start_claude; then
    cd "$wt_dir" && claude
  else
    echo "To start working: cd $wt_dir && claude"
  fi
}

# Select an existing worktree and start claude there
# Usage: wt
wt() {
  local worktrees=()
  local labels=()

  # Parse git worktree list output
  while IFS= read -r line; do
    local dir=$(echo "$line" | awk '{print $1}')
    local branch=$(echo "$line" | sed 's/.*\[\(.*\)\]/\1/')
    worktrees+=("$dir")
    labels+=("$(basename "$dir")  ($branch)")
  done < <(git -C "$ETO_ROOT" worktree list | grep -v "bare")

  if [[ ${#worktrees[@]} -eq 0 ]]; then
    echo "No worktrees found."
    return 1
  fi

  echo "Select worktree:"
  local i
  for i in {1..${#labels[@]}}; do
    echo "  $i) ${labels[$i]}"
  done
  echo ""
  printf "Choice [1-${#labels[@]}]: "
  read -r choice

  if [[ -z "$choice" || "$choice" -lt 1 || "$choice" -gt ${#labels[@]} ]] 2>/dev/null; then
    echo "Invalid choice."
    return 1
  fi

  local target="${worktrees[$choice]}"
  echo "Switching to $target..."
  cd "$target" && claude
}
