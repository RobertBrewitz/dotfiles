#!/bin/bash

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Symlinking dotfiles in $ABSOLUTE_PATH to $HOME"
ln -sf $ABSOLUTE_PATH/gitconfig $HOME/.gitconfig
ln -sf $ABSOLUTE_PATH/gitignore $HOME/.gitignore
ln -sf $ABSOLUTE_PATH/profile $HOME/.profile
ln -sfn $ABSOLUTE_PATH/nvim $HOME/.config/nvim
ln -sf $ABSOLUTE_PATH/tern-project $HOME/.tern-project
ln -sf $ABSOLUTE_PATH/tmux.conf $HOME/.tmux.conf
ln -sf $ABSOLUTE_PATH/editorconfig $HOME/.editorconfig
cp $ABSOLUTE_PATH/gitconfig-user $HOME/.gitconfig-user

echo "Symlinking root dotfiles in $ABSOLUTE_PATH to /root"
echo "[ -f ~/.profile ] && source ~/.profile" | sudo tee -a /root/.bashrc
sudo ln -sf $ABSOLUTE_PATH/root_profile /root/.profile
sudo ln -sfn $ABSOLUTE_PATH/nvim /root/.config/nvim

echo "Upgrading and updating apt"
sudo apt-get update -y
sudo apt-get upgrade -y

echo "Disable auto update and upgrade"
sudo systemctl stop apt-daily.timer
sudo systemctl stop apt-daily-upgrade.timer
sudo systemctl stop apt-daily.service
sudo systemctl stop apt-daily-upgrade.service
sudo systemctl disable apt-daily.timer
sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl mask apt-daily.service
sudo systemctl mask apt-daily-upgrade.service
sudo systemctl daemon-reload
sudo systemctl reset-failed

echo "Disabling ubuntu auto upgrades"
sudo sed -i 's/1/0/g' /etc/apt/apt.conf.d/20auto-upgrades

echo "Installing dependencies"
sudo apt-get install curl pkg-config build-essential software-properties-common xclip -y

echo "Installing jq"
sudo apt-get install jq -y

echo "Install some work dependencies"
sudo apt-get install libssl-dev libudev-dev libasound2-dev -y

echo "Installing mold and clang for rust compilation"
sudo apt-get install mold clang -y

echo "Installing ripgrep and fd-find"
sudo apt install ripgrep fd-find -y

echo "Installing nvm and node"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | NODE_VERSION=--lts bash
npm config set ignore-scripts true

echo "Installing rust and rust-analyzer"
sudo apt-get install cmake libfontconfig1 -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.profile
rustup component add rust-analyzer
cargo install cross --git https://github.com/cross-rs/cross

echo "Installing git-completion"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $HOME/.git-completion.bash

echo "Installing the silver searcher (ag)"
sudo apt install silversearcher-ag -y

echo "Adding ~/.profile to ~/.bashrc"
echo "[ -f ~/.profile ] && source ~/.profile" | sudo tee -a ~/.bashrc

echo "Installing tmux"
sudo apt install tmux -y

echo "Installing tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Installing editorconfig core"
sudo apt install editorconfig -y

echo "Setting up 33ms key-repeat with 201ms delay"
gsettings set org.gnome.desktop.peripherals.keyboard repeat true
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 33
gsettings set org.gnome.desktop.peripherals.keyboard delay 201

echo "Setting max_user_waches for hot reloading to work properly"
echo 100000 | sudo tee /proc/sys/fs/inotify/max_user_watches
echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo "UFW setup"
sudo apt install ufw
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

echo "##########################################"
echo "#             Setup completed            #"
echo "##########################################"
echo ""
echo "1) source ~/.bashrc"
echo "2) vi ~/.gitconfig-user"
echo "3) :PlugInstall"
