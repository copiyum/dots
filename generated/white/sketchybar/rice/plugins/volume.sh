#!/usr/bin/env bash
set -euo pipefail

vol="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null || printf -- "--")"
sketchybar --set "$NAME" label="${vol}%"
