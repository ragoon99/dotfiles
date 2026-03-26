#!/bin/bash

render_item() {
	API="https://calendar.bloggernepal.com/api/today"
	RESULT=$(curl -s $API | jq -r .res)

	TODAY=$(echo $RESULT | jq -r '.days[] | select(.tag == "today") | .bs')
	MONTH=$(echo $RESULT | jq -r .name)
	YEAR=$(echo $RESULT | jq -r .year)

	sketchybar --set $NAME label="$YEAR $MONTH $TODAY" \
		--set date icon.drawing=$DRAWING \
		--set clock label.padding_left=$PADDING
}

update() {
	render_item
}

case "$SENDER" in
"routine" | "forced" | "focus_on" | "focus_off")
	update
	;;
esac
