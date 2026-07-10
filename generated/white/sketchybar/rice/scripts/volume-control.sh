#!/usr/bin/env bash
set -euo pipefail

options=$'Mute\n25%\n50%\n75%\n100%\nSettings'
if command -v choose >/dev/null 2>&1; then
  choice="$(printf "%s\n" "$options" | choose || true)"
else
  choice="Settings"
fi

case "$choice" in
  Mute) osascript -e 'set volume with output muted' ;;
  25%) osascript -e 'set volume output volume 25 without output muted' ;;
  50%) osascript -e 'set volume output volume 50 without output muted' ;;
  75%) osascript -e 'set volume output volume 75 without output muted' ;;
  100%) osascript -e 'set volume output volume 100 without output muted' ;;
  Settings) open "x-apple.systempreferences:com.apple.Sound-Settings.extension" 2>/dev/null || open -a "System Settings" ;;
esac
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}" NAME="rice.volume" "$CONFIG_DIR/rice/plugins/volume.sh" >/dev/null 2>&1 || true
