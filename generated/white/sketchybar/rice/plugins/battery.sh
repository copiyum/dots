#!/usr/bin/env bash
set -euo pipefail

percent="$(pmset -g batt | awk 'match($0, /[0-9]+%/) { print substr($0, RSTART, RLENGTH); exit }')"
sketchybar --set "$NAME" label="${percent:---}"
