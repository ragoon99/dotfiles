# Load global styles, colors and icons
source "$CONFIG_DIR/globalstyles.sh"

log_debug() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') [DEBUG] $1"
}

update_widget() {
	PLAYER_STATE=$(osascript -e 'tell application "System Events" to if (name of processes) contains "Spotify" then tell application "Spotify" to get player state')

	if [[ $PLAYER_STATE == "playing" ]]; then
		INFOS=$(osascript -e 'tell application "Spotify" to if player state is playing then return "{\"name\":\"" & (name of current track) & "\",\"artist\":\"" & (artist of current track) & "\",\"album\":\"" & (album of current track) & "\"}"')

		# log_debug $INFOS

		CURRENT_ARTIST="$(echo "$INFOS" | jq -r '.artist')"
		CURRENT_SONG="$(echo "$INFOS" | jq -r '.name // empty')"

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

	# log_debug "CURRENT_ARTIST: $CURRENT_ARTIST"
	# log_debug "PLAYER: $PLAYER"
	# log_debug "PLAYER_STATE: $PLAYER_STATE"

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
