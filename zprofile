#if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  #exec startx
#fi
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    export XKB_DEFAULT_LAYOUT=es
    export XKB_DEFAULT_VARIANT=icyd
    export XKB_DEFAULT_OPTIONS=lv3:ralt_switch,compose:102
    sway
    #export XKB_DEFAULT_MODEL=pc105
fi
