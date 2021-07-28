# If running from tty1 start sway
if [ "$(uname)" = "Linux" ] && [[ $DESKTOP_SESSION =~ "sway" ]]; then
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

if [ -z "$(pgrep gpg-agent)" ]; then
    gpgconf --launch gpg-agent
fi

if [ -z "$(pgrep dirmngr)" ]; then
    dirmngr --homedir $GNUPGHOME --daemon >/dev/null 2>&1
fi
