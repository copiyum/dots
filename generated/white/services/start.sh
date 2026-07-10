#!/usr/bin/env bash
set -euo pipefail

sketchybar_query() {
  if ! command -v sketchybar >/dev/null 2>&1; then
    return 1
  fi
  if command -v timeout >/dev/null 2>&1; then
    timeout 1s sketchybar --query bar 2>/dev/null || true
  elif command -v gtimeout >/dev/null 2>&1; then
    gtimeout 1s sketchybar --query bar 2>/dev/null || true
  else
    sketchybar --query bar 2>/dev/null || true
  fi
}

sketchybar_alive() {
  [[ -n "$(sketchybar_query)" ]]
}

hide_native_menu_bar() {
  if ! command -v defaults >/dev/null 2>&1; then
    return 0
  fi
  local current
  current="$(defaults read NSGlobalDomain _HIHideMenuBar 2>/dev/null || true)"
  defaults write NSGlobalDomain _HIHideMenuBar -bool true || true
  if [[ "$current" != "1" ]]; then
    killall SystemUIServer >/dev/null 2>&1 || true
    sleep 0.5
  fi
}

stop_sketchybar() {
  local pid
  if command -v brew >/dev/null 2>&1; then
    brew services stop sketchybar >/dev/null 2>&1 || true
  fi
  pgrep -f '/sketchybar/bin/sketchybar' 2>/dev/null | while read -r pid; do
    kill "$pid" >/dev/null 2>&1 || true
  done || true
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    pgrep -f '/sketchybar/bin/sketchybar' >/dev/null 2>&1 || return 0
    sleep 0.1
  done
  pgrep -f '/sketchybar/bin/sketchybar' 2>/dev/null | while read -r pid; do
    kill -9 "$pid" >/dev/null 2>&1 || true
  done || true
}

start_sketchybar() {
  if command -v brew >/dev/null 2>&1; then
    brew services start sketchybar >/dev/null 2>&1 || true
    sleep 0.8
  fi
  if ! sketchybar_alive; then
    sketchybar --config "$HOME/.config/sketchybar/sketchybarrc" >/tmp/rice-sketchybar.log 2>&1 &
    sleep 0.5
  fi
  if sketchybar_alive; then
    sketchybar --reload "$HOME/.config/sketchybar/sketchybarrc" >/tmp/rice-sketchybar.log 2>&1 || true
  fi
}

missing=0
for cmd in sketchybar borders; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf 'Missing command: %s\n' "$cmd" >&2
    missing=1
  fi
done

if [[ "$missing" -eq 1 ]]; then
  printf 'Run: brew bundle --file /Users/ash/macos-rice/Brewfile\n' >&2
fi

hide_native_menu_bar
open -gja "AeroSpace" 2>/dev/null || true
open -gja "AutoRaise" 2>/dev/null || true

if command -v sketchybar >/dev/null 2>&1; then
  stop_sketchybar
  start_sketchybar
fi

if command -v brew >/dev/null 2>&1 && command -v borders >/dev/null 2>&1; then
  brew services restart borders >/dev/null 2>&1 || "$HOME/.config/borders/bordersrc" >/tmp/rice-borders.log 2>&1 &
elif [[ -x "$HOME/.config/borders/bordersrc" ]]; then
  "$HOME/.config/borders/bordersrc" >/tmp/rice-borders.log 2>&1 &
fi

if command -v aerospace >/dev/null 2>&1; then
  aerospace reload-config >/dev/null 2>&1 || true
fi
