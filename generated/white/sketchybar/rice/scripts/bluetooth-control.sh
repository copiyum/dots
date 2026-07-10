#!/usr/bin/env bash
set -euo pipefail

tmp="$(mktemp -t rice-bluetooth.XXXXXX)"
trap 'rm -f "$tmp"' EXIT

{
  printf 'On\t__on__\t\n'
  printf 'Off\t__off__\t\n'
  if command -v blueutil >/dev/null 2>&1; then
    blueutil --paired --format new-default 2>/dev/null |
      awk '
        {
          address=$0; sub(/^address: /, "", address); sub(/,.*/, "", address)
          name=$0; sub(/^.*name: /, "", name)
          connected=($0 ~ /connected: yes/) ? "yes" : "no"
          if (name != "") {
            marker=(connected == "yes") ? "●" : "○"
            printf "%s %s\t%s\t%s\n", marker, name, address, connected
          }
        }
      '
  fi
  printf 'Settings\t__settings__\t\n'
} > "$tmp"

if command -v choose >/dev/null 2>&1; then
  choice="$(cut -f1 "$tmp" | choose || true)"
else
  choice="Settings"
fi
[[ -n "$choice" ]] || exit 0

target="$(awk -F '\t' -v choice="$choice" '$1 == choice { print $2 "\t" $3; exit }' "$tmp")"
address="${target%%$'\t'*}"
state="${target#*$'\t'}"

case "$address" in
  __on__) command -v blueutil >/dev/null 2>&1 && blueutil -p on ;;
  __off__) command -v blueutil >/dev/null 2>&1 && blueutil -p off ;;
  __settings__) open "x-apple.systempreferences:com.apple.BluetoothSettings" 2>/dev/null || open -a "System Settings" ;;
  "")
    ;;
  *)
    if command -v blueutil >/dev/null 2>&1; then
      blueutil -p on >/dev/null 2>&1 || true
      if [[ "$state" == "yes" ]]; then
        blueutil --disconnect "$address" >/dev/null 2>&1 || true
      else
        blueutil --connect "$address" >/dev/null 2>&1 || true
      fi
    fi
    ;;
esac
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}" NAME="rice.bluetooth" "$CONFIG_DIR/rice/plugins/bluetooth.sh" >/dev/null 2>&1 || true
