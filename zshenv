export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Source not hardcoded sys env definition
[ -f "$XDG_CONFIG_HOME/zsh/local.zsh" ] && source "$XDG_CONFIG_HOME/zsh/local.zsh"

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
SKIP=1

export DOTFILES="$HOME/.config/dotfiles"


# Python's pyenv configuration for neovim and virtualenv
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_SHELL=zsh

# Path definition
export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin/:$HOME/.local/bin/:$HOME/.yarn/bin:$PATH"

# Nvr's config
export NVIM_LISTEN_ADDRESS="/tmp/nvimsocket"

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
