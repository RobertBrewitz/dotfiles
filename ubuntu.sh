#!/bin/bash

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Symlinking dotfiles in $ABSOLUTE_PATH to $HOME"
ln -sf $ABSOLUTE_PATH/gitconfig $HOME/.gitconfig
ln -sf $ABSOLUTE_PATH/gitignore $HOME/.gitignore
ln -sf $ABSOLUTE_PATH/profile $HOME/.profile
ln -sfn $ABSOLUTE_PATH/vim $HOME/.vim
ln -sf $ABSOLUTE_PATH/vimrc $HOME/.vimrc
ln -sfn $ABSOLUTE_PATH/nvim $HOME/.config/nvim
ln -sf $ABSOLUTE_PATH/vimrc_ubuntu $HOME/.vimrc_ubuntu
ln -sf $ABSOLUTE_PATH/tern-project $HOME/.tern-project
ln -sf $ABSOLUTE_PATH/tmux.conf $HOME/.tmux.conf
ln -sf $ABSOLUTE_PATH/editorconfig $HOME/.editorconfig
cp $ABSOLUTE_PATH/gitconfig-user $HOME/.gitconfig-user

echo "Upgrading and updating apt"
sudo apt-get update -y
sudo apt-get upgrade -y

echo "Installing dependencies"
sudo apt-get install curl build-essential software-properties-common xclip -y

echo "Installing fzf"
sudo apt-get install fzf -y

echo "Installing nvm and node"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | NODE_VERSION=--lts bash
npm config set ignore-scripts true

echo "Installing rust and rust-analyzer"
sudo apt-get install cmake libfontconfig1 -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer

echo "Installing git-completion"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $HOME/.git-completion.bash

echo "Installing the silver searcher (ag)"
sudo apt install silversearcher-ag -y

echo "Adding ~/.profile to ~/.bashrc"
echo ". ~/.profile" >> ~/.bashrc

echo "Installing tmux"
sudo apt install tmux -y

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
