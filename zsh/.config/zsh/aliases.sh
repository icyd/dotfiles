# Aliases
command -v bat >/dev/null 2>&1 && alias cat="bat"
alias n='nvr -s'
alias s='nvr -so'
alias v='nvr -sO'
alias svim="sudo -E $EDITOR"
alias la='ls --color=auto -al'
alias d='dirs -v'
alias p='pushd -q'
alias o='popd -q '
alias pu='own_push -'
alias pd='own_push +'
alias ou='own_pop -'
alias od='own_pop +'
alias cdC="cd $HOME/.dotfiles"
alias eZC="$EDITOR $HOME/.zshrc"
alias eZE="$EDITOR $HOME/.zshenv"
alias eVC="$EDITOR $XDG_CONFIG_HOME/nvim/init.vim"
alias eVP="$EDITOR $XDG_CONFIG_HOME/nvim/config/plugins.vim"
alias -g WC='| wc -l'
alias -g G='| grep -i'
alias -g RG='| rg '
alias -g X='| xargs '
alias -g SED='| sed -E'
alias -g AWK='| awk '
alias -g B64D='| base64 -d'
alias -s txt="$EDITOR"
alias -s html="$BROWSER"
alias -s pdf="zathura"
alias cl='clear'
alias lo='cd .. && l'
alias li='cd_in'
alias gpgupd='gpg-connect-agent updatestartuptty /bye'
alias ssh="TERM=xterm ssh"
alias gpw='gopass'
