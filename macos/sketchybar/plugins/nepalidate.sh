#!/bin/bash

render_item() {
	DATE=~/dotfiles/scripts/nepalidate.sh
	TODAY=$($DATE | jq -r '.day')
	MONTH=$($DATE | jq -r '.month')
	YEAR=$($DATE | jq -r '.year')

	sketchybar --set $NAME label="$YEAR $MONTH $TODAY" \
		--set date icon.drawing=$DRAWING \
		--set clock label.padding_left=$PADDING
}

update() {
	render_item
}

case "$SENDER" in
"routine" | "forced" | "focus_on" | "focus_off")
	update
	;;
esac
