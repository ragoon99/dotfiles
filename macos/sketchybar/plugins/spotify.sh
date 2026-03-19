source "$CONFIG_DIR/globalstyles.sh"

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

	sketchybar --set "$NAME" "${args[@]}" click_script="aerospace workspace 5"
}

case "$SENDER" in
"spotify_track_changed")
	update_widget
	;;
esac
