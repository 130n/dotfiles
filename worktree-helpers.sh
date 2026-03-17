#!/usr/bin/env zsh
# Generic git worktree helpers with tmux integration
# Source this from .zshrc: source ~/dotfiles/worktree-helpers.sh

# Create a new worktree, copy .env files, open in tmux
# Usage:
#   wt-new mermaid feature/mermaid-visualization
#   wt-new mermaid feature/mermaid-visualization --claude
#   wt-new mermaid                                          # creates new branch: mermaid
wt-new() {
  local name="$1"
  local branch="$2"
  local start_claude=false

  if [[ -z "$name" ]]; then
    echo "Usage: wt-new <name> [branch] [--claude]"
    echo "  name:    short name for worktree (creates .worktrees/<name>)"
    echo "  branch:  branch to checkout (default: new branch '<name>' from HEAD)"
    echo "  --claude: start claude after setup"
    return 1
  fi

  # Must be in a git repo
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$repo_root" ]]; then
    echo "Not inside a git repository"
    return 1
  fi

  # Check for --claude flag in any position
  for arg in "$@"; do
    [[ "$arg" == "--claude" ]] && start_claude=true
  done

  local repo_name=$(basename "$repo_root")
  local wt_base="$repo_root/.worktrees"
  local wt_dir="$wt_base/$name"

  if [[ -d "$wt_dir" ]]; then
    echo "Error: $wt_dir already exists. Use wt to switch to it."
    return 1
  fi

  mkdir -p "$wt_base"
  echo "Creating worktree at $wt_dir..."

  if [[ -n "$branch" && "$branch" != "--claude" ]]; then
    if git rev-parse --verify "$branch" &>/dev/null; then
      git worktree add "$wt_dir" "$branch"
    elif git rev-parse --verify "origin/$branch" &>/dev/null; then
      git worktree add "$wt_dir" "origin/$branch"
    else
      echo "Branch '$branch' not found. Create new branch from HEAD? [y/N]"
      read -r confirm
      [[ "$confirm" != [yY] ]] && return 1
      git worktree add -b "$branch" "$wt_dir"
    fi
  else
    # Check if name matches an existing branch before creating a new one
    if git rev-parse --verify "$name" &>/dev/null; then
      echo "Found existing local branch '$name', using it..."
      git worktree add "$wt_dir" "$name"
    elif git rev-parse --verify "origin/$name" &>/dev/null; then
      echo "Found existing remote branch '$name', using it..."
      git worktree add "$wt_dir" "origin/$name"
    else
      echo "No branch specified, creating new branch '$name' from HEAD..."
      git worktree add -b "$name" "$wt_dir"
    fi
  fi

  if [[ $? -ne 0 ]]; then
    echo "Failed to create worktree."
    return 1
  fi

  # Copy .env files found in repo root or immediate subdirs
  local copied=()
  for env_file in "$repo_root"/.env "$repo_root"/*/.env; do
    [[ -f "$env_file" ]] || continue
    local rel="${env_file#$repo_root/}"
    local target_dir="$wt_dir/$(dirname "$rel")"
    mkdir -p "$target_dir"
    cp "$env_file" "$wt_dir/$rel"
    copied+=("$rel")
  done

  # Copy .vscode/settings.json if it exists in repo
  local linked=()
  if [[ -d "$repo_root/.vscode" ]]; then
    mkdir -p "$wt_dir/.vscode"
    for f in "$repo_root/.vscode"/*.json; do
      [[ -f "$f" ]] || continue
      local fname=$(basename "$f")
      if [[ "$fname" == "settings.json" ]]; then
        cp "$f" "$wt_dir/.vscode/$fname"
        copied+=(".vscode/$fname")
      else
        ln -s "$f" "$wt_dir/.vscode/$fname"
        linked+=(".vscode/$fname")
      fi
    done
  fi

  echo "Worktree created: $wt_dir"
  [[ ${#copied[@]} -gt 0 ]] && echo "Copied: ${copied[*]}"
  [[ ${#linked[@]} -gt 0 ]] && echo "Symlinked: ${linked[*]}"

  # Run project-specific setup if available
  if [[ -x "$repo_root/scripts/create-worktree-compose.sh" ]]; then
    echo "Running project-specific docker compose setup..."
    # Get actual branch from the worktree
    local actual_branch=$(cd "$wt_dir" && git rev-parse --abbrev-ref HEAD 2>/dev/null)
    # Derive port offset from branch name (range 100-899)
    local port_offset=$(( $(echo -n "$actual_branch" | md5sum | tr -d '[a-f]' | cut -c1-3) % 800 + 100 ))
    local backend_port=$((8000 + port_offset))
    local frontend_port=$((5000 + port_offset))
    "$repo_root/scripts/create-worktree-compose.sh" "$wt_dir" "$backend_port" "$frontend_port" || echo "Warning: docker compose setup failed"
  fi

  # Open in tmux
  if [[ -n "$TMUX" ]]; then
    tmux new-window -n "$name" -c "$wt_dir"
    if $start_claude; then
      tmux send-keys "claude" C-m
    fi
  else
    cd "$wt_dir"
    $start_claude && claude
  fi
}

# Select an existing worktree and switch to it in tmux
# Usage: wt
wt() {
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$repo_root" ]]; then
    echo "Not inside a git repository"
    return 1
  fi

  local worktrees=()
  local labels=()

  while IFS= read -r line; do
    local dir=$(echo "$line" | awk '{print $1}')
    local branch=$(echo "$line" | sed 's/.*\[\(.*\)\]/\1/')
    worktrees+=("$dir")
    labels+=("$(basename "$dir")  ($branch)")
  done < <(git worktree list | grep -v "bare")

  if [[ ${#worktrees[@]} -eq 0 ]]; then
    echo "No worktrees found."
    return 1
  fi

  echo "Select worktree:"
  local i
  for i in {1..${#labels[@]}}; do
    echo "  $i) ${labels[$i]}"
  done
  echo "  +) New worktree from existing branch"
  echo ""
  printf "Choice [1-${#labels[@]}, +]: "
  read -r choice

  # Handle "new from branch" option
  if [[ "$choice" == "+" ]]; then
    echo ""
    echo "Recent branches (by commit date):"
    local branches=()
    local branch_labels=()
    local idx=1
    while IFS= read -r line; do
      local branch=$(echo "$line" | awk '{print $1}')
      local date=$(echo "$line" | awk '{print $2, $3}')
      branches+=("$branch")
      branch_labels+=("$branch  ($date)")
      echo "  $idx) ${branch_labels[-1]}"
      ((idx++))
    done < <(git for-each-ref --sort=-committerdate --format='%(refname:short) %(committerdate:relative)' refs/heads refs/remotes/origin | grep -v '/HEAD$' | head -15)

    echo ""
    printf "Branch [1-${#branches[@]}]: "
    read -r branch_choice

    if [[ -z "$branch_choice" || "$branch_choice" -lt 1 || "$branch_choice" -gt ${#branches[@]} ]] 2>/dev/null; then
      echo "Invalid choice."
      return 1
    fi

    local selected_branch="${branches[$branch_choice]}"
    # Strip origin/ prefix if present
    local wt_name="${selected_branch#origin/}"
    wt_name="${wt_name//\//-}"  # Replace / with -

    echo ""
    printf "Worktree name [$wt_name]: "
    read -r custom_name
    [[ -n "$custom_name" ]] && wt_name="$custom_name"

    wt-new "$wt_name" "$selected_branch" --claude
    return $?
  fi

  if [[ -z "$choice" || "$choice" -lt 1 || "$choice" -gt ${#labels[@]} ]] 2>/dev/null; then
    echo "Invalid choice."
    return 1
  fi

  local target="${worktrees[$choice]}"
  local name=$(basename "$target")

  if [[ -n "$TMUX" ]]; then
    tmux new-window -n "$name" -c "$target"
  else
    cd "$target"
  fi
}

# Re-copy .env files from main repo to current worktree
# Usage: wt-sync-env
wt-sync-env() {
  local wt_dir=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$wt_dir" ]]; then
    echo "Not inside a git repository"
    return 1
  fi

  # Find the main repo root (parent of .worktrees)
  local repo_root=""
  if [[ "$wt_dir" == */.worktrees/* ]]; then
    repo_root="${wt_dir%%/.worktrees/*}"
  else
    echo "Not inside a worktree (.worktrees/ not in path)"
    return 1
  fi

  local copied=()
  for env_file in "$repo_root"/.env "$repo_root"/*/.env; do
    [[ -f "$env_file" ]] || continue
    local rel="${env_file#$repo_root/}"
    local target_dir="$wt_dir/$(dirname "$rel")"
    mkdir -p "$target_dir"
    cp "$env_file" "$wt_dir/$rel"
    copied+=("$rel")
  done

  if [[ ${#copied[@]} -gt 0 ]]; then
    echo "Synced from $repo_root: ${copied[*]}"
  else
    echo "No .env files found in $repo_root"
  fi
}

# Show compact status for all worktrees
# Usage: wt-status
wt-status() {
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$repo_root" ]]; then
    echo "Not inside a git repository"
    return 1
  fi
  if [[ "$repo_root" == */.worktrees/* ]]; then
    repo_root="${repo_root%%/.worktrees/*}"
  fi

  while IFS= read -r line; do
    local dir=$(echo "$line" | awk '{print $1}')
    local branch=$(echo "$line" | sed 's/.*\[\(.*\)\]/\1/')
    local name=$(basename "$dir")
    [[ "$dir" == "$repo_root" ]] && name="(main)"

    # Count dirty files
    local staged=$(git -C "$dir" diff --cached --numstat 2>/dev/null | wc -l)
    local modified=$(git -C "$dir" diff --numstat 2>/dev/null | wc -l)
    local untracked=$(git -C "$dir" ls-files --others --exclude-standard 2>/dev/null | wc -l)

    # Ahead/behind remote
    local ab=""
    local upstream=$(git -C "$dir" rev-parse --abbrev-ref "@{upstream}" 2>/dev/null)
    if [[ -n "$upstream" ]]; then
      local ahead=$(git -C "$dir" rev-list --count "$upstream..HEAD" 2>/dev/null)
      local behind=$(git -C "$dir" rev-list --count "HEAD..$upstream" 2>/dev/null)
      [[ "$ahead" -gt 0 ]] && ab+="↑$ahead"
      [[ "$behind" -gt 0 ]] && ab+="↓$behind"
    else
      ab="no remote"
    fi

    # Build info string
    local info=""
    [[ "$staged" -gt 0 ]] && info+=" +$staged"
    [[ "$modified" -gt 0 ]] && info+=" ~$modified"
    [[ "$untracked" -gt 0 ]] && info+=" ?$untracked"
    [[ -z "$info" ]] && info=" clean"

    printf "%-35s %-40s %-10s [%s]\n" "$name" "$branch" "$ab" "${info# }"
  done < <(git -C "$repo_root" worktree list | grep -v "bare")

  echo ""
  echo "  + staged  ~ modified  ? untracked  ↑ ahead  ↓ behind"
}

# Remove worktrees whose branches have been merged/deleted
# Shows candidates first, then asks for confirmation
# Usage: wt-prune [--force] [-y]
wt-prune() {
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$repo_root" ]]; then
    echo "Not inside a git repository"
    return 1
  fi

  # If inside a worktree, find main repo
  if [[ "$repo_root" == */.worktrees/* ]]; then
    repo_root="${repo_root%%/.worktrees/*}"
  fi

  local skip_confirm=false
  for arg in "$@"; do
    [[ "$arg" == "-y" ]] && skip_confirm=true
  done

  # Fetch latest remote state and clean up stale references
  echo "Fetching remote state..."
  git -C "$repo_root" fetch --prune 2>/dev/null
  git -C "$repo_root" worktree prune

  # Collect candidates
  local candidates=()
  local candidate_dirs=()
  local candidate_notes=()
  while IFS= read -r line; do
    local dir=$(echo "$line" | awk '{print $1}')
    local branch=$(echo "$line" | sed 's/.*\[\(.*\)\]/\1/')

    # Skip main repo
    [[ "$dir" == "$repo_root" ]] && continue
    # Skip if not in .worktrees
    [[ "$dir" != */.worktrees/* ]] && continue

    # Check if branch should be pruned:
    # - Local branch deleted entirely
    # - Remote tracking was set up but remote branch is now gone
    # - Branch is fully merged into dev
    # Branches that were never pushed (no upstream) are NOT pruned
    local gone=false
    if ! git -C "$repo_root" rev-parse --verify "refs/heads/$branch" &>/dev/null; then
      gone=true
    else
      local upstream=$(git -C "$repo_root" config "branch.$branch.remote" 2>/dev/null)
      if [[ -n "$upstream" ]] && ! git -C "$repo_root" rev-parse --verify "refs/remotes/origin/$branch" &>/dev/null; then
        gone=true
      elif git -C "$repo_root" merge-base --is-ancestor "refs/heads/$branch" dev 2>/dev/null; then
        gone=true
      fi
    fi

    if $gone; then
      # Note uncommitted changes in output
      local dirty=""
      if [[ -d "$dir" ]]; then
        dirty=$(git -C "$dir" status --porcelain 2>/dev/null)
      fi
      local marker=""
      [[ -n "$dirty" ]] && marker=" ⚠ uncommitted changes"
      candidates+=("$branch")
      candidate_dirs+=("$dir")
      candidate_notes+=("$marker")
    fi
  done < <(git -C "$repo_root" worktree list | grep -v "bare")

  # Nothing to do?
  if [[ ${#candidates[@]} -eq 0 ]]; then
    echo "No stale worktrees found."
    return 0
  fi

  # Show candidates
  echo ""
  echo "Will remove:"
  for i in {1..${#candidates[@]}}; do
    echo "  - ${candidate_dirs[$i]}  (${candidates[$i]})${candidate_notes[$i]}"
  done
  echo ""

  # Confirm
  if ! $skip_confirm; then
    printf "Proceed? [y/N] "
    read -r confirm
    [[ "$confirm" != [yY] ]] && echo "Aborted." && return 0
  fi

  # Remove
  local removed=()
  for i in {1..${#candidates[@]}}; do
    local dir="${candidate_dirs[$i]}"
    local branch="${candidates[$i]}"
    echo "Removing: $dir ($branch)"
    git -C "$repo_root" worktree remove --force "$dir" 2>/dev/null
    if [[ $? -eq 0 ]]; then
      removed+=("$branch")
    else
      echo "  Failed, trying manual cleanup..."
      rm -rf "$dir"
      git -C "$repo_root" worktree prune
      removed+=("$branch")
    fi
  done

  echo "Pruned ${#removed[@]} worktree(s): ${removed[*]}"
}
