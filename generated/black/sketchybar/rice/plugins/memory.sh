#!/usr/bin/env bash
set -euo pipefail

used="$(vm_stat | awk '
  /Pages active/ { active=$3 }
  /Pages wired down/ { wired=$4 }
  /Pages occupied by compressor/ { comp=$5 }
  END {
    gsub(/\./, "", active); gsub(/\./, "", wired); gsub(/\./, "", comp);
    mb=(active+wired+comp)*4096/1024/1024;
    printf "%.0fM", mb
  }')"

sketchybar --set "$NAME" label="$used"
