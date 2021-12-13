#!/bin/bash

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Symlinking dotfiles in $ABSOLUTE_PATH to $HOME"
ln -sf $ABSOLUTE_PATH/gitconfig $HOME/.gitconfig
ln -sf $ABSOLUTE_PATH/gitignore $HOME/.gitignore
ln -sf $ABSOLUTE_PATH/profile $HOME/.profile
ln -sfn $ABSOLUTE_PATH/vim $HOME/.vim
ln -sf $ABSOLUTE_PATH/vimrc $HOME/.vimrc
ln -sf $ABSOLUTE_PATH/vimrc_wsl $HOME/.vimrc_wsl
ln -sf $ABSOLUTE_PATH/tern-project $HOME/.tern-project
ln -sf $ABSOLUTE_PATH/tmux.conf $HOME/.tmux.conf
ln -sf $ABSOLUTE_PATH/editorconfig $HOME/.editorconfig
cp $ABSOLUTE_PATH/gitconfig-user $HOME/.gitconfig-user

echo "Upgrading and updating apt"
sudo apt-get update -y
sudo apt-get upgrade -y

echo "Installing dependencies"
sudo apt-get install curl build-essential -y

echo "Installing nvm and node"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | NODE_VERSION=--lts bash
npm config set ignore-scripts true

echo "Installing git-completion"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $HOME/.git-completion.bash

echo "Installing the silver searcher (ag)"
sudo apt install silversearcher-ag -y

echo "Adding ~/.profile to ~/.bashrc"
echo ". ~/.profile" >> ~/.bashrc

echo "Installing tmux"
sudo apt install tmux -y

echo "Installing vim-gtk"
sudo apt install vim-gtk3 -y

echo "Installing editorconfig core"
sudo apt install editorconfig

echo "Setting max_user_waches for hot reloading to work properly"
echo 100000 | sudo tee /proc/sys/fs/inotify/max_user_watches
echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo "##########################################"
echo "#             Setup completed            #"
echo "##########################################"
echo ""
echo "1) source ~/.bashrc"
echo "2) vi ~/.gitconfig-user"
echo "3) :PlugInstall"
