export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_MUSIC_DIR="${HOME}/Music"

# Source not hardcoded sys env definition
[ -f "$XDG_CONFIG_HOME/zsh/local.zsh" ] && source "$XDG_CONFIG_HOME/zsh/local.zsh"

# Define locales for Darwin
if [ "$(uname -s)" = "Darwin" ]; then
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH"
    export HOMEBREW_GITHUB_API_TOKEN=06ce472e6c54a26af0f53170e8a6adfc479b2f9f
fi

# Defines environment variables.
[ -x "$(command -v nvim)" ] && export EDITOR='nvim' || export EDITOR='vim'

# System's definitions
export PAGER="less"
SKIP=1

export DOTFILES="$XDG_CONFIG_HOME/dotfiles"

# zsh config
export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
[ ! -d "$ZSH_CACHE_DIR" ] && mkdir "$ZSH_CACHE_DIR"

# starship config
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# gnupg config
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# Python's pyenv configuration for neovim and virtualenv
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_SHELL=zsh
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Golang config
export GOPATH="${HOME}/go"

# Node global in user directory
# export npm_config_prefix=~/.node_modules
export NVM_DIR="$HOME/.nvm"

# Path definition
export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin/:$HOME/.local/bin/:$HOME/.node_modules/bin:$HOME/.yarn/bin:$XDG_CONFIG_HOME/zsh:$GOPATH/bin:$PATH"

# Nvr's config
export NVIM_LISTEN_ADDRESS="/tmp/nvimsocket"

# Nvm configuration
[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
[ -f "$NVM_SOURCE/nvm.sh" ] && source "$NVM_SOURCE/nvm.sh"
[ -f "$NVM_SOURCE/bash_completion" ] && source "$NVM_SOURCE/bash_completion"
[ -f "$NVM_SOURCE/bash_completion" ] && source "$NVM_SOURCE/install-nvm-exec"

# Pass config
export PASSWORD_STORE_GENERATED_LENGTH=12

# Put all configuration to be skipped inside if-else declaration
if [ -z "$SERVER_MODE" ]; then
    [ -f "$XDG_CONFIG_HOME/zsh/rofi.zsh" ] && source "$XDG_CONFIG_HOME/zsh/rofi.zsh"
    export PATH="$DOTFILES/scripts:$PATH"
    export BROWSER="qutebrowser"

    # Prevent wine file associations
    export WINEDLLOVERRIDES="winemenubuilder.exe=d"

    if [[ $DESKTOP_SESSION =~ "sway" ]]; then
        # Force use wayland
        # export CLUTTER_BACKEND=wayland
        # export QT_QPA_PLATFORM=wayland-egl
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
else
    export TERM="xterm"
    export BROWSER="lynx"
fi
