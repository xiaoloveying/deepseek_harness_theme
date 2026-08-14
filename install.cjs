#!/usr/bin/env node
// Cross-platform installer for dsh-theme-wallpaper (Windows / macOS / Linux).
const fs = require('fs');
const os = require('os');
const path = require('path');

const profile = process.argv[2] || 'web';
const dshHome = process.env.DSH_HOME || path.join(os.homedir(), '.dsh');
const pluginDir = __dirname;
const pkg = JSON.parse(fs.readFileSync(path.join(pluginDir, 'package.json'), 'utf8'));
const pluginName = pkg.name;
const nodeModules = path.join(dshHome, 'profiles', 'node_modules');
const patchFile = path.join(dshHome, 'profiles', profile, 'cordis.patch.yml');

console.log('==> DSH home: ' + dshHome);
console.log('==> Profile: ' + profile);
console.log('==> Plugin: ' + pluginName);

// 1) Copy the plugin (package.json + lib) into node_modules.
const dest = path.join(nodeModules, pluginName);
fs.rmSync(dest, { recursive: true, force: true });
fs.mkdirSync(dest, { recursive: true });
fs.copyFileSync(path.join(pluginDir, 'package.json'), path.join(dest, 'package.json'));
fs.cpSync(path.join(pluginDir, 'lib'), path.join(dest, 'lib'), { recursive: true });
console.log('==> Copied to: ' + dest);

// 2) Register the plugin in cordis.patch.yml.
const insertBlock = '- insert:\n    - id: theme-wallpaper\n      name: dsh-theme-wallpaper\n';
let content = '';
try { content = fs.readFileSync(patchFile, 'utf8'); } catch {}

if (content.includes('dsh-theme-wallpaper')) {
  console.log('==> cordis.patch.yml already has the plugin, skipped');
} else {
  fs.mkdirSync(path.dirname(patchFile), { recursive: true });
  const comments = content.split('\n').filter(l => l.trim().startsWith('#'));
  const body = content.split('\n').filter(l => l.trim() !== '' && !l.trim().startsWith('#'));
  if (body.length === 0 || (body.length === 1 && body[0].trim() === '[]')) {
    content = (comments.length ? comments.join('\n') + '\n\n' : '') + insertBlock;
  } else {
    content = content.replace(/\s*$/, '') + '\n\n' + insertBlock;
  }
  fs.writeFileSync(patchFile, content);
  console.log('==> Patched: ' + patchFile);
}

console.log('');
console.log('Done! Restart Harness to apply: npx @deepseek-ai/dsh web');
