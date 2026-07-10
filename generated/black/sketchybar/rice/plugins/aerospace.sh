#!/usr/bin/env bash
set -euo pipefail
source "$CONFIG_DIR/rice/colors.sh"

sid="${1:?workspace id required}"
focused="${FOCUSED_WORKSPACE:-}"

if [[ -z "$focused" ]] && command -v aerospace >/dev/null 2>&1; then
  focused="$(aerospace list-workspaces --focused 2>/dev/null || true)"
fi

icon="$sid"

app_symbol() {
  local app="$1"
  local title="${2:-}"
  local text="$app $title"
  case "$app" in
    Zen*|Safari*|Orion*|Google\ Chrome*|Chrome*|Arc*|Firefox*|Brave\ Browser*) printf '󰖟\n' ;;
    YouTube*|YouTube\ Music*) printf '\n' ;;
    Spotify*) printf '\n' ;;
    Music*) printf '♪\n' ;;
    WhatsApp*|‎WhatsApp*) printf '\n' ;;
    Discord*) printf '\n' ;;
    Slack*) printf '󰒱\n' ;;
    Messages*|Telegram*|Signal*) printf '󰍩\n' ;;
    Ghostty*|iTerm2*|Terminal*|Alacritty*|kitty*|WezTerm*) printf '>_\n' ;;
    Obsidian*) printf '󱞁\n' ;;
    Zed*|Code*|Visual\ Studio\ Code*|Cursor*|Windsurf*|Augment*) printf '󰨞\n' ;;
    Finder*) printf '󰀶\n' ;;
    Raycast*) printf '󰌌\n' ;;
    Notes*) printf '󰎞\n' ;;
    Mail*) printf '󰇮\n' ;;
    Calendar*) printf '󰃭\n' ;;
    Preview*) printf '󰋩\n' ;;
    Stremio*) printf '▶\n' ;;
    *)
      case "$text" in
        *YouTube*|*youtube*) printf '\n' ;;
        *) printf '•\n' ;;
      esac
      ;;
  esac
}

apps=""
if command -v aerospace >/dev/null 2>&1; then
  apps="$(
    aerospace list-windows --workspace "$sid" --format '%{app-name}	%{window-title}' 2>/dev/null |
      while IFS=$'\t' read -r app title; do
        [[ -n "$app" ]] && app_symbol "$app" "$title"
      done |
      awk 'NF && !seen[$0]++ { items = items ? items "  " $0 : $0 } END { print items }'
  )"
fi

label="$apps"

if [[ -n "$label" ]]; then
  label_state=on
  icon_gap=4
else
  label_state=off
  icon_gap=8
fi

if [[ "$sid" == "$focused" ]]; then
  sketchybar --set "$NAME" \
    icon="$icon" icon.color="$BEO_ACTIVE_FG" icon.padding_left=8 icon.padding_right="$icon_gap" \
    label="$label" label.color="$BEO_ACTIVE_FG" label.drawing="$label_state" label.padding_left=4 label.padding_right=10 \
    background.color="$BEO_ACTIVE_BG"
else
  sketchybar --set "$NAME" \
    icon="$icon" icon.color="$BEO_PILL_FG" icon.padding_left=8 icon.padding_right="$icon_gap" \
    label="$label" label.color="$BEO_MUTED" label.drawing="$label_state" label.padding_left=4 label.padding_right=10 \
    background.color="$BEO_PILL_BG"
fi
