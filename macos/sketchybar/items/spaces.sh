#!/bin/bash

# Load global styles, colors and icons
source "$CONFIG_DIR/globalstyles.sh"

# Defaults
spaces=(
	background.corner_radius=4
)

SPACES=($(aerospace list-workspaces --all --json | jq -r '.[].workspace'))

for SID in "${SPACES[@]}"; do
	SPACE_NAME="space_$SID"

	sketchybar --add item $SPACE_NAME center \
		--set $SPACE_NAME \
		script="$PLUGIN_DIR/app_space.sh $SID $SPACE_NAME" \
		--subscribe $SPACE_NAME mouse.clicked front_app_switched space_change space_windows_change
done
