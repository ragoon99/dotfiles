#!/bin/bash

POPUP_OFF="sketchybar --set wifi popup.drawing=off"

wifi=(
  "${menu_defaults[@]}"
  background.color=$(getcolor black 25)
  background.corner_radius=4
  background.height=20
  background.padding_left=$(($PADDINGS / 2))
  background.padding_right=$(($PADDINGS / 2))
  icon.padding_right=10
  icon.padding_left=10
  label.drawing=off
  popup.align=right
  update_freq=5
  script="$PLUGIN_DIR/wifi.sh"
  --subscribe wifi wifi_change
                   mouse.clicked
                   mouse.exited
                   mouse.exited.global
)

sketchybar                                                                                            \
  --add item wifi right                                                                               \
  --set wifi "${wifi[@]}"                                                                             \
  --add item wifi.ssid popup.wifi                                                                     \
  --set wifi.ssid icon=􀅴                                                                              \
        label="SSID"                                                                                  \
        "${menu_item_defaults[@]}"                                                                    \
        click_script="open 'x-apple.systempreferences:com.apple.preference.network?Wi-Fi';$POPUP_OFF" \
  --add item wifi.ipaddress popup.wifi                                                                \
  --set wifi.ipaddress icon=􀆪                                                                         \
        label="IP Address"                                                                            \
        "${menu_item_defaults[@]}"                                                                    \
        click_script="echo \"$IP_ADDRESS\"|pbcopy;$POPUP_OFF"
