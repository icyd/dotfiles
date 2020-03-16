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
autoload -Uz compinit
autoload -Uz zcalc
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Static call of zsh's plugins
gen_plugins_file(){
    antibody bundle < "${ZSH_CONFIG}/zsh_plugins.txt" > "${ZSH_CONFIG}/zsh_plugins.sh"
}

# Source plugins
[ ! -f "${ZSH_CONFIG}/zsh_plugins.sh" ] && gen_plugins_file; source "${ZSH_CONFIG}/zsh_plugins.sh"

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
setopt COMPLETE_ALIASES
# lazy cd
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt nolistambiguous

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

zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

# Enable Vi mode
bindkey -v

# Lower vi key lag
export KEYTIMEOUT="15"

# Vi additional bindings
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey '^L' autosuggest-accept
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
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

if [ -z "$SERVER_MODE" ]; then
    if command -v rg >/dev/null; then
        # Configure fzf to use ripgrep
        export FZF_CTRL_T_OPTS="--select-1 --exit-0"
        export FZF_ALT_C_COMMAND='rg --files --hidden --null -g "!{.local,.cache}" "$HOME"| xargs -0 dirname 2> /dev/null | uniq'
        export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_DEFAULT_OPTS='--reverse --height 15'
    fi

    # Set GPG TTY
    export GPG_TTY=$(tty)

    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
      export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
      unset SSH_AGENT_PID
    fi

    # Refresh gpg-agent tty in case user switches into an X session
    # gpg-connect-agent updatestartuptty /bye >/dev/null
    # GPG as ssh-agent
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


# Aliases
[ -x "$(command -v bat)" ] && alias cat="bat"
alias n='nvr -s'
alias dw="cd $HOME/Downloads"
alias pj="cd $HOME/Projects"
alias cdC="cd $XDG_CONFIG_HOME/dotfiles"
alias la='ls --color=auto -al'
alias cal='zcalc -r3'
alias d='dirs -v'
alias p='pushd -q'
alias o='popd -q '
alias pu='own_push -'
alias pd='own_push +'
alias ou='own_pop -'
alias od='own_pop +'
alias eZC="$EDITOR $HOME/.zshrc"
alias eZE="$EDITOR $HOME/.zshenv"
alias -g C='| wc -l'
alias -g G='| grep -i'
alias -g RG='| rg '
alias -g X='| xargs '
alias -g SED='| sed -E'
alias -g AWK='| awk '
alias -s txt="$EDITOR"
alias -s html="$BROWSER"
alias -s {jpg,png}="imv"
alias -s pdf="zathura"
alias cls='clear'
alias lo='cd .. && l'
alias li='cd_in'
# move to script to be executed by sway
# alias passmenuown='PASSWORD_STORE_DIR="$HOME/.pass/icyd" passmenu --bottom --ignorecase --nb #282828 --nf #d5c4a1 --sb #d5c4a1 --sf #282828 --fn "Inconsolata 12"'
# alias passmenucbw='PASSWORD_STORE_DIR="$HOME/.pass/cbw" passmenu --bottom --ignorecase --nb #282828 --nf #d5c4a1 --sb #d5c4a1 --sf #282828 --fn "Inconsolata 12"'
alias gpgupd='gpg-connect-agent updatestartuptty /bye'

compdef _pass passown
zstyle ':completion::complete:passown::' prefix "$HOME/.pass/icyd"
passown() {
  PASSWORD_STORE_DIR="$HOME/.pass/icyd" pass $@
}

compdef _pass passcbw
zstyle ':completion::complete:passcbw::' prefix "$HOME/.pass/cbw"
passcbw() {
  PASSWORD_STORE_DIR="$HOME/.pass/cbw" pass $@
}

# Allow completation with kubectl as 'k' alias
[ -x "$(command -v kubectl)" ] && source <(k completion zsh | sed s/kubectl/k/g)

# Configure fzf to use ripgrep
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# Start tmux on new shell
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   tmux attach || exec tmux new-session
# fi

if [ "$TERM" = "st-256color" ]; then
    cd "$HOME"
fi

# Load NVM
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -x "$(command -v neofetch)" ] && neofetch
if [ "$(uname -s)" = "Darwin" ]; then
    source "$HOME/Library/Preferences/org.dystroy.broot/launcher/bash/br"
else
    source "$XDG_CONFIG_HOME/broot/launcher/bash/br"
fi
eval "$(starship init zsh)"
# Enable To debug loading times
# zprof

