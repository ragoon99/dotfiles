source "$CONFIG_DIR/globalstyles.sh"

FOCUSED_APP=$(yabai -m query --windows app --window | jq -r '.app')

case "$SENDER" in
"front_app_switched")
	sketchybar --set current_active_window label=$FOCUSED_APP
	;;
esac
