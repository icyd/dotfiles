# Defines environment variables.
command -v nvr >/dev/null 2>&1
if [ "$?" -eq 0 ]; then
    NVIM='nvr -s --remote'
else

    NVIM='nvim'
fi

# System's definitions
export EDITOR="$NVIM"
export TERMINAL="urxvtc"
export PAGER="less"

export DOTFILES="$HOME/.config/dotfiles"

# Python's pyenv configuration for neovim and virtualenv
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_SHELL=zsh

# Path defitinion: shims allow for pyenv to work
export PATH="$PYENV_ROOT/shims:HOME/.yarn/bin:$PATH"

# Nvr's config
export NVIM_LISTEN_ADDRESS="/tmp/nvimsocket"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

if [ -z "$SERVER" ]; then
    export PATH="$USER_BIN:$DOTFILES/scripts:$HOME/.luarocks/bin:$PATH"
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
    export SERVER=1
    export TERM="xterm"
    export BROWSER="lynx"
fi
