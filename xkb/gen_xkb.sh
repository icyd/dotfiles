#!/bin/bash

DIR=$(dirname $0)
mkdir -p $DIR/keymaps
setxkbmap -layout icyd -variant icyd -option "shift:breaks_caps,lv3:ralt_switch,compose:102,caps:swapescape" -print > $DIR/keymaps/icyd
xkbcomp -R$XDG_CONFIG_HOME/xkb -I/usr/share/X11/xkb $DIR/keymaps/icyd -xkb
