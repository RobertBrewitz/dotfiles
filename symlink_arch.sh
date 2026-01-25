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

# User directories
ln -sfT "$DOTFILES/config/hypr" "$HOME/.config/hypr"
ln -sfT "$DOTFILES/config/kitty" "$HOME/.config/kitty"
ln -sfT "$DOTFILES/config/waybar" "$HOME/.config/waybar"
ln -sfT "$DOTFILES/config/gtk-3.0" "$HOME/.config/gtk-3.0"
ln -sfT "$DOTFILES/config/gtk-4.0" "$HOME/.config/gtk-4.0"
ln -sfT "$DOTFILES/config/wofi" "$HOME/.config/wofi"
ln -sfT "$DOTFILES/config/dunst" "$HOME/.config/dunst"

# User applications (desktop entries)
mkdir -p "$HOME/.local/share/applications"
ln -sf "$DOTFILES/config/applications/google-chrome.desktop" "$HOME/.local/share/applications/google-chrome.desktop"

# User bin scripts
mkdir -p "$HOME/.local/bin"
ln -sf "$DOTFILES/bin/less" "$HOME/.local/bin/less"

# User files
ln -sf "$DOTFILES/gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES/gitignore" "$HOME/.gitignore"
ln -sf "$DOTFILES/profile" "$HOME/.profile"
ln -sf "$DOTFILES/tern-project" "$HOME/.tern-project"
ln -sf "$DOTFILES/editorconfig" "$HOME/.editorconfig"

# Copy user-specific config only if it doesn't exist
[[ -f "$HOME/.gitconfig-user" ]] || cp "$DOTFILES/gitconfig-user" "$HOME/.gitconfig-user"

# Reload Hyprland config
hyprctl reload

echo "Dotfiles linked."
