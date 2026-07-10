#!/usr/bin/env bash
set -euo pipefail

ROOT="/Users/ash/dotfiles"
options=$'White\nBlack'

if command -v choose >/dev/null 2>&1; then
  choice="$(printf "%s\n" "$options" | choose || true)"
else
  choice="$(osascript -e 'button returned of (display dialog "macOS Rice theme" buttons {"White", "Black", "Cancel"} default button "Black")' 2>/dev/null || true)"
fi

case "$choice" in
  White) "$ROOT/scripts/rice-theme" --apply white ;;
  Black) "$ROOT/scripts/rice-theme" --apply black ;;
esac
