#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link_security_config() {
    local source="$1"
    local target="$2"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        return
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        local counter=1
        while [ -e "$backup" ] || [ -L "$backup" ]; do
            backup="${target}.backup.$(date +%Y%m%d%H%M%S).$counter"
            counter=$((counter + 1))
        done
        echo "Warning: backing up existing $target to $backup before linking security config."
        mv "$target" "$backup"
    fi

    ln -sf "$source" "$target"
}

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
ln -sfT "$DOTFILES/config/mako" "$HOME/.config/mako"
mkdir -p "$HOME/.config/audacious"
ln -sf "$DOTFILES/config/audacious/config" "$HOME/.config/audacious/config"

# User applications (desktop entries)
mkdir -p "$HOME/.local/share/applications"
ln -sf "$DOTFILES/config/applications/google-chrome.desktop" "$HOME/.local/share/applications/google-chrome.desktop"

# User bin scripts
mkdir -p "$HOME/.local/bin"
ln -sf "$DOTFILES/bin/less" "$HOME/.local/bin/less"
ln -sf "$DOTFILES/bin/capture" "$HOME/.local/bin/capture"
ln -sf "$DOTFILES/bin/battery-monitor" "$HOME/.local/bin/battery-monitor"
ln -sf "$DOTFILES/bin/launch-waybar" "$HOME/.local/bin/launch-waybar"
ln -sf "$DOTFILES/bin/caffeine" "$HOME/.local/bin/caffeine"
ln -sf "$DOTFILES/bin/powermenu" "$HOME/.local/bin/powermenu"

# User files
ln -sf "$DOTFILES/gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES/gitignore" "$HOME/.gitignore"
ln -sf "$DOTFILES/profile" "$HOME/.profile"
ln -sf "$DOTFILES/tern-project" "$HOME/.tern-project"
ln -sf "$DOTFILES/editorconfig" "$HOME/.editorconfig"
link_security_config "$DOTFILES/security/npmrc.conf" "$HOME/.npmrc"
link_security_config "$DOTFILES/security/bunfig.toml" "$HOME/.bunfig.toml"
link_security_config "$DOTFILES/security/yarnrc.yml" "$HOME/.yarnrc.yml"
ln -sf "$DOTFILES/make-completion.bash" "$HOME/.make-completion.bash"
ln -sf "$DOTFILES/tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$HOME/.config/pnpm" "$HOME/.config/renovate"
link_security_config "$DOTFILES/security/pnpm.yaml" "$HOME/.config/pnpm/config.yaml"
link_security_config "$DOTFILES/security/renovate.json" "$HOME/.config/renovate/config.json"

# Copy user-specific config only if it doesn't exist
[[ -f "$HOME/.gitconfig-user" ]] || cp "$DOTFILES/gitconfig-user" "$HOME/.gitconfig-user"

# Reload Hyprland config (only if a Hyprland session is running)
if command -v hyprctl &> /dev/null && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    hyprctl reload
fi

echo "Dotfiles linked."
