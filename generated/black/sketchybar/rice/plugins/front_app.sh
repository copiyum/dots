#!/usr/bin/env bash
set -euo pipefail
source "$CONFIG_DIR/rice/colors.sh"
sketchybar --set "$NAME" label="${INFO:-Desktop}"
