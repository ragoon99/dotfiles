#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"
TMP="/tmp/drawing_state.txt"

render_item() {
	PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
	CHARGING=$(pmset -g batt | grep 'AC Power')
	COLOR=$ICON_COLOR
	local DRAWING=$(get_label_state)

	if [ $PERCENTAGE = "" ]; then
		exit 0
	fi

	case ${PERCENTAGE} in
	9[0-9] | 100)
		ICON=$ICON_BATTERY_100
		;;
	[6-8][0-9])
		ICON=$ICON_BATTERY_75
		;;
	[3-5][0-9])
		ICON=$ICON_BATTERY_50
		;;
	[1-2][0-9])
		ICON=$ICON_BATTERY_25
		COLOR=$(getcolor yellow)
		DRAWING="on"
		;;
	*)
		ICON=$ICON_BATTERY_0
		COLOR=$(getcolor red)
		DRAWING="on"
		;;
	esac

	if [[ $CHARGING != "" ]]; then
		COLOR=$(getcolor green)
		sketchybar --set charging_icon drawing=on
	else
		sketchybar --set charging_icon drawing=off
	fi

	sketchybar --set $NAME icon=$ICON icon.color=$COLOR label=$PERCENTAGE% label.color=$LABEL_COLOR label.drawing=$DRAWING
}

save_label_state() {
	echo "$(sketchybar --query $NAME | jq -r '.label.drawing')" >"$TMP"
}

get_label_state() {
	if [ -e "$TMP" ]; then
		cat "$TMP"
	else
		echo "off" >"$TMP"
	fi
}

label_toggle() {
	if [[ $(get_label_state) == "on" ]]; then
		DRAWING="off"
	else
		DRAWING="on"
	fi

	sketchybar --set $NAME label.drawing=$DRAWING
	save_label_state
}

case "$SENDER" in
"mouse.clicked")
	label_toggle
	;;
"routine" | "forced" | "power_source_change")
	render_item
	;;
esac
