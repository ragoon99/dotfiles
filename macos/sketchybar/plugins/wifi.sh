#!/bin/bash

# Loads defined colors
source "$CONFIG_DIR/globalstyles.sh"

# IS_VPN=$(/usr/local/bin/piactl get connectionstate)
IS_VPN="Disconnected"
# CURRENT_WIFI="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)"
CURRENT_WIFI="$(ipconfig getsummary en0)"
# IP_ADDRESS="$(ipconfig getifaddr en0)"
IP_ADDRESS="$(echo "$CURRENT_WIFI" | grep -o "yiaddr = .*" | sed 's/^yiaddr = //')"
SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID : .*" | sed 's/^SSID : //' | tail -n 1)"
# CURR_TX="$(echo "$CURRENT_WIFI" | grep -o "lastTxRate: .*" | sed 's/^lastTxRate: //')"

if [[ $IS_VPN != "Disconnected" ]]; then
  ICON_COLOR=$HIGHLIGHT
  ICON=$ICON_VPN
elif [[ $SSID != "" ]]; then
  ICON_COLOR=$(getcolor white)
  ICON=$ICON_WIFI
elif [[ $CURRENT_WIFI = "AirPort: Off" ]]; then
  ICON=􀐾
else
  ICON_COLOR=$(getcolor white 25)
  ICON=$ICON_WIFI_OFF
fi

render_bar_item() {
  # DRAWING=$([ "$(cat /tmp/sketchybar_sender)" == "focus_on" ] && echo "off" || echo "on")
  sketchybar --set $NAME \
    icon.color=$ICON_COLOR \
    icon=$ICON \
    drawing=on
}

render_popup() {
  if [ "$SSID" != "" ]; then
    args=(
      --set wifi.ssid label="$SSID" icon=$ICON_WIFI
      --set wifi.ipaddress label="$IP_ADDRESS" icon="IP"
      click_script="printf $IP_ADDRESS | pbcopy;sketchybar --set wifi popup.drawing=toggle"
    )
  else
    args=(
      --set wifi.ssid label="Not connected"
      --set wifi.ipaddress label="No IP"
      )
  fi

  sketchybar "${args[@]}" >/dev/null
}

update() {
  render_bar_item
  render_popup
}

popup() {
  sketchybar --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
"routine" | "forced" | "wifi_change")
  update
  ;;
"mouse.clicked")
  popup toggle
  ;;
esac
