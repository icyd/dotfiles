#!/bin/zsh

GOPASS="$(which gopass 2>/dev/null)"
PASS=$($GOPASS list -f | rofi -i -dmenu)

[ ! -z "$PASS" ] && $GOPASS show -c "$PASS"
