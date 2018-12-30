# Enviroment variables for rofi
source "$HOME/.config/zsh/rofi.zsh"

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
# sway config
   sway
fi
