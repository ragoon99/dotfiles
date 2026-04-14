API="https://calendar.bloggernepal.com/api/today"
RESULT=$(curl -s $API | jq -r .res)

TODAY=$(echo $RESULT | jq -r '.days[] | select(.tag == "today") | .bs')
MONTH=$(echo $RESULT | jq -r .name)
YEAR=$(echo $RESULT | jq -r .year)

echo -e "{\"day\":\"$TODAY\", \"month\":\"$MONTH\", \"year\": \"$YEAR\"}"
