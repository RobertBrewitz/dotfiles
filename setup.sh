#!/bin/bash

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Symlinking dotfiles in $ABSOLUTE_PATH to $HOME"
ln -sf $ABSOLUTE_PATH/gitconfig $HOME/.gitconfig
ln -sf $ABSOLUTE_PATH/gitignore $HOME/.gitignore
ln -sf $ABSOLUTE_PATH/profile $HOME/.profile
ln -sfn $ABSOLUTE_PATH/vim $HOME/.vim
ln -sf $ABSOLUTE_PATH/vimrc $HOME/.vimrc
ln -sf $ABSOLUTE_PATH/bash_lolcat $HOME/.bash_lolcat

echo "Installing git-completion"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $HOME/.git-completion.bash

echo "Installing lolcat-c into /usr/bin/lolcat"
git clone https://github.com/dosentmatter/lolcat.git
cd lolcat
git submodule init
git submodule update
make lolcat
cp lolcat /usr/local/bin/

echo "Cleaning up lolcat-c installation"
cd ..
rm -rf lolcat

echo "Installing figlet"
brew install figlet

echo "Installing ccat"
brew install ccat

echo "Installing SilverSearcher (ag)"
brew install the_silver_searcher

echo "Installing vim and cmake for YouCompleteMe"
brew install vim --with-override-system-vi
brew install cmake

echo "##########################################"
echo "#             Setup completed            #"
echo "##########################################"
echo ""
echo "1) source ~/.profile"
echo "2) vi"
echo "3) :PlugInstall"
echo "4) cd ~/.vim/plugged/YouCompleteMe/"
echo "5) ./install.py --js-completer"
