#!/bin/zsh

GOPASS="$(which gopass 2>/dev/null)"
PASS=$($GOPASS list -f | wofi -i -dmenu 2>/dev/null)

[ ! -z "$PASS" ] && $GOPASS show -c "$PASS"
