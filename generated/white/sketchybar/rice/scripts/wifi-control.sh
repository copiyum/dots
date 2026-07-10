#!/usr/bin/env bash
set -euo pipefail

device="$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2; exit}')"
[[ -n "$device" ]] || exit 0

tmp="$(mktemp -t rice-wifi.XXXXXX)"
trap 'rm -f "$tmp"' EXIT

current="$(networksetup -getairportnetwork "$device" 2>/dev/null | sed -n 's/^Current Wi-Fi Network: //p')"

scan_networks() {
  command -v swift >/dev/null 2>&1 || return 0
  swift - <<'SWIFT' 2>/dev/null || true
import CoreWLAN

if let iface = CWWiFiClient.shared().interface() {
  do {
    let networks = try iface.scanForNetworks(withName: nil)
    let ssids = Set(networks.compactMap { $0.ssid }.filter { !$0.isEmpty })
    for ssid in ssids.sorted() {
      print(ssid)
    }
  } catch {
  }
}
SWIFT
}

{
  printf 'On\t__on__\n'
  printf 'Off\t__off__\n'
  {
    scan_networks
    networksetup -listpreferredwirelessnetworks "$device" 2>/dev/null | sed '1d'
  } |
    sed 's/^[[:space:]]*//' |
    awk 'NF' |
    sort -u |
    while IFS= read -r ssid; do
      if [[ "$ssid" == "$current" ]]; then
        printf '● %s\t%s\n' "$ssid" "$ssid"
      else
        printf '○ %s\t%s\n' "$ssid" "$ssid"
      fi
    done
  printf 'Other...\t__other__\n'
  printf 'Settings\t__settings__\n'
} > "$tmp"

if command -v choose >/dev/null 2>&1; then
  choice="$(cut -f1 "$tmp" | choose || true)"
else
  choice="Settings"
fi
[[ -n "$choice" ]] || exit 0

target="$(awk -F '\t' -v choice="$choice" '$1 == choice { print $2; exit }' "$tmp")"

connect_network() {
  local ssid="$1"
  [[ -n "$ssid" ]] || return 0
  networksetup -setairportpower "$device" on >/dev/null 2>&1 || true
  if ! networksetup -setairportnetwork "$device" "$ssid" >/dev/null 2>&1; then
    password="$(osascript -e 'text returned of (display dialog "Wi-Fi password" default answer "" with hidden answer buttons {"Cancel", "Join"} default button "Join")' 2>/dev/null || true)"
    [[ -n "$password" ]] && networksetup -setairportnetwork "$device" "$ssid" "$password" >/dev/null 2>&1 || true
  fi
}

case "$target" in
  __on__) networksetup -setairportpower "$device" on ;;
  __off__) networksetup -setairportpower "$device" off ;;
  __other__)
    ssid="$(osascript -e 'text returned of (display dialog "Wi-Fi network name" default answer "" buttons {"Cancel", "Next"} default button "Next")' 2>/dev/null || true)"
    connect_network "$ssid"
    ;;
  __settings__) open "x-apple.systempreferences:com.apple.wifi-settings-extension" 2>/dev/null || open -a "System Settings" ;;
  *) connect_network "$target" ;;
esac
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}" NAME="rice.wifi" "$CONFIG_DIR/rice/plugins/wifi.sh" >/dev/null 2>&1 || true
