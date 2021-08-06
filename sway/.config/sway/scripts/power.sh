#!/bin/sh

power() {
  case $1 in
    Exit)
      swaymsg exit;;
    Lock)
      swaylock -c 282828;;
    Suspend)
      exec systemctl suspend;;
    Reboot)
      exec systemctl reboot;;
    Shutdown)
      exec systemctl poweroff -i;;
  esac
}

if [ $# -eq 0 ]; then
    while read -r line; do
        power "${line}"
    done
else
    power "$@"
fi
