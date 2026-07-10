#!/usr/bin/env bash
set -euo pipefail

if command -v brew >/dev/null 2>&1; then
  brew services stop sketchybar >/dev/null 2>&1 || true
  brew services stop borders >/dev/null 2>&1 || true
fi

pkill -x AutoRaise >/dev/null 2>&1 || true
pkill -x sketchybar >/dev/null 2>&1 || true
pkill -x borders >/dev/null 2>&1 || true
