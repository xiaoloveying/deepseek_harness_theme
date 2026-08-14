#!/usr/bin/env bash
# dsh-theme-wallpaper uninstaller / 一键卸载脚本
# Usage / 用法:
#   ./uninstall.sh            # default profile: web
#   ./uninstall.sh myprofile  # use a different profile
set -euo pipefail

PROFILE="${1:-web}"
DSH_HOME="${DSH_HOME:-$HOME/.dsh}"
NODE_MODULES="$DSH_HOME/profiles/node_modules"
PLUGIN_NAME="dsh-theme-wallpaper"
PATCH_FILE="$DSH_HOME/profiles/$PROFILE/cordis.patch.yml"

echo "==> DSH home: $DSH_HOME  profile: $PROFILE"

# 1) 删除插件目录 / remove the plugin folder
if [ -d "$NODE_MODULES/$PLUGIN_NAME" ]; then
  rm -rf "$NODE_MODULES/$PLUGIN_NAME"
  echo "==> 已删除插件目录 / removed: $NODE_MODULES/$PLUGIN_NAME"
else
  echo "==> 插件目录不存在（可能已卸载）/ plugin folder not found"
fi

# 2) 从 cordis.patch.yml 移除主题记录 / remove the plugin row
if [ ! -f "$PATCH_FILE" ]; then
  echo "==> 未找到 $PATCH_FILE（无需修改）/ not found, nothing to patch"
else
  node - "$PATCH_FILE" <<'NODE'
const fs = require('fs');
const file = process.argv[2];
const s = fs.readFileSync(file, 'utf8');

if (!s.includes('dsh-theme-wallpaper')) {
  console.log('==> cordis.patch.yml 里没有主题记录，无需修改 / no theme row, skipped');
  process.exit(0);
}

let lines = s.split('\n');

// Pass 1: 删除主题的子项（"- id: theme-wallpaper" 及其更深缩进的 name/disabled 行）
// Pass 1: drop the theme sub-item ("- id: theme-wallpaper" plus its deeper-indented lines)
{
  const out = [];
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    const m = line.match(/^(\s*)- id: theme-wallpaper\s*$/);
    if (m) {
      const baseIndent = m[1].length;
      i++;
      while (i < lines.length) {
        const l = lines[i];
        if (l.trim() === '') break;
        const ind = (l.match(/^\s*/) || [''])[0].length;
        if (ind <= baseIndent) break;
        i++;
      }
      continue;
    }
    out.push(line);
    i++;
  }
  lines = out;
}

// Pass 2: 删除已经没有子项的 "- insert:" 空块
// Pass 2: drop "- insert:" blocks that ended up with no children
{
  const out = [];
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    if (/^- insert:\s*$/.test(line)) {
      let j = i + 1;
      let hasChild = false;
      while (j < lines.length) {
        const l = lines[j];
        if (l.trim() === '') { j++; continue; }
        if (!/^\s/.test(l)) break;
        hasChild = true;
        break;
      }
      if (!hasChild) {
        i = j;
        while (i < lines.length && lines[i].trim() === '') i++;
        continue;
      }
    }
    out.push(line);
    i++;
  }
  lines = out;
}

let result = lines.join('\n').trimEnd() + '\n';
const meaningful = lines.filter(l => { const t = l.trim(); return t !== '' && !t.startsWith('#'); });
if (meaningful.length === 0) {
  // 只剩注释/空行时，写一个空数组 [] 保证 YAML 合法
  // When only comments/blank lines remain, write an empty array [] to stay valid.
  const comments = lines.filter(l => l.trim().startsWith('#'));
  result = (comments.length ? comments.join('\n') + '\n\n' : '') + '[]\n';
} else {
  result = result.replace(/\n{3,}/g, '\n\n');
}

fs.writeFileSync(file, result);
console.log('==> 已从 cordis.patch.yml 移除主题记录 / removed the theme row');
NODE
fi

echo
echo "✅ 卸载完成 / Uninstalled！重启生效 / restart to apply："
echo "   npx @deepseek-ai/dsh web"
