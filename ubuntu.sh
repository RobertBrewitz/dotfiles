#!/bin/bash

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Symlinking dotfiles in $ABSOLUTE_PATH to $HOME"
ln -sf $ABSOLUTE_PATH/gitconfig $HOME/.gitconfig
ln -sf $ABSOLUTE_PATH/gitignore $HOME/.gitignore
ln -sf $ABSOLUTE_PATH/profile $HOME/.profile
ln -sfn $ABSOLUTE_PATH/vim $HOME/.vim
ln -sf $ABSOLUTE_PATH/vimrc $HOME/.vimrc
ln -sf $ABSOLUTE_PATH/vimrc_ubuntu $HOME/.vimrc_ubuntu
ln -sf $ABSOLUTE_PATH/bash_lolcat $HOME/.bash_lolcat
ln -sf $ABSOLUTE_PATH/tern-project $HOME/.tern-project
ln -sf $ABSOLUTE_PATH/tmux.conf $HOME/.tmux.conf
cp $ABSOLUTE_PATH/gitconfig-user $HOME/.gitconfig-user

echo "Upgrading and updating apt"
sudo apt-get update -y
sudo apt-get upgrade -y

echo "Installing dependencies"
sudo apt-get install curl build-essential -y

echo "Installing fzf"
sudo apt-get install fzf -y

echo "Installing nvm and node"
if [! -d "$HOME/.nvm"]; then
  mkdir $HOME/.nvm
fi
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
nvm install --lts

echo "Installing git-completion"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $HOME/.git-completion.bash

echo "Installing lolcat-c into /usr/local/bin/lolcat"
git clone https://github.com/dosentmatter/lolcat.git
cd lolcat
make
sudo make install
cd ..
rm -rf lolcat

echo "Installing the silver searcher (ag)"
sudo apt install silversearcher-ag -y

echo "Installing figlet"
sudo apt install figlet -y

echo "Adding ~/.profile to ~/.bashrc"
echo ". ~/.profile" >> ~/.bashrc

echo "Installing tmux"
sudo apt install tmux -y

echo "Installing vim-gtk3"
sudo apt install vim-gtk3 -y

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

echo "##########################################"
echo "#             Setup completed            #"
echo "##########################################"
echo ""
echo "1) source ~/.bashrc"
echo "2) vi ~/.gitconfig-user"
echo "3) :PlugInstall"
