#!/usr/bin/env bash
set -euo pipefail
source "$CONFIG_DIR/rice/colors.sh"

title="${INFO:-Desktop}"
sketchybar --set "$NAME" \
  icon.drawing=off \
  label="$title" \
  label.max_chars=80 \
  background.color="$RICE_BAR_ALT"
