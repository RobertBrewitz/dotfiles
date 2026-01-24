#!/bin/bash

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# root
echo "[ -f ~/.profile ] && source ~/.profile" | sudo tee -a /root/.bashrc
sudo ln -sf $ABSOLUTE_PATH/root_profile /root/.profile
sudo mkdir -p /root/.config
sudo ln -sT $ABSOLUTE_PATH/nvim /root/.config/nvim

# dirs
ln -sT $ABSOLUTE_PATH/config/rio $HOME/.config/rio
ln -sT $ABSOLUTE_PATH/nvim $HOME/.config/nvim
ln -sT $ABSOLUTE_PATH/tmux/layouts $HOME/.tmux/layouts

# files
ln -sf $ABSOLUTE_PATH/gitconfig $HOME/.gitconfig
ln -sf $ABSOLUTE_PATH/gitignore $HOME/.gitignore
ln -sf $ABSOLUTE_PATH/profile $HOME/.profile
ln -sf $ABSOLUTE_PATH/tern-project $HOME/.tern-project
ln -sf $ABSOLUTE_PATH/tmux.conf $HOME/.tmux.conf
ln -sf $ABSOLUTE_PATH/editorconfig $HOME/.editorconfig
cp --update=none $ABSOLUTE_PATH/gitconfig-user $HOME/.gitconfig-user

