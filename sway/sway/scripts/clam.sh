#!/bin/sh

LAPTOP="$(grep "set \$laptop" config | awk '{print $3}')"
LID=$(find /proc/acpi/button/lid -type f -name 'state')

if [ -z $(grep -q "open" "$LID") ]; then
	swaymsg output $LAPTOP enable
else
	swaymsg output $LAPTOP disable
fi
