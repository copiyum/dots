#!/usr/bin/env bash
set -euo pipefail

options=$'󰌾 Lock\n󰤄 Sleep\n󰜉 Restart\n󰐥 Shut Down'
if command -v choose >/dev/null 2>&1; then
  choice="$(printf "%s\n" "$options" | choose || true)"
else
  choice="$(osascript -e 'button returned of (display dialog "Power" buttons {"Lock", "Sleep", "Restart", "Shut Down", "Cancel"} default button "Cancel")' 2>/dev/null || true)"
fi

case "$choice" in
  *Lock*) /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend ;;
  *Sleep*) pmset sleepnow ;;
  *Restart*) osascript -e 'tell app "System Events" to restart' ;;
  *"Shut Down"*) osascript -e 'tell app "System Events" to shut down' ;;
esac
