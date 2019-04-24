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
ZSH_PLUGIN_IN="$XDG_CONFIG_HOME/zsh/zsh_plugins.txt"
ZSH_PLUGIN_OUT="$XDG_CONFIG_HOME/zsh/zsh_plugins.sh"
ANTIBODY="$XDG_CONFIG_HOME/zsh/antibody"

autoload -Uz compinit
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Static call of zsh's plugins
gen_plugins_file(){
    "$ANTIBODY" bundle < "$ZSH_PLUGIN_IN" > "$ZSH_PLUGIN_OUT"
}

# Source plugins
[ ! -f "$ZSH_PLUGIN_OUT" ] && gen_plugins_file; source "$ZSH_PLUGIN_OUT"

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

# Configure fzf to use ripgrep
[ -f "$XDG_CONFIG_HOME/fzf/fzf.zsh" ] && source "$XDG_CONFIG_HOME/fzf/fzf.zsh"


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


# # Pyenv completion source
[ -e '$PYENV_ROOT/completions/pyenv.zsh' ] && source '$PYENV_ROOT/completions/pyenv.zsh'
# # Rehash should be run manually to update shims
# # command pyenv rehash 2>/dev/null
pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$("$PYENV_ROOT/bin/pyenv" "sh-$command" "$@")";;
  *)
    command "$PYENV_ROOT/bin/pyenv" "$command" "$@";;
  esac
}
eval "$($PYENV_ROOT/bin/pyenv virtualenv-init -)"

if [ -z "$SERVER_MODE" ]; then
    # Configure fzf to use ripgrep
    export FZF_CTRL_T_OPTS="--select-1 --exit-0"
    export FZF_ALT_C_COMMAND='rg --files --hidden --null | xargs -0 dirname 2> /dev/null | uniq'
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS='--reverse --height 15'

    # export AUTOENV_FILE_ENTER=".autoenv.zsh"
    # export AUTOENV_FILE_LEAVE=".autoenv.zsh"
    # export AUTOENV_HANDLE_LEAVE=1

    # Set GPG TTY
    export GPG_TTY=$(tty)

    # GPG as ssh-agent
    unset SSH_AGENT_PID
    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
      export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    fi

    # Refresh gpg-agent tty in case user switches into an X session
    gpg-connect-agent updatestartuptty /bye >/dev/null
fi

# Functions
mkcd() {
    mkdir -p "$1" && cd "$1" || return 1
}

# Aliases
alias dw="cd $HOME/Downloads"
alias pj="cd $HOME/Projects"
alias cdC="cd $XDG_CONFIG_HOME/dotfiles"
alias la='ls --color=auto -al'
alias d='dirs -v'
alias p='pushd >/dev/null'
alias o='popd >/dev/null'
alias vim="${EDITOR}"
alias svim='sudo -E nvim'
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
alias sysstat='sudo systemctl status'
alias sysrest='sudo systemctl restart'
alias sysini='sudo systemctl start'
alias sysstop='sudo systemctl stop'
alias sysena='sudo systemctl enable'
alias sysdis='sudo systemctl disable'
alias yayin='yay -S'
alias yayloc='yay -U'
alias yaysea='yay -Ss'
alias yayupd='yay -Syy'
alias yayupg='yay -Syu'
alias yayinf='yay -Si'
alias yaydb='yay -Qi'
alias yayrm='yay -Rnsc'

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
# Enable To debug loading times
# zprof
