#!/usr/bin/env bash
# Terminal installer (macOS / Linux). Double-click: install.command (mac) / install.bat (win).
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
exec node "$DIR/install.cjs" "$@"
