#!/usr/bin/env bash
set -euo pipefail

device="$(route -n get default 2>/dev/null | awk '/interface:/ { print $2; exit }')"
[[ -n "$device" ]] || device="$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2; exit}')"
[[ -n "$device" ]] || exit 0

read -r ibytes obytes <<DATA
$(netstat -ibn 2>/dev/null | awk -v dev="$device" '$1 == dev && $7 ~ /^[0-9]+$/ && $10 ~ /^[0-9]+$/ { inb += $7; outb += $10 } END { printf "%.0f %.0f\n", inb, outb }')
DATA

now="$(date +%s)"
state="/tmp/rice-network-$device.state"
last_i="$ibytes"
last_o="$obytes"
last_t="$now"
if [[ -f "$state" ]]; then
  read -r last_i last_o last_t < "$state" || true
fi
printf '%s %s %s\n' "$ibytes" "$obytes" "$now" > "$state"

dt=$(( now - last_t ))
(( dt > 0 )) || dt=1
down=$(( (ibytes - last_i) / dt ))
up=$(( (obytes - last_o) / dt ))
(( down >= 0 )) || down=0
(( up >= 0 )) || up=0

human() {
  awk -v b="$1" 'BEGIN {
    if (b >= 1048576) printf "%.1fm", b / 1048576;
    else if (b >= 1024) printf "%.0fk", b / 1024;
    else printf "%.0fb", b;
  }'
}

sketchybar --set "$NAME" label="↓$(human "$down") ↑$(human "$up")"
