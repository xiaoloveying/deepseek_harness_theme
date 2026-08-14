#!/bin/bash
# macOS double-click uninstaller
cd "$(dirname "$0")"
echo "Uninstalling dsh-theme-wallpaper..."
node uninstall.cjs "$@"
echo ""
read -p "按任意键退出 / Press any key to exit..."
