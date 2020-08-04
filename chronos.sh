#!/bin/bash

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Symlinking dotfiles in $ABSOLUTE_PATH to $HOME"
ln -sf $ABSOLUTE_PATH/gitconfig $HOME/.gitconfig
ln -sf $ABSOLUTE_PATH/gitignore $HOME/.gitignore
ln -sf $ABSOLUTE_PATH/profile $HOME/.profile
ln -sfn $ABSOLUTE_PATH/vim $HOME/.vim
ln -sf $ABSOLUTE_PATH/vimrc $HOME/.vimrc
ln -sf $ABSOLUTE_PATH/vimrc_chronos $HOME/.vimrc_chronos
#ln -sf $ABSOLUTE_PATH/bash_lolcat $HOME/.bash_lolcat
ln -sf $ABSOLUTE_PATH/tern-project $HOME/.tern-project
ln -sf $ABSOLUTE_PATH/tmux.conf $HOME/.tmux.conf
cp $ABSOLUTE_PATH/gitconfig-user $HOME/.gitconfig-user

echo "Adds exec permissions to chronos home directory"
echo "sudo mount -i -o remount,exec /home/chronos/user" >> ~/.bashrc

echo "Installing chromebrew, ruby, and git"
curl -Ls git.io/vddgY | bash

echo "Installing nvm and node"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | NODE_VERSION=--lts bash
npm config set ignore-scripts true

echo "Installing git-completion"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $HOME/.git-completion.bash

echo "Installing crew vim"
crew install vim

echo "Installing the silver searcher (ag)"
crew install ag

echo "Installing fzf"
crew install fzf

echo "Installing go"
crew install go

#echo "Installing lolcat"
#gem install lolcat

echo "Installing figlet"
crew install figlet

echo "Adding ~/.profile to ~/.bashrc"
echo ". ~/.profile" >> ~/.bashrc

echo "Move to home directory after sourcing"
echo "cd" >> ~/.bashrc

echo "Installs python27 for node-sass binding"
crew install python27

echo "##########################################"
echo "#             Setup completed            #"
echo "##########################################"
echo ""
echo "1) source ~/.bashrc"
echo "2) vi ~/.gitconfig-user"
echo "3) :PlugInstall"
