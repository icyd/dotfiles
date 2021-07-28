#!/bin/bash

DIR=$(dirname $0)
mkdir -p $DIR/keymaps
setxkbmap -layout icyd -variant icyd -option "shift:breaks_caps,lv3:ralt_switch,compose:102,caps:swapescape" -print > $DIR/keymaps/icyd
xkbcomp -R$DOTFILES/xkb -I/usr/share/X11/xkb keymaps/icyd -xkm
