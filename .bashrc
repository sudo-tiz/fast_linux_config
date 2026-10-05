# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable colors and change prompt:
PS1='\[\e[1;31m\][\[\e[1;33m\]\u\[\e[1;32m\]@\[\e[1;34m\]\h \[\e[1;35m\]\w\[\e[1;31m\]]\[\e[0m\]$ '
stty stop undef # Disable ctrl-s to freeze terminal.

# History in cache directory:
HISTSIZE=10000000
HISTFILESIZE=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/bash/history"
# Create cache directory if it doesn't exist
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/bash"

# History options (bash equivalents)
HISTCONTROL=ignoreboth:erasedups # Don't record duplicate entries and entries starting with space
shopt -s histappend              # Append to history file, don't overwrite
shopt -s histverify              # Show command before executing from history

# Enable auto cd (bash 4.0+)
shopt -s autocd 2>/dev/null

# Basic auto/tab complete:
# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Include hidden files in completion
bind 'set match-hidden-files on'
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

# vi mode
set -o vi
export KEYTIMEOUT=1

# Bash vi mode cursor shapes and key bindings
bind 'set keymap vi-insert'
bind '"\e[3~": delete-char'
bind '"\C-r": reverse-search-history'

# Edit line in vim with ctrl-e:
bind '"\C-e": edit-and-execute-command'

# Cursor shape for vi modes (bash doesn't have native support, using workaround)
function set_cursor_beam() { echo -ne '\e[5 q'; }
function set_cursor_block() { echo -ne '\e[1 q'; }

# Set beam cursor on startup
set_cursor_beam

# Hook for prompt to reset cursor
PROMPT_COMMAND="set_cursor_beam; $PROMPT_COMMAND"

# COLOR & SHORTEN
alias \
  cp="cp -a" \
  mv="mv -i" \
  rm="rm -rf" \
  bc="bc -ql" \
  mkd="mkdir -pv" \
  mdtemp="cd $(mktemp -d)" \
  grep="grep --color=auto" \
  diff="diff --color=auto" \
  ip="ip -color=auto" \
  ls="ls -hN --color=auto --group-directories-first" \
  l="ls" \
  ll="ls -l" \
  la="ls -aF" \
  lla="ls -laF" \
  ...="cd ../.." \
  ....="cd ../../.." \
  .....="cd ../../../.." \
  sagi='sudo apt get install' \
  sagu='sudo apt get update && sudo apt get upgrade' \
  sp='sudo pacman' \
  p='pacman' \
  sysup='sudo systemctl enable --now' \
  sysdn='sudo systemctl disable --now'

# Use neovim for vim if present.
[ -x "$(command -v nvim)" ] && alias vim="nvim" vimdiff="nvim -d" v="nvim"

# LS / EZA
if command -v eza >/dev/null 2>&1; then
    l()   { eza -F -- "$@"; }
    ll()  { eza -lF -- "$@"; }
    la()  { eza -aF -- "$@"; }
    lla() { eza -laF -- "$@"; }
    lt()  { eza -TaF -- "$@"; }
    llt() { eza -Tal -- "$@"; }
else
    l()   { ls -F -- "$@"; }
    ll()  { ls -lF -- "$@"; }
    la()  { ls -aF -- "$@"; }
    lla() { ls -laF -- "$@"; }
    lt()  { ls -aF -- "$@"; }
    llt() { ls -laF -- "$@"; }
fi

# YAZI
if command -v yazi >/dev/null 2>&1; then
    yazi-cd() (
        local tmp dir
        tmp="$(mktemp)" || return 1
        trap 'rm -f -- "$tmp"' EXIT HUP INT QUIT TERM
        yazi --cwd-file "$tmp" "$@" || return
        if [[ -f "$tmp" ]]; then
            dir="$(<"$tmp")"
            if [[ -d "$dir" && "$dir" != "$PWD" ]]; then
                cd -- "$dir" && exec "${SHELL:-bash}"
            fi
        fi
    )
    alias y='yazi-cd'
fi


# TMUX
[ -x "$(command -v tmux)" ] && alias \
  t="tmux" \
  ta="tmux attach-session" \
  tnew="tmux new-session" \
  tls="tmux list-sessions" \
  tk="tmux kill-session" \
  tka="tmux kill-server" \

# DOCKER + COMPOSE
[ -x "$(command -v docker)" ] && alias \
  d="docker" \
  dps="docker ps" \
  dpsa="docker ps -a" \
  di="docker images" \
  dip="docker image pull" \
  drun="docker run" \
  dex="docker exec -it" \
  dl="docker logs" \
  dlf="docker logs -f" \
  dst="docker stop" \
  drm="docker rm" \
  drmi="docker rmi" \
  drestart="docker restart" \
  dinspect="docker inspect" \
  dtop="docker stats" \
  dnet="docker network ls" \
  dvol="docker volume ls" \
  dprune="docker system prune" \
  dc="docker compose" \
  dcup="docker compose up" \
  dcupd="docker compose up -d" \
  dcdown="docker compose down" \
  dcps="docker compose ps" \
  dcl="docker compose logs" \
  dclf="docker compose logs -f" \
  dce="docker compose exec" \
  dcrestart="docker compose restart" \
  dcbuild="docker compose build" \
  dcpull="docker compose pull"

