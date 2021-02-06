# zmodload zsh/zprof

# On slow systems, checking the cached .zcompdump file to see if it must be
# regenerated adds a noticable delay to zsh startup.  This little hack restricts
# it to once a day.  It should be pasted into your own completion file.
#
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.

# Load powerlevel10k configuration file
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

autoload -Uz +X compinit
autoload -Uz +X zcalc
# autoload -Uz +X bashcompinit
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
    # bashcompinit
else
    compinit -C
    # bashcompinit -C
fi

# Static call of zsh's plugins
gen_plugins_file(){
    antibody bundle < "${ZSH_CONFIG}/zsh_plugins.txt" \
        | perl -pe 's/fpath\+=\(\s+([^\s]+).*/idem_fpath_prepend $1/' \
        > "${ZSH_CONFIG}/zsh_plugins.sh"
}

# Source plugins
[ ! -f "${ZSH_CONFIG}/zsh_plugins.sh" ] && gen_plugins_file; source "${ZSH_CONFIG}/zsh_plugins.sh"
[ -f "${ZSH_CONFIG}/p10k.zsh" ] && source "${ZSH_CONFIG}/p10k.zsh"

#zsh's history
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# don't nice background tasks
setopt NO_BG_NICE
setopt NO_HUP
setopt NO_BEEP
# allow functions to have local options
setopt LOCAL_OPTIONS
# allow functions to have local traps
setopt LOCAL_TRAPS
# share history between sessions ???
setopt SHARE_HISTORY
# add timestamps to history
setopt EXTENDED_HISTORY
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
# adds history
setopt APPEND_HISTORY
# adds history incrementally and share it across sessions
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# don't record dupes in history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST
# dont ask for confirmation in rm globs*
setopt RM_STAR_SILENT
# lazy cd
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt nolistambiguous
setopt complete_aliases

# use cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.cache/zsh_cache

# forces zsh to realize new commands
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate

# fuzzy complete on mistype
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# remove traling slash on directory as argument
zstyle ':completion:*' squeeze-slashes true

# complete process' ID with menu selection
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# rehash if command not found (possibly recently installed)
zstyle ':completion:*' rehash true

# menu if nb items > 2
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Enable Vi mode
bindkey -v

# Lower vi key lag
export KEYTIMEOUT="12"

# Vi additional bindings
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey '^Y' autosuggest-accept
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^[[Z' reverse-menu-complete
bindkey -s jk '\e'

# AUTOSUGGEST color, different to bg
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4,bold'

# quick directory change
rationalise-dot() {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

if command -v sk >/dev/null 2>&1; then
[ -f "$XDG_CONFIG_HOME/skim/shell/key-bindings.zsh" ] && source "$XDG_CONFIG_HOME/skim/shell/key-bindings.zsh"
    export SKIM_DEFAULT_COMMAND="fd --hidden --ignore-case --follow \
         --exclude .git --exclude node_modules --exclude .hg --exclude .svn \
         --type d --type f --type l"
    export SKIM_DEFAULT_OPTIONS="--ansi --multi --reverse --height=40% \
         --bind='ctrl-j:page-down,ctrl-k:page-up,alt-j:preview-down,\
         alt-k:preview-up,alt-d:preview-page-down,alt-u:preview-page-up,\
         alt-o:execute('$EDITOR' {})+abort'
         --preview-window='right:66%' \
         --preview='bat --color=always --style=full {}'"
    export SKIM_CTRL_T_COMMAND=$SKIM_DEFAULT_COMMAND
    export SKIM_CTRL_T_OPTS=$SKIM_DEFAULT_OPTIONS
    export SKIM_CTRL_R_OPTS="--preview={} --preview-window=:hidden \
         --height=20% --bind=''"
    export SKIM_ALT_C_OPTS="$SKIM_CTRL_R_OPTS"
    _skim_compgen_path() {
        fd --ignore-case --follow --hidden --exclude .git --exclude .hg \
            --exclude .svn --type d --type f --type l . "$1"
    }

    _skim_compgen_dir() {
        fd --ignore-case --follow --hidden --exclude .git --exclude .hg \
            --exclude .svn --type d . "$1"
    }
fi

export GPG_TTY=$(tty)
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# Functions
mkcd() {
    mkdir -p "$1" && cd "$1" || return 1
}

own_pop() {
    updown="$1"
    shift
    popd -q "$updown$@"
}

own_push() {
    updown="$1"
    shift
    pushd -q "$updown$@"
}

cd_in() {
    dir="$1"
    cd "$1" && l
}

fkill() {
    ps -ef | sed 1d | sk --multi --preview-window=:hidden --regex
}

# Defines editor
if command -v nvim >/dev/null 2>&1; then
	export EDITOR=nvim
	alias vim=$EDITOR
else
	export EDITOR=vim
fi

gen_completions() {
    kubectl completion zsh | sed 's/kubectl/k/g' > $ZSH_COMPLETIONS/_kubectl
    gopass completion zsh  > $ZSH_COMPLETIONS/_gopass
}

[ -f $ZSH_CONFIG/aliases.sh ] && source $ZSH_CONFIG/aliases.sh

if (( ${+_comps[gopass]} )); then
 compdef gpw=gopass
fi

pyenv() {
    PYTHON=$(asdf which python)
    if [ -d "$PY_VENV/$1" ] && [ -f "$PY_VENV/$1/bin/activate" ]; then
        echo "Activating venv $1"
        source "$PY_VENV/$1/bin/activate"
    else
        echo "Creating venv $1 with python $PYTHON"
        $PYTHON -m venv "$PY_VENV/$1"
        echo "Activating venv $1"
        source "$PY_VENV/$1/bin/activate"
    fi
}

# Source not hardcoded sys env definition
[ -f "$XDG_CONFIG_HOME/zsh/local.zsh" ] && source "$XDG_CONFIG_HOME/zsh/local.zsh"

# Enable To debug loading times
# zprof
