current_active_window=(
	script="$PLUGIN_DIR/current_active_window.sh"
)

sketchybar --add item current_active_window center\
	--set current_active_window "${current_active_window[@]}"\
	--subscribe current_active_window display_change front_app_switched
