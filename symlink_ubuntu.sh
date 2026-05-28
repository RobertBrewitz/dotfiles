#!/bin/bash

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
ln -sf $ABSOLUTE_PATH/make-completion.bash $HOME/.make-completion.bash
link_security_config "$ABSOLUTE_PATH/security/npmrc.conf" "$HOME/.npmrc"
link_security_config "$ABSOLUTE_PATH/security/bunfig.toml" "$HOME/.bunfig.toml"
link_security_config "$ABSOLUTE_PATH/security/yarnrc.yml" "$HOME/.yarnrc.yml"
mkdir -p $HOME/.config/pnpm $HOME/.config/renovate
link_security_config "$ABSOLUTE_PATH/security/pnpm.yaml" "$HOME/.config/pnpm/config.yaml"
link_security_config "$ABSOLUTE_PATH/security/renovate.json" "$HOME/.config/renovate/config.json"
cp --update=none $ABSOLUTE_PATH/gitconfig-user $HOME/.gitconfig-user
