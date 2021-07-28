#!/bin/zsh

GOPASS=$HOME/.asdf/shims/gopass
PASS=$($GOPASS list -f | rofi -i -dmenu)

[ ! -z "$PASS" ] && $GOPASS show -c "$PASS"
