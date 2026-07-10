#!/usr/bin/env bash
set -euo pipefail

label="--%"
if command -v brightness >/dev/null 2>&1; then
  value="$(brightness -l 2>/dev/null | awk '/brightness/ { printf "%d%%", ($NF * 100); exit }')"
  [[ -n "$value" ]] && label="$value"
fi

sketchybar --set "$NAME" icon="" label="$label" label.drawing=on
