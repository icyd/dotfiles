skip_global_compinit=1
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export DOTFILES="$HOME/.dotfiles"

# System's definitions
export PAGER="less"

# Zsh
export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
export ZSH_COMPLETIONS=$ZSH_CONFIG/completions
[ ! -d "$ZSH_CACHE_DIR" ] && mkdir "$ZSH_CACHE_DIR"

# Gnupg
export GNUPGHOME="$HOME/.gnupg"

# Python's env
export PY_VENV=$HOME/.venv

# Neovim socket, for Neovim-remote
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

# Golang
export GOPATH="$HOME/go"

# Asdf
if [ -f /opt/asdf-vm/asdf.sh ]; then
    export ASDF_DIR=/opt/asdf-vm
else
    export ASDF_DIR="$HOME/.asdf"
fi

export ASDF_CONFIG_FILE=$XDG_CONFIG_HOME/asdf/asdfrc
export ASDF_DATA_DIR=$XDG_DATA_HOME/asdf

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

if [ $(uname -s) = "Darwin" ]; then
    unset ASDF_DIR
    idem_path_prepend "$HOME/.local/bin/:$GOPATH/bin:$CARGO_HOME/bin:$XDG_CONFIG_HOME/fzf/bin:$KREW_ROOT/bin:$ASDF_DIR/bin:$ASDF_DATA_DIR/shims:/opt/homebrew/bin:/usr/local/bin"
    BREW_DIR="$(brew --prefix)"
    idem_path_prepend "$BREW_DIR/sbin:$BREW_DIR/opt/coreutils/libexec/gnubin"
    idem_fpath_prepend "$HOME/.fzf/shell/completion.zsh:$ZSH_COMPLETIONS:$ASDF_DIR/completions:$BREW_DIR/share/zsh-completions"
    [ -f "$BREW_DIR/opt/asdf/libexec/asdf.sh" ] && source "$BREW_DIR/opt/asdf/libexec/asdf.sh"
else
    idem_path_prepend "/usr/local/bin:$HOME/.local/bin/:$GOPATH/bin:$CARGO_HOME/bin:$XDG_CONFIG_HOME/fzf/bin:$KREW_ROOT/bin:$ASDF_DIR/bin:$ASDF_DATA_DIR/shims"
    idem_fpath_prepend "$HOME/.fzf/shell/completion.zsh:$ZSH_COMPLETIONS:$ASDF_DIR/completions"
fi

# Pass
export PASSWORD_STORE_GENERATED_LENGTH=12

# Prevent wine file associations
export WINEDLLOVERRIDES="winemenubuilder.exe=d"
export BROWSER="firefox"
