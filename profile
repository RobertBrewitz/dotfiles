export LC_ALL=en_US.UTF-8

PS1="\W :. "
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=10000
export PROMPT_COMMAND="history -a; history -c; history -r"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export CLICOLOR=1

# Aliases
alias ..="cd .."
alias vi="vim"
alias gf="git fetch --all --prune"
alias gb="git branch"
alias gdm="git branch --merged | egrep -v \"(^\*|master)\" | xargs git branch -d"
alias gss="git submodule sync --recursive && git submodule update --init --recursive"
alias gs="git status"
alias gl="git log"
alias l="ls -al"
alias nodetrace="node --trace-event-categories v8,node,node.async_hooks"
alias gd="git diff -- ':!package-lock.json' ':!yarn.lock'"
alias gds="git diff --stat -- ':!package-lock.json' ':!yarn.lock'"
alias open="xdg-open"

# apt
alias aptup="sudo apt update && sudo apt upgrade"
alias aptclean="sudo apt autoremove --purge && dpkg -l | grep '^rc' | awk '{print $2}' | sudo xargs dpkg --purge"
alias aptlist="sudo apt list --installed"

# Docker & K8s
alias kn="kubens"
alias kx="kubectx"
alias k="kubectl"
alias mk="minikube"
alias dk="docker"
alias dkc="docker-compose"

# Fuzzy finder FZF
export FZF_DEFAULT_OPTS='--bind "alt-a:select-all,alt-d:deselect-all"'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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

alias ll="l"

export GPG_TTY=$(tty)

# Secrets
if [ -f $HOME/.secrets.bash ]; then
  . $HOME/.secrets.bash
fi

if [ -f $HOME/.cargo/env ]; then
  . "$HOME/.cargo/env"
fi

if [ -d $HOME/neovim ]; then
  export PATH="$HOME/neovim/usr/bin:$PATH"
else
  if [ -x "$(command -v curl)" ]; then
    echo "#################"
    echo "INSTALLING Neovim"
    echo "#################"
    echo ""
    curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
    chmod +x nvim.appimage
    ./nvim.appimage --appimage-extract
    mv squashfs-root $HOME/neovim
    rm nvim.appimage
    export PATH="$HOME/neovim/usr/bin:$PATH"
  fi
fi
