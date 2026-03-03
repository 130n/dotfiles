#!/usr/bin/env bash
# Sets up symlinks from dotfiles repo to their expected locations.
#
# Usage:
#   chmod +x ~/dotfiles/setup_dotfiles.sh
#   ~/dotfiles/setup_dotfiles.sh
#
# Existing files (not symlinks) are backed up with .bak suffix.
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$1" dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Backing up $dest -> ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi
  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

# Zsh
link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Tmux (requires gpakosz/.tmux cloned to ~/.tmux)
if [ -d "$HOME/.tmux" ]; then
  link "$DOTFILES_DIR/.tmux.conf.local" "$HOME/.tmux/.tmux.conf.local"
else
  echo "Skipping tmux: ~/.tmux not found (clone https://github.com/gpakosz/.tmux first)"
fi

# Neovim
mkdir -p "$HOME/.config"
link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
