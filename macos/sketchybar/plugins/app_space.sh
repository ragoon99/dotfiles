#!/bin/bash

# Load global styles, colors and icons
source "$CONFIG_DIR/globalstyles.sh"

SID=$1
SPACE_NAME=$2
DEBUG=1

create_icons() {
	sketchybar --set $SPACE_NAME label=$SID
}

update_icons() {
	CURRENT_SID=$(aerospace list-workspaces --focused)

	if [[ "$CURRENT_SID" == "$SID" ]]; then
		create_icons "$CURRENT_SID"
		BACKGROUND_COLOR=$(getcolor green)
		COLOR=$BAR_COLOR
		STYLE="Bold"
	else
		BACKGROUND_COLOR="$(getcolor white 10)"
		COLOR=$LABEL_COLOR
		STYLE="Regular"
	fi

	sketchybar --animate tanh 10 \
		--set $SPACE_NAME icon.color=$COLOR \
		label.color=$COLOR \
		background.color=$BACKGROUND_COLOR \
		background.height=18 \
		label.font.style=$STYLE \
		label.align="center" \
		label.padding_right=10 \
		label.padding_left=8
}

mouse_clicked() {
	aerospace workspace $SID
}

debug() {
	if ((DEBUG == 1)); then
		echo ---$(date +"%T")---
		echo sender: $SENDER
		echo sid: $SID
		echo ---
		echo $@
		echo ---
	fi
}

case "$SENDER" in
"routine" | "forced" | "space_windows_change")
	create_icons "$SID"
	update_icons
	;;
"front_app_switched" | "space_change")
	update_icons
	;;
"mouse.clicked")
	mouse_clicked
	;;
esac
