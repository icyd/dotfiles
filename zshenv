# Defines environment variables.
if [ -x "$HOME/.local/bin/nvr" ]; then
    NVIM='~/.local/bin/nvr -s --remote'
else

    NVIM='nvim'
fi

# System's definitions
export EDITOR="$NVIM"
export TERMINAL="urxvtc"
export BROWSER="qutebrowser"
export PAGER="less"

export DOTFILES="$HOME/.config/dotfiles"

# User executables
export USER_BIN="$HOME/.local/bin"

# Python's pyenv configuration for neovim and virtualenv
export PYENV_ROOT="$HOME/.pyenv"

# Prevent wine file associations
export WINEDLLOVERRIDES="winemenubuilder.exe=d"

#Use kwallet to ask sshpassword
export SSH_ASKPASS=/usr/bin/lxqt-openssh-askpass
export SUDO_ASKPASS=/usr/bin/lxqt-openssh-askpass

# Path defitinion
export PATH="$PYENV_ROOT/bin:$USER_BIN:$HOME/.luarocks/bin:$PATH"

# Force use wayland
export GDK_BACKEND=wayland
export CLUTTER_BACKEND=wayland
export QT_QPA_PLATFORM=wayland-egl
export SDL_VIDEODRIVER=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
