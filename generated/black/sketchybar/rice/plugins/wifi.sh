#!/usr/bin/env bash
set -euo pipefail

source "$CONFIG_DIR/rice/colors.sh"

device="$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2; exit}')"
if [[ -z "$device" ]]; then
  sketchybar --set "$NAME" icon="󰖪" label.drawing=off icon.color="$RICE_DOT_INACTIVE"
  exit 0
fi

power="$(networksetup -getairportpower "$device" 2>/dev/null | awk '{print $NF}')"
if [[ "$power" == "On" ]]; then
  sketchybar --set "$NAME" icon="󰖩" label.drawing=off icon.color="$RICE_BAR_FG"
else
  sketchybar --set "$NAME" icon="󰖪" label.drawing=off icon.color="$RICE_DOT_INACTIVE"
fi
