#!/bin/bash

music=(
	${bracket_defaults[@]}
	background.image.corner_radius=4
	background.image.padding_left=2
	background.image.scale=0.01
	icon.padding_left=8
	icon.color="$(getcolor black)"
	label.max_chars=24
	label.padding_left=8
	label.padding_right=$PADDINGS
	label.scroll_duration=100
	padding_right=$PADDINGS
	script="$PLUGIN_DIR/music.sh"
	click_script="$PLUGIN_DIR/music.sh"
	updates=on
	update_freq=30
	--subscribe music mouse.clicked spotify_track_changed
)

sketchybar \
	--add event spotify_track_changed "com.spotify.client.PlaybackStateChanged" \
	--add item music $1 \
	--set music "${music[@]}"
