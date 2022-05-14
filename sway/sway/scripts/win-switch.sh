#!/bin/bash

window=$(swaymsg -t get_tree | \
 jq -r '.nodes[].nodes[] | if .nodes then [recurse(.nodes[])] else [] end + .floating_nodes | .[] | select(.nodes==[]) | ((.id | tostring) + " " + .name)' | \
 wofi --show dmenu 2>/dev/null)

[ ! -z "$window" ] && read -r id name <<<$window; swaymsg "[con_id=$id]" focus
