skip_global_compinit=1
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export DOTFILES="$XDG_CONFIG_HOME/dotfiles"

# System's definitions
export PAGER="less"

# zsh config
export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
export ZSH_COMPLETIONS=$ZSH_CONFIG/completions
[ ! -d "$ZSH_CACHE_DIR" ] && mkdir "$ZSH_CACHE_DIR"

# gnupg config
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# Python's env
export PY_VENV=$HOME/.venv

# Neovim socket, for Neovim-remote
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

# Golang config
export GOPATH="$HOME/go"

# Rust config
export RUSTUP_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"

# Krew
export KREW_ROOT=$HOME/.krew

# asdf config
export ASDF_DIR="$HOME/.asdf"

# Path definition
idem_path_prepend() {
	export PATH=$1:${PATH//"$1:"/}
}

idem_path_prepend "$HOME/.local/bin/:$HOME/.node_modules/bin:$HOME/.yarn/bin:$XDG_CONFIG_HOME/zsh:$GOPATH/bin:$CARGO_HOME/bin:$HOME/.bin:$XDG_CONFIG_HOME/skim/bin:$KREW_ROOT/bin:$ASDF_DIR/bin:$ASDF_DIR/shims"

idem_fpath_prepend() {
	case ":${FPATH:=$1}:" in
        *:"$1":*)  ;;
        *) export FPATH="$1:$FPATH"  ;;
    esac
}

idem_fpath_prepend "$XDG_CONFIG_HOME/skim/shell/completion.zsh:$ZSH_COMPLETIONS"

# Pass config
export PASSWORD_STORE_GENERATED_LENGTH=12

# Prevent wine file associations
export WINEDLLOVERRIDES="winemenubuilder.exe=d"
export BROWSER="firefox"

if [[ $DESKTOP_SESSION =~ "sway" ]]; then
    # Force use wayland
    export ECORE_EVAS_ENGINE=wayland_egl
    export ELM_ENGINE=wayland_egl
    export _JAVA_AWT_WM_NONREPARENTING=1
    export SDL_VIDEODRIVER=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export MOZ_ENABLE_WAYLAND=1
    export BEMENU_BACKEND=wayland
    alias dmenu=bemenu
    alias dmenu_run=bemenu-run
    export SAL_USE_VCLPLUGIN=gtk3
fi

# Define locales for Darwin
if [ "$(uname -s)" = "Darwin" ]; then
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH"
fi
