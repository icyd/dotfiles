skip_global_compinit=1

[ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ] && source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
set -a
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
DOTFILES="$HOME/.dotfiles"
DIRENV_LOG_FORMAT=""

# System's definitions
PAGER="less"

# Zsh
ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
ZSH_CACHE_DIR="$HOME/.cache/zsh"
ZSH_COMPLETIONS=$ZSH_CONFIG/completions
[ ! -d "$ZSH_CACHE_DIR" ] && mkdir "$ZSH_CACHE_DIR"

# Gnupg
GNUPGHOME="$HOME/.gnupg"

# Python's env
PY_VENV=$HOME/.venv

# Neovim socket, for Neovim-remote
NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

# Golang
GOPATH="$HOME/go"

ASDF_CONFIG_FILE=$XDG_CONFIG_HOME/asdf/asdfrc
ASDF_DATA_DIR=$XDG_DATA_HOME/asdf

# Pass
PASSWORD_STORE_GENERATED_LENGTH=12

# Prevent wine file associations
WINEDLLOVERRIDES="winemenubuilder.exe=d"
BROWSER="firefox"

DOTFILES_UNAME=$(uname -s)
set +a

# Path definition
idem_path_prepend() {
    export PATH=$1:${PATH//"$1:"/}
}

idem_fpath_prepend() {
    case ":${FPATH:=$1}:" in
        *:"$1":*)  ;;
        *) export FPATH="$1:$FPATH"  ;;
    esac
}

if [ $DOTFILES_UNAME = "Darwin" ]; then
    idem_path_prepend "$HOME/.local/bin/:$GOPATH/bin:$CARGO_HOME/bin:$XDG_CONFIG_HOME/fzf/bin:$KREW_ROOT/bin:$ASDF_DIR/bin:$ASDF_DATA_DIR/shims:/opt/homebrew/bin:/usr/local/bin"
    BREW_DIR="$(brew --prefix)"
    [ ! -d $XDG_DATA_HOME/zsh ] && mkdir -p $XDG_DATA_HOME/zsh
    GNUTOOLS_PATH=$XDG_DATA_HOME/zsh/gnutools_path
    [ ! -f $GNUTOOLS_PATH ] && find -L "$(brew --prefix)/opt" -type d -name gnubin -print0 | tr '\0' ':' | sed 's/:$//' > $GNUTOOLS_PATH
    idem_path_prepend "$BREW_DIR/sbin:$(cat $GNUTOOLS_PATH)"
    idem_fpath_prepend "$HOME/.fzf/shell/completion.zsh:$ZSH_COMPLETIONS:$ASDF_DIR/completions:$BREW_DIR/share/zsh-completions"
    [ -f "$BREW_DIR/opt/asdf/libexec/asdf.sh" ] && source "$BREW_DIR/opt/asdf/libexec/asdf.sh"
else
    ASDF_DIR="$HOME/.asdf"
    idem_path_prepend "/usr/local/bin:$HOME/.local/bin/:$GOPATH/bin:$CARGO_HOME/bin:$XDG_CONFIG_HOME/fzf/bin:$KREW_ROOT/bin:$ASDF_DIR/bin:$ASDF_DATA_DIR/shims"
    idem_fpath_prepend "$HOME/.fzf/shell/completion.zsh:$ZSH_COMPLETIONS:$ASDF_DIR/completions"
fi
