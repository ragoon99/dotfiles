# Load global styles, colors and icons
source "$CONFIG_DIR/globalstyles.sh"

log_debug() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') [DEBUG] $1"
}

update_widget() {
	IS_PLAYING=$(media-control get | jq -r '.playing')

	if [[ $IS_PLAYING == "true" ]]; then
		INFOS=$(media-control get)

		CURRENT_ARTIST="$(echo "$INFOS" | jq -r '.artist')"
		CURRENT_SONG="$(echo "$INFOS" | jq -r '.title')"

		args=(
			drawing=on
			icon=$ICON_MUSIC
			label="${CURRENT_ARTIST}: ${CURRENT_SONG}"
			label.color="$(getcolor black)"
			background.color="$(getcolor green)"
		)
	else
		PLAYER_STATE="stopped"
		CURRENT_ARTIST="Nothing is playing"
		CURRENT_SONG=""
		args=(drawing=off)
	fi

	sketchybar --set "$NAME" "${args[@]}"
}

# Main event handler
case "$SENDER" in
"routine" | "forced")
	update_widget
	;;
*)
	log_debug "Unknown sender: $SENDER"
	exit 1
	;;
esac
