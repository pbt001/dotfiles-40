# credits github.com/sorin-ionescu/prezto

# zplug
export ZPLUG_HOME=$HOME/.zplug
export PATH=$ZPLUG_HOME/bin:$PATH
source $ZPLUG_HOME/init.zsh
zplug "zplug/zplug", at:2.4.2  # don't forget to zplug update --self && zplug update

zplug "sorin-ionescu/prezto", as:plugin, use:init.zsh, hook-build:"ln -s $ZPLUG_HOME/repos/sorin-ionescu/prezto ~/.zprezto"
zstyle ':prezto:*:*' case-sensitive 'no'
zstyle ':prezto:*:*' color 'yes'
zstyle ':prezto:load' pmodule \
    'environment' \
    'history' \
    'terminal' \
    'utility' \
    'tmux' \
    'completion' \
    'gpg' \
    ;
zstyle ':prezto:module:terminal' auto-title 'yes'

zplug "Tarrasch/zsh-bd", use:bd.zsh
zplug "chriskempson/base16-shell", use:"scripts/base16-eighties.sh"
zplug "djui/alias-tips"
zplug "github/hub", from:gh-r, use:"*linux*amd*", as:command
zplug "mafredri/zsh-async", from:github, at: "no-zpty"
zplug "denysdovhan/spaceship-prompt", from:github, use:spaceship.zsh, as:theme
zplug "paulirish/git-open", as:command
zplug "scmbreeze/scm_breeze", hook-build:"$ZPLUG_HOME/repos/scmbreeze/scm_breeze/install.sh"
zplug "tj/git-extras", use:"bin/*", as:command, hook-build:"make install PREFIX=$HOME/.git-extras"
zplug "zsh-users/zsh-autosuggestions"
zplug "b4b4r07/enhancd", use:init.sh, defer:1  # after prezto
zplug "zsh-users/zsh-syntax-highlighting", defer:2  # after compinit
zplug "zsh-users/zsh-history-substring-search", defer:2

zplug load

# options

# disable C-s stopping receiving keyboard signals.
stty start undef
stty stop undef

setopt COMPLETE_ALIASES
unsetopt CORRECT
setopt MENU_COMPLETE
setopt NO_NOMATCH
setopt PROMPT_SUBST

# completion options
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt PATH_DIRS
setopt AUTO_LIST
setopt AUTO_PARAM_SLASH
setopt EXTENDED_GLOB
setopt FLOW_CONTROL

# vi mode
bindkey -v
# export KEYTIMEOUT=1  # 100 ms vim mode change key timeout
bindkey -M viins 'jj' vi-cmd-mode
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^b' backward-word
bindkey '^f' forward-word
bindkey '^p' up-history  # Use vim cli mode
bindkey '^n' down-history
bindkey '^?' backward-delete-char  # backspace and ^h working even after returning from command mode
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word  # ctrl-w removed word backwards
bindkey '^r' history-incremental-search-backward  # ctrl-r starts searching history backward

autoload -Uz colors && colors
autoload -Uz promptinit && promptinit

# syntax highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern root line)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[path_prefix]='none'

# history substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# enhancd
if zplug check b4b4r07/enhancd; then
    export ENHANCD_FILTER=fzf-tmux
    export ENHANCD_DISABLE_DOT=1
    export ENHANCD_DISABLE_HYPHEN=1
fi

# python
export PATH=$HOME/.local/bin:$PATH
# js
export PATH=$HOME/.node_modules/bin:$PATH

# ruby
export PATH=$(ruby -e 'print Gem.user_dir')/bin:$PATH

# golang
GO_VERSION=go1.9.2
export GOROOT=$HOME/Documents/golang/$GO_VERSION
export GOPATH=$HOME/.golang/$GO_VERSION
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
alias $GO_VERSION=$GOROOT/bin/go
alias go=$GO_VERSION

# scm_breeze
[ -s "/home/ory/.scm_breeze/scm_breeze.sh" ] && source "/home/ory/.scm_breeze/scm_breeze.sh"

# travis
[ -f /home/ory/.travis/travis.sh ] && source /home/ory/.travis/travis.sh

# git-extras
export PATH=$HOME/.git-extras:$PATH

# source secret env keys, etc.
source $HOME/.zsh-secrets

# aliases

alias c="cd"
alias c-="c -"
alias cd..="cd .."

alias tailf="tail -f"
alias lnav="lnav -q"

alias ag="ag --smart-case --follow --group"
alias agl="ag --pager less"

alias js="node"
alias tree="tree -C"
alias vi="vim"
alias viupdate="vi '+PlugUpgrade' '+PlugUpdate!' '+qall!'"
# alias xclip="xclip -selection clipboard"

# tcpdump all requests made by given process
alias sysdig="sudo sysdig"
alias csysdig="sudo csysdig"
httpdump() { sysdig -s 2000 -A -c echo_fds proc.name=$1; }

# git
alias gc="g c"
alias ga="g add"
alias gmv="g mv"
alias grs="git reset"
alias gl="g l"
alias gll="g ll"
alias gd="git d"
alias gds="git ds"
alias gdc="git dc"
alias gsh="g sh"
alias grp="g rp"
alias gbr="g br"
alias gbdr="g bdr"
alias gbdm="g bdm"
alias gprune="g prune"

# docker
alias docker='jq -s "reduce .[] as \$x ({}; . * \$x)" $HOME/.docker/config.d/*.json > ~/.docker/config.json && docker'
alias dr="sudo docker run --rm -it"
alias di="sudo docker images | head -n 1 && sudo docker images | tail -n +2 | sort"
alias dps="sudo docker ps -a"
alias drm="sudo docker rm"
alias drmi="sudo docker rmi"
alias drmcd='drm $(dps -q -f status=exited -f status=created)'
alias drmvd='sudo docker volume rm $(sudo docker volume ls -q -f dangling=true)'
alias drmid='drmi $(sudo docker images -q -f dangling=true)'
# alias drmid="docker images -q -f dangling=true | tr '\n' ' ' | xargs docker rmi -f && \
#     docker images | grep \"^<none>\" | awk \"{print $3}\" | tr '\n' ' ' | tr '\n' ' ' | xargs docker rmi -f"
alias dpurge="drmcd ; drmvd ; drmid ;sudo docker network prune -f"
alias dc="sudo docker-compose"

alias vg=vagrant
alias graph="graph-easy --from dot --as boxart --stats"
# alias tmux="tmux attach -t ory"

# stow
alias stowusr="sudo stow -vR -t /usr usr"
alias stowetc="sudo stow -vR -t /etc etc"
alias stowopt="sudo stow -vR -t /opt opt"

# yaml2json
yaml2json() { python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' }
json2yaml() { python -c 'import sys, yaml, json; yaml.dump(json.load(sys.stdin), sys.stdout, indent=4)' }
