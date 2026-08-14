#!/usr/bin/env bash
# dsh-theme-wallpaper installer / 一键安装脚本
# Usage / 用法:
#   ./install.sh            # default profile: web
#   ./install.sh myprofile  # use a different profile
set -euo pipefail

PROFILE="${1:-web}"
DSH_HOME="${DSH_HOME:-$HOME/.dsh}"
PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
# 从 package.json 读取包名，避免依赖文件夹名 / read the package name from package.json
PLUGIN_NAME="$(node -p "require('$PLUGIN_DIR/package.json').name" 2>/dev/null || true)"
if [ -z "$PLUGIN_NAME" ]; then
  echo "错误：找不到 package.json，请在插件目录内运行。/ Error: package.json not found. Run from inside the plugin folder." >&2
  exit 1
fi

NODE_MODULES="$DSH_HOME/profiles/node_modules"
PATCH_FILE="$DSH_HOME/profiles/$PROFILE/cordis.patch.yml"

echo "==> DSH 目录 / home: $DSH_HOME"
echo "==> Profile: $PROFILE"
echo "==> 插件名 / plugin: $PLUGIN_NAME"

# 1) 复制插件 / copy the plugin
mkdir -p "$NODE_MODULES"
if [ -d "$NODE_MODULES/$PLUGIN_NAME" ]; then
  echo "==> 已存在，覆盖复制 / already exists, overwriting..."
  rm -rf "$NODE_MODULES/$PLUGIN_NAME"
fi
cp -R "$PLUGIN_DIR" "$NODE_MODULES/$PLUGIN_NAME"
# 去掉 .git 目录，避免污染 node_modules / drop .git to keep node_modules clean
rm -rf "$NODE_MODULES/$PLUGIN_NAME/.git"
echo "==> 已复制到 / copied to: $NODE_MODULES/$PLUGIN_NAME"

# 2) 写入 cordis.patch.yml / write cordis.patch.yml
INSERT_BLOCK='- insert:
    - id: theme-wallpaper
      name: dsh-theme-wallpaper'

if [ ! -f "$PATCH_FILE" ]; then
  echo "==> 未找到 $PATCH_FILE，新建 / not found, creating..."
  mkdir -p "$(dirname "$PATCH_FILE")"
  printf '%s\n' "$INSERT_BLOCK" > "$PATCH_FILE"
elif grep -q 'dsh-theme-wallpaper' "$PATCH_FILE"; then
  echo "==> cordis.patch.yml 已包含该插件，跳过 / already registered, skipping"
else
  if [ "$(tr -d '[:space:]' < "$PATCH_FILE")" = "[]" ]; then
    printf '%s\n' "$INSERT_BLOCK" > "$PATCH_FILE"
    echo "==> 已写入 cordis.patch.yml / written"
  else
    printf '\n%s\n' "$INSERT_BLOCK" >> "$PATCH_FILE"
    echo "==> 已追加到 cordis.patch.yml 末尾，请确认缩进正确 / appended; verify YAML indentation"
  fi
fi

echo
echo "✅ 安装完成 / Done！重启生效 / restart to apply："
echo "   dsh web"
echo "   然后强制刷新页面 / then hard-refresh: Cmd+Shift+R"
