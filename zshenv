#
# Defines environment variables.
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# System's definitions
export EDITOR="nvr -s"
export SYSTEMD_EDITOR="nvr -s"
export TERMINAL="urxvtc"
export BROWSER="qutebrowser"

# Python's pyenv configuration for neovim and virtualenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

export PATH="$HOME/.local/bin:$PATH"

# Prevent wine file associations
export WINEDLLOVERRIDES="winemenubuilder.exe=d"

# Use pre-defined Neovim socket, to connect to via nvr
export NVIM_LISTEN_ADDRESS="/tmp/nvimsocket"

#Use kwallet to ask sshpassword
export SSH_ASKPASS=/usr/bin/lxqt-openssh-askpass
export SUDO_ASKPASS=/usr/bin/lxqt-openssh-askpass

# GTAGS
export GTAGSLABEL=pygments
export GTAGSCONF=/usr/share/gtags/gtags.conf

# npm config
# PATH="$HOME/.node_modules/bin:$PATH"
# export npm_config_prefix=~/.node_modules

# sway config
GDK_BACKEND=wayland
CLUTTER_BACKEND=wayland
QT_QPA_PLATFORM=wayland-egl
SDL_VIDEODRIVER=wayland
# QT_QPA_PLATFORM=qt5ct
QT_WAYLAND_DISABLE_WINDOWDECORATION=1
