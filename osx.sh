#!/bin/bash

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Symlinking dotfiles in $ABSOLUTE_PATH to $HOME"
ln -sf $ABSOLUTE_PATH/gitconfig $HOME/.gitconfig
ln -sf $ABSOLUTE_PATH/gitignore $HOME/.gitignore
ln -sf $ABSOLUTE_PATH/profile $HOME/.profile
ln -sfn $ABSOLUTE_PATH/vim $HOME/.vim
ln -sf $ABSOLUTE_PATH/vimrc $HOME/.vimrc
ln -sf $ABSOLUTE_PATH/vimrc_osx $HOME/.vimrc_osx
ln -sf $ABSOLUTE_PATH/bash_lolcat $HOME/.bash_lolcat
ln -sf $ABSOLUTE_PATH/tern-project $HOME/.tern-project
ln -sf $ABSOLUTE_PATH/tmux.conf $HOME/.tmux.conf
cp $ABSOLUTE_PATH/gitconfig-user $HOME/.gitconfig-user

echo "Installing git-completion"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $HOME/.git-completion.bash

echo "Installing homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing lolcat-c into /usr/bin/lolcat"
git clone https://github.com/dosentmatter/lolcat.git
cd lolcat
git submodule init
git submodule update
make lolcat
echo "To symlnk lolcat your sudo password is required."
sudo cp lolcat /usr/local/bin/
cd ..
rm -rf lolcat

echo "Installing nvm and node"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | NODE_VERSION=--lts bash
npm config set ignore-scripts true

echo "Installing figlet"
brew install figlet

echo "Installing ccat"
brew install ccat

echo "Installing SilverSearcher (ag)"
brew install the_silver_searcher

echo "Installing fzf"
brew install fzf

echo "Installing vim to include clipboard"
brew install vim

echo "Installing tmux"
brew install tmux

echo "Installing editorconfig core"
brew install editorconfig

echo "Installing nmap"
brew install nmap

echo "Disabling scrollbar in Terminal.app"
defaults write com.apple.Terminal AppleShowScrollBars -string WhenScrolling

echo "##########################################"
echo "#             Setup completed            #"
echo "##########################################"
echo ""
echo "1) source ~/.profile"
echo "2) vi ~/.gitconfig-user"
echo "3) :PlugInstall"
