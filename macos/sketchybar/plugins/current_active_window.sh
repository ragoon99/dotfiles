source "$CONFIG_DIR/globalstyles.sh"

QUERY=$(aerospace list-windows --focused --json)
WINDOW_TITLE=$(echo $QUERY | jq -r '.[]."window-title"')
FOCUSED_APP=$(echo $QUERY | jq -r '.[]."app-name"')

case "$SENDER" in
"front_app_switched")
	if [[ $FOCUSED_APP ]]; then
		sketchybar --set current_active_window \
			background.color=$(getcolor green) \
			label="$WINDOW_TITLE | $FOCUSED_APP" \
			label.color=$(getcolor black) \
			label.font.style="Regular" \
			label.padding_left=8 \
			label.padding_right=8
	fi
	;;
esac
