# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks
setopt HIST_VERIFY          # Show command before executing from history
setopt SHARE_HISTORY        # Share history between sessions

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

bindkey '^[[3~' delete-char   
bindkey '^R' history-incremental-search-backward

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[3~' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[3~' vi-delete

# ################# #
# Aliases & Function
# ################# #

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
    sagu='sudo apt get update && sudo apt get upgrade'\
    sp='sudo pacman'\
    p='pacman' \
    sysup='sudo systemctl enable --now' \
    sysdn='sudo systemctl disable --now' \

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
  kcns='kubectl config set-context --current --namespace' \

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
  grao='git remote rm origin; git remote add origin'  &&
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

# Tmux nvim opencode IDE
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
    tmux new-session -d -s "$name" -n main -c "$dir" "nvim '$dir'"
    tmux split-window -h -t "$name:main" -c "$dir" "opencode '$dir'"
    tmux select-pane -L -t "$name:main"
    tmux attach -t "$name"
}
alias i="ide"

# list path to other zsh shell opened
lssh() {
  ps au |
    awk '$11 == "/usr/bin/zsh" || $11 == "/usr/sbin/zsh" || $11 == "/bin/zsh" { print $2 }' |
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

# Load syntax highlighting; should be last.
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
