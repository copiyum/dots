#!/usr/bin/env bash
set -euo pipefail

if [[ -d /Applications/Raycast.app || -d "$HOME/Applications/Raycast.app" ]]; then
  open -a Raycast
elif command -v choose >/dev/null 2>&1; then
  app="$(osascript -e 'tell application "System Events" to get name of every application process whose background only is false' | tr ',' '\n' | sed 's/^ *//' | sort -u | choose || true)"
  [[ -n "$app" ]] && open -a "$app"
else
  open -a "Spotlight"
fi
