#!/usr/bin/env bash
set -euo pipefail

if [[ -d /Applications/Raycast.app || -d "$HOME/Applications/Raycast.app" ]]; then
  open 'raycast://extensions/limonkufu/aerospace/switchApps?arguments=%7B%22workspace%22%3A%22all%22%7D'
else
  "$HOME/.config/sketchybar/rice/scripts/search.sh"
fi
