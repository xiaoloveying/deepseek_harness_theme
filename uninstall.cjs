#!/usr/bin/env node
// Cross-platform uninstaller for dsh-theme-wallpaper (Windows / macOS / Linux).
const fs = require('fs');
const os = require('os');
const path = require('path');

const profile = process.argv[2] || 'web';
const dshHome = process.env.DSH_HOME || path.join(os.homedir(), '.dsh');
const pluginName = 'dsh-theme-wallpaper';
const nodeModules = path.join(dshHome, 'profiles', 'node_modules');
const patchFile = path.join(dshHome, 'profiles', profile, 'cordis.patch.yml');

console.log('==> DSH home: ' + dshHome);
console.log('==> Profile: ' + profile);

// 1) Remove the plugin folder.
const dest = path.join(nodeModules, pluginName);
if (fs.existsSync(dest)) {
  fs.rmSync(dest, { recursive: true, force: true });
  console.log('==> Removed: ' + dest);
} else {
  console.log('==> Plugin folder not found (already uninstalled?)');
}

// 2) Remove the plugin row from cordis.patch.yml.
let s = '';
try { s = fs.readFileSync(patchFile, 'utf8'); } catch {}
if (!s.includes('dsh-theme-wallpaper')) {
  console.log('==> cordis.patch.yml has no theme row, skipped');
} else {
  let lines = s.split('\n');

  // Pass 1: drop the theme sub-item ("- id: theme-wallpaper" + deeper-indented lines).
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

  // Pass 2: drop "- insert:" blocks that ended up with no children.
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
    const comments = lines.filter(l => l.trim().startsWith('#'));
    result = (comments.length ? comments.join('\n') + '\n\n' : '') + '[]\n';
  } else {
    result = result.replace(/\n{3,}/g, '\n\n');
  }

  fs.writeFileSync(patchFile, result);
  console.log('==> Removed the theme row from cordis.patch.yml');
}

console.log('');
console.log('Uninstalled! Restart Harness to apply: npx @deepseek-ai/dsh web');
