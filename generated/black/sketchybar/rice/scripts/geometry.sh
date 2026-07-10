#!/usr/bin/env bash
set -euo pipefail

direction="${1:-}"
case "$direction" in
  up)
    orientation="vertical"
    opposite="down"
    ;;
  down)
    orientation="vertical"
    opposite="up"
    ;;
  left)
    orientation="horizontal"
    opposite="right"
    ;;
  right)
    orientation="horizontal"
    opposite="left"
    ;;
  *)
    exit 64
    ;;
esac

focused_id() {
  aerospace list-windows --focused --format '%{window-id}' 2>/dev/null | awk 'NR == 1 { print $1 }'
}

workspace_window_count() {
  aerospace list-windows --workspace focused --count 2>/dev/null || printf '0'
}

target="$(focused_id)"
[[ -n "$target" ]] || exit 0

aerospace layout --root tiles "$orientation" >/dev/null 2>&1 || true
aerospace focus --window-id "$target" >/dev/null 2>&1 || true

# Push the focused window all the way toward the requested screen edge.
for _ in 1 2 3 4 5 6 7 8; do
  aerospace move "$direction" >/dev/null 2>&1 || true
done

# With 3+ windows, group the remaining side so the promoted window can span
# the whole opposite half instead of sharing a flat 3-way split.
if [[ "$(workspace_window_count)" -ge 3 ]]; then
  aerospace focus --window-id "$target" >/dev/null 2>&1 || true
  if aerospace focus "$opposite" >/dev/null 2>&1; then
    other="$(focused_id)"
    if [[ -n "$other" && "$other" != "$target" ]]; then
      aerospace join-with "$opposite" >/dev/null 2>&1 || true
    fi
  fi
fi

aerospace focus --window-id "$target" >/dev/null 2>&1 || true
aerospace balance-sizes >/dev/null 2>&1 || true
