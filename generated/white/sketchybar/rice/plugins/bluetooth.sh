#!/usr/bin/env bash
set -euo pipefail

source "$CONFIG_DIR/rice/colors.sh"

if ! command -v blueutil >/dev/null 2>&1; then
  sketchybar --set "$NAME" icon="" label.drawing=off icon.color="$BEO_MUTED"
  exit 0
fi

if [[ "$(blueutil -p 2>/dev/null || printf 0)" == "1" ]]; then
  sketchybar --set "$NAME" icon="" label.drawing=off icon.color="$BEO_PILL_FG"
else
  sketchybar --set "$NAME" icon="" label.drawing=off icon.color="$BEO_MUTED"
fi
