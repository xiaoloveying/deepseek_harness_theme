#!/bin/bash
# macOS double-click installer
cd "$(dirname "$0")"
echo "Installing dsh-theme-wallpaper..."
node install.cjs "$@"
echo ""
read -p "按任意键退出 / Press any key to exit..."
