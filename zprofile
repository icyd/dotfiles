# If running from tty1 start sway
if [ "$(uname)" = "Linux" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec sway
fi

if [ -z "$(pgrep gpg-agent)" ]; then
    gpgconf --launch gpg-agent
fi

if [ -z "$(pgrep dirmngr)" ]; then
    dirmngr --homedir $GNUPGHOME --daemon >/dev/null 2>&1
fi
export DISPLAY=:0
