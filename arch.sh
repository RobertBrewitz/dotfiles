#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Upgrading and updating pacman"
sudo pacman -Syu --noconfirm

echo "Installing dependencies"
sudo pacman -S --noconfirm --needed curl pkgconf base-devel wl-clipboard unzip

echo "Installing yay (AUR helper)"
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd -
fi

echo "Installing Neovim"
sudo pacman -S --noconfirm --needed neovim

echo "Installing Hyprland and dependencies"
sudo pacman -S --noconfirm --needed \
    hyprland \
    hyprlock \
    hypridle \
    hyprpaper \
    kitty \
    wofi \
    xdg-desktop-portal-hyprland \
    polkit-kde-agent \
    pipewire \
    wireplumber \
    pipewire-pulse \
    qt5-wayland \
    qt6-wayland \
    brightnessctl \
    power-profiles-daemon \
    libnotify \
    dunst

echo "Installing basic fonts"
sudo pacman -S --noconfirm --needed noto-fonts noto-fonts-emoji ttf-liberation ttf-dejavu

echo "Enabling power-profiles-daemon"
sudo systemctl enable --now power-profiles-daemon

echo "Installing Google Chrome from AUR"
yay -S --noconfirm google-chrome

echo "Installing jq"
sudo pacman -S --noconfirm --needed jq

echo "Install some work dependencies"
sudo pacman -S --noconfirm --needed openssl systemd-libs alsa-lib

echo "Installing mold and clang for rust compilation"
sudo pacman -S --noconfirm --needed mold clang

echo "Installing ripgrep and fd"
sudo pacman -S --noconfirm --needed ripgrep fd

echo "Installing nvm and node"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | NODE_VERSION=--lts bash
npm config set ignore-scripts true

echo "Installing rust and rust-analyzer"
sudo pacman -S --noconfirm --needed cmake fontconfig
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.profile
rustup component add rust-analyzer
cargo install cross --git https://github.com/cross-rs/cross

echo "Installing git-completion"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $HOME/.git-completion.bash

echo "Installing the silver searcher (ag)"
sudo pacman -S --noconfirm --needed the_silver_searcher

echo "Adding ~/.profile to ~/.bashrc"
echo "[ -f ~/.profile ] && source ~/.profile" | sudo tee -a ~/.bashrc

echo "Installing editorconfig core"
sudo pacman -S --noconfirm --needed editorconfig-core-c

echo "Setting max_user_watches for hot reloading to work properly"
echo 100000 | sudo tee /proc/sys/fs/inotify/max_user_watches
echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo "UFW setup"
sudo pacman -S --noconfirm --needed ufw
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

echo "Installing UbuntuSans Nerd Font"
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/UbuntuSans.zip
unzip UbuntuSans.zip
rm UbuntuSans.zip
fc-cache -fv
cd -

echo "Fix crackling audio in pipewire"
sudo sed -i 's/#pulse.min.quantum      = 128/pulse.min.quantum      = 1024/g' /usr/share/pipewire/pipewire-pulse.conf
sudo systemctl --user restart wireplumber pipewire pipewire-pulse

echo "Installing bootloader utilities (os-prober for dual boot)"
sudo pacman -S --noconfirm --needed os-prober efibootmgr
sudo sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Installing WiFi (NetworkManager)"
sudo pacman -S --noconfirm --needed networkmanager network-manager-applet
sudo systemctl enable --now NetworkManager

echo "Installing Bluetooth"
sudo pacman -S --noconfirm --needed bluez bluez-utils blueman
sudo systemctl enable --now bluetooth

echo "Installing SDDM display manager"
sudo pacman -S --noconfirm --needed sddm qt6-svg qt6-declarative
yay -S --noconfirm catppuccin-sddm-theme-mocha
sudo mkdir -p /etc/sddm.conf.d
cat << 'EOF' | sudo tee /etc/sddm.conf.d/10-wayland.conf
[General]
DisplayServer=wayland

[Theme]
Current=catppuccin-mocha

[Wayland]
SessionDir=/usr/share/wayland-sessions
EOF
sudo systemctl enable sddm

echo "Installing printing (CUPS)"
sudo pacman -S --noconfirm --needed cups cups-pdf avahi nss-mdns system-config-printer
sudo systemctl enable --now cups
sudo systemctl enable --now avahi-daemon
sudo sed -i 's/hosts: mymachines/hosts: mymachines mdns_minimal [NOTFOUND=return]/' /etc/nsswitch.conf

echo "Installing display settings tool"
sudo pacman -S --noconfirm --needed wdisplays

echo "Installing Thunar file manager"
sudo pacman -S --noconfirm --needed thunar thunar-volman thunar-archive-plugin gvfs tumbler ffmpegthumbnailer

echo "Installing Waybar and dependencies"
sudo pacman -S --noconfirm --needed waybar otf-font-awesome pavucontrol

echo "Installing screenshot and recording tools"
sudo pacman -S --noconfirm --needed grim slurp wf-recorder

echo "Installing media controls and clipboard manager"
sudo pacman -S --noconfirm --needed playerctl cliphist

echo "Installing system maintenance tools"
sudo pacman -S --noconfirm --needed pacman-contrib reflector
sudo systemctl enable --now paccache.timer

echo "Installing GTK/Qt theming"
sudo pacman -S --noconfirm --needed qt6ct kvantum papirus-icon-theme
yay -S --noconfirm catppuccin-gtk-theme-mocha kvantum-theme-catppuccin-git catppuccin-cursors-mocha

echo "Configuring Kvantum theme"
kvantummanager --set catppuccin-mocha-blue

echo "Symlinking dotfiles"
"$DOTFILES/symlink_arch.sh"

echo "##########################################"
echo "#             Setup completed            #"
echo "##########################################"
echo ""
echo "Next steps:"
echo "1) source ~/.bashrc"
echo "2) vi ~/.gitconfig-user"
echo "3) Open nvim and let plugins install"
echo "4) Reboot to start SDDM"
