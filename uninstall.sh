#!/usr/bin/env bash
# Terminal uninstaller (macOS / Linux). Double-click: uninstall.command (mac) / uninstall.bat (win).
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
exec node "$DIR/uninstall.cjs" "$@"
