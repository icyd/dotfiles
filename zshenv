export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Source not hardcoded sys env definition
[ -f "$XDG_CONFIG_HOME/zsh/local.zsh" ] && source "$XDG_CONFIG_HOME/zsh/local.zsh"

# Define locales for Darwin
if [ "$(uname -s)" = "Darwin" ]; then
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
   export PATH="/usr/local/opt/coreutils/libexec/gnubin/:/usr/local/bin:/usr/local/sbin/:$PATH"
   export HOMEBREW_GITHUB_API_TOKEN=06ce472e6c54a26af0f53170e8a6adfc479b2f9f
fi

# Defines environment variables.
command -v nvr >/dev/null 2>&1
if [ "$?" -eq 0 ]; then
    NVIM='nvr -s'
else

    NVIM='nvim'
fi

# System's definitions
export EDITOR="$NVIM"
export TERMINAL="urxvtc"
export PAGER="less"
export TERM="xterm-256color"
export TERMINFO="/usr/share/terminfo"
SKIP=1

export DOTFILES="$XDG_CONFIG_HOME/dotfiles"

# zsh config
export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$HOME/.cache/zsh"

# gnupg config
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# Python's pyenv configuration for neovim and virtualenv
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_SHELL=zsh

# Path definition
export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin/:$HOME/.local/bin/:$HOME/.yarn/bin:$XDG_CONFIG_HOME/zsh:$PATH"

# Nvr's config
export NVIM_LISTEN_ADDRESS="/tmp/nvimsocket"

# Pass config
export PASSWORD_STORE_GENERATED_LENGTH=12

# Put all configuration to be skipped inside if-else declaration
if [ -z "$SKIP_THIS" ]; then
    if [ -z "$SERVER_MODE" ]; then
        [ -f "$XDG_CONFIG_HOME/zsh/rofi.zsh" ] && source "$XDG_CONFIG_HOME/zsh/rofi.zsh"
        export PATH="$DOTFILES/scripts:$HOME/.luarocks/bin:$PATH"
        export BROWSER="qutebrowser"

        # Prevent wine file associations
        export WINEDLLOVERRIDES="winemenubuilder.exe=d"

        #Use kwallet to ask sshpassword
        export SSH_ASKPASS=/usr/bin/lxqt-openssh-askpass
        export SUDO_ASKPASS=/usr/bin/lxqt-openssh-askpass

        # Force use wayland
        export GDK_BACKEND=wayland
        export CLUTTER_BACKEND=wayland
        export QT_QPA_PLATFORM=wayland-egl
        export SDL_VIDEODRIVER=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    else
        export TERM="xterm"
        export BROWSER="lynx"
    fi
fi
