# Zsh plugins to mimic fish functionality
# Source system-wide (grml) zshrc
if [  -f /etc/zsh/zshrc ]; then
    source /etc/zsh/zshrc
fi

# Zsh's plugins
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


# Enable Vi mode
bindkey -v

# Vi additional bindings
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey '^L' autosuggest-accept
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^@' history-incremental-search-backward

# AUTOSUGGEST color, different to bg
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4,bold'

# GPG as ssh-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# Set GPG TTY
export GPG_TTY=$(tty)

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null

# Lower vi key lag
export KEYTIMEOUT=1

# Prompt configuration
autoload $U promptinit; promptinit
prompt pure
# prompt_newline='%666v'
VIM_PROMPT="❯"
# PROMPT=' %(?.%F{magenta}.%F{red}!%F{magenta})${VIM_PROMPT}%f '


# prompt_pure_update_vim_prompt() {
#     zle || {
#         print "error: pure_update_vim_prompt must be called when zle is active"
#         return 1
#     }
#     VIM_PROMPT=${${KEYMAP/vicmd/❮}/(main|viins)/❯}
#     zle .reset-prompt
# }

# function zle-line-init zle-keymap-select {
#     prompt_pure_update_vim_prompt
# }
# zle -N zle-line-init
# zle -N zle-keymap-select

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

# Support for nvm
# source /usr/share/nvm/init-nvm.sh

# Avoid nested nvim instances
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    if [ -x "$(command -v nvr)" ]; then
	if [ ! -e "$HOME/.local/bin/nvr" ]; then
		alias nvim='nvim'
	else
		alias nvim="nvr -s --remote"
	fi
    else
        alias nvim='echo "No nesting!"'
    fi
fi

# Configure fzf to use ripgrep
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --glob "!{.git,node_modules}/*"' 2> /dev/null
export FZF_DEFAULT_OPTS='--reverse'

# Aliases
# alias e="nvr --remote"
alias dw="cd ~/Downloads"
