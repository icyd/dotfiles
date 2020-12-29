export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export DOTFILES="$XDG_CONFIG_HOME/dotfiles"
export TERM="xterm-256color"

# System's definitions
export PAGER="less"

# zsh config
export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
[ ! -d "$ZSH_CACHE_DIR" ] && mkdir "$ZSH_CACHE_DIR"

# gnupg config
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# Python's pyenv configuration for neovim and virtualenv
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_SHELL=zsh
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Golang config
export GOPATH="$HOME/go"

# Rust config
export RUSTUP_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"

# Krew
export KREW_ROOT=$HOME/.krew

# Nvm configuration
export NVM_DIR="$HOME/.nvm"

# asdf config
export ASDF_DIR="$HOME/.asdf"

# Path definition
export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin/:$HOME/.local/bin/:$HOME/.node_modules/bin:$HOME/.yarn/bin:$XDG_CONFIG_HOME/zsh:$GOPATH/bin:$CARGO_HOME/bin:$HOME/.bin:$XDG_CONFIG_HOME/skim/bin:$KREW_ROOT/bin:$ASDF_DIR/bin:$ASDF_DIR/shims:$PATH"

# Pass config
export PASSWORD_STORE_GENERATED_LENGTH=12

# Put all configuration to be skipped inside if-else declaration
if [ -z "$SERVER_MODE" ]; then
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
        export HOMEBREW_GITHUB_API_TOKEN=06ce472e6c54a26af0f53170e8a6adfc479b2f9f
    fi

else
    export BROWSER="lynx"
    export TERM="xterm"
fi
