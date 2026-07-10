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

for cmd in aerospace sketchybar borders ghostty oh-my-posh atuin choose; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '%-12s %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf '%-12s missing\n' "$cmd"
  fi
done

if [[ -d "/Applications/AutoRaise.app" ]]; then
  printf '%-12s %s\n' "AutoRaise" "/Applications/AutoRaise.app"
else
  printf '%-12s missing\n' "AutoRaise"
fi

pgrep -x AutoRaise >/dev/null && printf 'AutoRaise    running\n' || printf 'AutoRaise    stopped\n'
sketchybar_alive && printf 'sketchybar   running\n' || printf 'sketchybar   stopped\n'
pgrep -x borders >/dev/null && printf 'borders      running\n' || printf 'borders      stopped\n'
