#!/bin/bash

# Load global styles, colors and icons
source "$CONFIG_DIR/globalstyles.sh"

# Defaults
spotify=(
	background.corner_radius=4
)

# sketchybar \
# 	--add event spotify_track_changed "com.spotify.client.PlaybackStateChanged" \
# 	--add item spotify right \
# 	--set spotify \
# 	script="$PLUGIN_DIR/spotify.sh" \
# 	--subscribe spotify spotify_track_changed
