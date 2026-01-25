export LC_ALL=en_US.UTF-8

PS1="$ \W :. "
export PATH="/usr/local/bin:/usr/local/sbin:$HOME/.local/bin:$HOME/.local/sbin:$PATH"
export CLICOLOR=1
export GPG_TTY=$(tty)

# History
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000

# Aliases
alias ..="cd .."
alias open="xdg-open"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias chrome='google-chrome-stable --ozone-platform=x11'

# Git aliases
alias gf="git fetch --all --prune"
alias gb="git branch"
alias gdm="git branch --merged | egrep -v \"(^\*|master)\" | xargs git branch -d"
alias gss="git submodule sync --recursive && git submodule update --init --recursive"
alias gs="git status"
alias gl="git log"

# Patching
pdiff () {
  if [ "$#" -ne 3 ]; then
    echo "Usage: pdiff <original> <modified> <output>"
    return 1
  fi

  git diff --no-index --patch --output=$3 $1 $2
}

# Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Git completion
if [ -f $HOME/.git-completion.bash ]; then
  . $HOME/.git-completion.bash
fi

if ccat -v >/dev/null 2>&1; then
  alias cat=ccat
fi


# Secrets
if [ -f $HOME/.secrets.bash ]; then
  . $HOME/.secrets.bash
fi

if [ -f $HOME/.cargo/env ]; then
  . "$HOME/.cargo/env"
fi

if [ -d $HOME/.tmux/plugins/tmuxifier/bin ]; then
  export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"
  eval "$(tmuxifier init -)"
  export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux/layouts"
fi

if [ -d $HOME/neovim ]; then
  export PATH="$HOME/neovim/usr/bin:$PATH"
  export SUDO_EDITOR=$HOME/neovim/usr/bin/nvim
else
  if [ -x "$(command -v curl)" ]; then
    echo "#################"
    echo "INSTALLING Neovim"
    echo "#################"
    echo ""
    curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage
    chmod +x nvim-linux-x86_64.appimage
    ./nvim-linux-x86_64.appimage --appimage-extract
    mv squashfs-root $HOME/neovim
    rm nvim-linux-x86_64.appimage
    export PATH="$HOME/neovim/usr/bin:$PATH"
  fi
fi

# Arch maintenance
alias orphans="pacman -Qtdq"
alias orphans-remove="sudo pacman -Rns \$(pacman -Qtdq) 2>/dev/null || echo 'No orphans'"
alias cache-clean="sudo paccache -r"
alias mirror-update="sudo reflector --country US --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist"
alias checkup="checkupdates"
