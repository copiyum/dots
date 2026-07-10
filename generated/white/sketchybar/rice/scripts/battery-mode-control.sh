#!/usr/bin/env bash
set -euo pipefail

options=$'Low Power\nAutomatic\nHigh Power\nSettings'
if command -v choose >/dev/null 2>&1; then
  choice="$(printf "%s\n" "$options" | choose || true)"
else
  choice="Settings"
fi

case "$choice" in
  "Low Power") pmset -a powermode 0 ;;
  Automatic) pmset -a powermode 1 ;;
  "High Power") pmset -a powermode 2 ;;
  Settings) open "x-apple.systempreferences:com.apple.Battery-Settings.extension" 2>/dev/null || open -a "System Settings" ;;
esac
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}" NAME="rice.battery" "$CONFIG_DIR/rice/plugins/battery.sh" >/dev/null 2>&1 || true
