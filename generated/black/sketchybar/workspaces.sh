#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/colors.sh"

for sid in 1 2 3 4 5 6 7 8 9 10; do
  sketchybar --add item "ws.$sid" left \
    --subscribe "ws.$sid" aerospace_workspace_change front_app_switched \
    --set "ws.$sid" \
      icon="$sid" \
      icon.font="JetBrainsMono Nerd Font:Medium:12.5" \
      icon.color="$BEO_PILL_FG" \
      label.font="JetBrainsMono Nerd Font:Medium:12.5" \
      label.color="$BEO_MUTED" \
      icon.padding_left=8 \
      icon.padding_right=8 \
      label.drawing=off \
      label.padding_left=6 \
      label.padding_right=8 \
      padding_left=5 \
      padding_right=5 \
      update_freq=5 \
      updates=on \
      background.drawing=on \
      background.color="$BEO_PILL_BG" \
      background.height=28 \
      background.corner_radius=14 \
      script="$DIR/plugins/aerospace.sh $sid" \
      click_script="aerospace workspace $sid"
done
