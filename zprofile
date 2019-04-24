# If running from tty1 start sway
if [ "$(uname)" = "Linux" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec sway
fi
