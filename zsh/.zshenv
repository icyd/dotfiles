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
export NVR_GRAB_FILE=/tmp/nvim-server

# Golang
export GOPATH="$HOME/go"

# Krew
export KREW_ROOT=$HOME/.krew

# Asdf
export ASDF_DIR="$HOME/.asdf"

# Path definition
idem_path_prepend() {
    export PATH=$1:${PATH//"$1:"/}
}

idem_path_prepend "$HOME/.local/bin/:$GOPATH/bin:$CARGO_HOME/bin:$XDG_CONFIG_HOME/fzf/bin:$KREW_ROOT/bin:$ASDF_DIR/bin:$ASDF_DIR/shims"

idem_fpath_prepend() {
    case ":${FPATH:=$1}:" in
        *:"$1":*)  ;;
        *) export FPATH="$1:$FPATH"  ;;
    esac
}

idem_fpath_prepend "$HOME/.fzf/shell/completion.zsh:$ZSH_COMPLETIONS:$ASDF_DIR/completions"

# Pass
export PASSWORD_STORE_GENERATED_LENGTH=12

# Prevent wine file associations
export WINEDLLOVERRIDES="winemenubuilder.exe=d"
export BROWSER="firefox"
