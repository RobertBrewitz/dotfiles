export LC_ALL=en_US.UTF-8

PS1="\W :. "
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=0
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

##
# Rainbow stuff
if [ -f $HOME/.bash_lolcat ]; then
  . $HOME/.bash_lolcat
fi

if lolcat --version >/dev/null 2>&1; then
  function l() {
    if [ -n "$1" ]; then
      ls -al "$1" | lolcat;
    else
      ls -al | lolcat;
    fi
  }

  alias l=l
  alias gl="git log | lolcat | less --raw"

  if figlet -v >/dev/null 2>&1; then
    echo "Focus, commitment, and sheer fn will!" | figlet | lolcat
  else
    echo "Focus, commitment, and sheer fn will!" | lolcat
  fi
fi

if ccat -v >/dev/null 2>&1; then
  alias cat=ccat
fi

alias ll="l"

export GPG_TTY=$(tty)
