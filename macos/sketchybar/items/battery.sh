#!/bin/bash

battery=(
	icon.font.size=14
	icon.padding_right=0
	icon.font.style="Light"
	update_freq=60
	popup.align=right
	script="$PLUGIN_DIR/battery.sh"
	updates=when_shown
)

charging_icon=(
	icon=$ICON_LIGHTNING
	icon.font.size=14
	icon.padding_left=4
	icon.font.style="Light"
	drawing=off
)

sketchybar \
	--add item battery right \
	--set battery "${battery[@]}" \
	--subscribe battery power_source_change \
	mouse.clicked \
	--add item charging_icon right \
	--set charging_icon "${charging_icon[@]}"
