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
alias cdr='cd-gitroot'
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
alias tx=tmuxp_fzf

tls_cert_key_verify() {
	CERT_MD5=$(openssl x509 -noout -modulus -in "$1" | openssl md5)
	KEY_MD5=$(openssl rsa -noout -modulus -in "$2" | openssl md5)
	[ "$CERT_MD5" = "$KEY_MD5" ] && echo "OK" || echo "ERROR"
}

tls_cert_text() {
	openssl x509 -noout -text -in "$@"
}

tls_key_text() {
	openssl rsa -noout -text -in "$@"
}

tmuxp_fzf() {
	tmuxp load $(tmuxp ls | fzf --reverse --border --no-preview --height=10%)
}
