#!/usr/bin/env bash
set -euo pipefail

options=$'25%\n50%\n75%\n100%\nSettings'
if command -v choose >/dev/null 2>&1; then
  choice="$(printf "%s\n" "$options" | choose || true)"
else
  choice="Settings"
fi

case "$choice" in
  25%) command -v brightness >/dev/null 2>&1 && brightness 0.25 ;;
  50%) command -v brightness >/dev/null 2>&1 && brightness 0.50 ;;
  75%) command -v brightness >/dev/null 2>&1 && brightness 0.75 ;;
  100%) command -v brightness >/dev/null 2>&1 && brightness 1.0 ;;
  Settings) open "x-apple.systempreferences:com.apple.Displays-Settings.extension" 2>/dev/null || open -a "System Settings" ;;
esac
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}" NAME="rice.brightness" "$CONFIG_DIR/rice/plugins/brightness.sh" >/dev/null 2>&1 || true