# KUBECTL
[ -x "$(command -v kubectl)" ] && alias \
  k="kubectl" \
  ka="kubectl apply -f" \
  kg="kubectl get" \
  kd="kubectl describe" \
  kdel="kubectl delete" \
  kl="kubectl logs" \
  kgpo="kubectl get pod" \
  kgd="kubectl get deployments" \
  kl="kubectl logs -f" \
  ke="kubectl exec -it" \
  kcns='kubectl config set-context --current --namespace'

# GIT
[ -x "$(command -v git)" ] && alias \
  g="git" \
  gd="git diff" \
  gcl='git clone' \
  gull='git pull' \
  gullp='git stash && git pull && git stash pop' \
  gush='git push' \
  gusho='git push -f origin' \
  gash="git stash" \
  gashp="git stash" \
  gme= "git merge" \
  gmest="git merge stash" \
  gco='git commit -m' \
  gcoa='git commit -amend --no-edit' \
  ga='git add' \
  gr='git restore' \
  grs='git restore --staged' \
  greset1='git reset --hard HEAD~1' \
  gst='git -p status' \
  gl='git log --oneline --graph -20' \
  gll='git log ' \
  gl='git log' \
  gb='git branch' \
  gch="git checkout" \
  gchb="git checkout -b" \
  gsiu="git submodule init && git submodule update" \
  gsur="git submodule update --remote" \
  gls='ls --group-directories-first --color=auto -d $(git ls-tree $(git branch | grep \* | cut -d " " -f2) --name-only)' \
  gtree='ls --group-directories-first --color=auto -d $(git ls-tree -r $(git branch | grep \* | cut -d " " -f2) --name-only)' \
  grao='git remote rm origin; git remote add origin' &&
  gdi() { git diff --name-only --relative --diff-filter=d | xargs bat --diff; }

# VENV
alias \
  ve='python -m venv .venv' \
  va='source .venv/bin/activate || source .env/bin/activate' \
  veva='python -m venv .venv && source .venv/bin/activate' \
  da='deactivate'
#
# Copy progress bar
[ -x "$(command -v rsync)" ] && alias \
  cpv='rsync -ah --info=progress2' \
  mvv='rsync -ah --remove-source-files --info=progress2'

ide() {
    local dir="${1:-.}"
    local name
    dir="$(cd "$dir" && pwd -P)" || return 1
    name="${dir#$HOME/}"
    name="${name//[^a-zA-Z0-9_-]/-}"
    if tmux has-session -t "$name" 2>/dev/null; then
        tmux attach -t "$name"
        return
    fi
    tmux new-session -d \
        -s "$name" \
        -n main \
        -c "$dir" \
        "nvim '$dir'"
    tmux split-window -h \
        -t "$name:main" \
        -c "$dir" \
        "zsh -ic 'opc \"\$1\"' _ '$dir'"
    tmux select-pane -L -t "$name:main"
    tmux split-window -v \
        -t "$name:main" \
        -c "$dir" \
        "zsh"
    tmux resize-pane -y 2 \
        -t "$name:main"
    tmux attach -t "$name"
}

# list path to other zsh shell opened
lssh() {
  ps au |
    awk '$11 == "/usr/bin/zsh" || $11 == "/bin/zsh" { print $2 }' |
    xargs pwdx |
    awk '{ print $2 }' |
    sed -n "\|^${2}.*|p" |
    sort -u |
    nl
}
# cd to path of another shell, using fzf as selector
cs() {
  if command -v fzf &>/dev/null; then
    cmd1=$(lssh | fzf --select-1 --query "$1" --height=~50 | cut -f 2)
  else
    echo "Select a shell to change directory to:"
    lssh
    read selection
    cmd1=$(lssh | awk -v sel="$selection" 'NR == sel { print $2 }')
  fi
  cmd="cd $cmd1"
  print -S $cmd
  eval $cmd
}

# qrencode any file and print it
[ -x "$(command -v convert)" ] && qr(){
  local o; o=$(mktemp) && qrencode -r "$1" -o "$o" -t UTF8 && cat "$o";
}

ch() { curl "http://cheat.sh/$1"; }
# Backup functions
old() { mv "$1" "$1.old"; }
bak() { cp "$1" "$1.bak"; }
baktar() { tar -zcvf "${1}_$(date '+%Y-%m-%d_%H-%M').tar.gz" "$1"; }

# Load bash syntax highlighting if available
if [ -f /usr/share/bash-syntax-highlighting/bash-syntax-highlighting.sh ]; then
  source /usr/share/bash-syntax-highlighting/bash-syntax-highlighting.sh 2>/dev/null
fi
