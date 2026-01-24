#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure .config exists
mkdir -p "$HOME/.config"

# Root setup
echo "[ -f ~/.profile ] && source ~/.profile" | sudo tee -a /root/.bashrc > /dev/null
sudo ln -sf "$DOTFILES/root_profile" /root/.profile
sudo mkdir -p /root/.config
sudo ln -sfT "$DOTFILES/nvim" /root/.config/nvim

# User directories
ln -sfT "$DOTFILES/nvim" "$HOME/.config/nvim"

# User files
ln -sf "$DOTFILES/gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES/gitignore" "$HOME/.gitignore"
ln -sf "$DOTFILES/profile" "$HOME/.profile"
ln -sf "$DOTFILES/tern-project" "$HOME/.tern-project"
ln -sf "$DOTFILES/editorconfig" "$HOME/.editorconfig"

# Copy user-specific config only if it doesn't exist
[[ -f "$HOME/.gitconfig-user" ]] || cp "$DOTFILES/gitconfig-user" "$HOME/.gitconfig-user"

echo "Dotfiles linked."
