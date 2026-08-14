# DeepSeek Harness 壁纸主题 · Wallpaper Theme Plugin

> **[English](#english) · [中文](#chinese)**

A client-side theme plugin that gives [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) a wallpaper background and semi-transparent panels.

![预览效果 · Preview](assets/preview.png)

<a id="english"></a>

## English

### What it does

- Full-page wallpaper background (cover, centered, fixed)
- Semi-transparent panels so the wallpaper shows through
- Works with both light and dark themes
- Pure client plugin — no host changes, safe to uninstall

### Requirements

- DeepSeek Harness installed and runnable via `npx @deepseek-ai/dsh web`
> If you installed Harness globally (`npm i -g @deepseek-ai/dsh`), run `dsh web` instead.
- Nothing else — the plugin is self-contained (the background image is embedded)

### Installation

> 💡 **Easiest — double-click install (no terminal):** after downloading the folder, double-click `install.command` on macOS or `install.bat` on Windows. It installs and registers everything for you; then just restart Harness. (To uninstall, double-click `uninstall.command` / `uninstall.bat`.)

**Step 1 — Download the plugin.** Either clone it:

```bash
git clone https://github.com/xiaoloveying/deepseek_harness_theme \
  ~/.dsh/profiles/node_modules/dsh-theme-wallpaper
```

or download the ZIP (**Code → Download ZIP**), unzip it, copy the folder into `~/.dsh/profiles/node_modules/`, and rename it to `dsh-theme-wallpaper`.

> If your Harness home is not `~/.dsh` (you set `DSH_HOME`), use your actual path instead.

**Step 2 — Register the plugin.** Edit `~/.dsh/profiles/web/cordis.patch.yml` (change `web` to your profile name if different):

```yaml
- insert:
    - id: theme-wallpaper
      name: dsh-theme-wallpaper
```

If the file already has content, append the block above to the end (keep the YAML indentation).

**Step 3 — Restart** and hard-refresh:

```bash
npx @deepseek-ai/dsh web
```

Then press `Cmd + Shift + R` (`Ctrl + Shift + R` on Windows/Linux).

### One-command installer

```bash
./install.sh           # default profile: web
./install.sh myprofile # use a different profile
```

The script copies the plugin and writes `cordis.patch.yml` for you; then just restart `npx @deepseek-ai/dsh web`.

### Enable / Disable

After restarting, the theme appears under **Settings → Plugins** in the Harness UI (read-only — there is no toggle button there).

To turn the theme **off** without uninstalling, add `disabled: true` to its row in `~/.dsh/profiles/web/cordis.patch.yml`:

```yaml
- insert:
    - id: theme-wallpaper
      name: dsh-theme-wallpaper
      disabled: true
```

To turn it back **on**, remove the `disabled: true` line (or delete the whole block). Restart `npx @deepseek-ai/dsh web` after each change.

### Uninstall

**Easiest — run the one-command uninstaller:**

```bash
./uninstall.sh           # default profile: web
./uninstall.sh myprofile # use a different profile
```

This removes both the plugin folder and its `cordis.patch.yml` entry for you. Then restart `npx @deepseek-ai/dsh web`.

**Or remove it manually:**

1. Remove the `- insert: ...` block you added in `cordis.patch.yml` (leave `[]` if the file becomes empty).
2. Delete the plugin folder:

   ```bash
   rm -rf ~/.dsh/profiles/node_modules/dsh-theme-wallpaper
   ```

3. Restart `npx @deepseek-ai/dsh web`.

### Files

| File | Description |
|---|---|
| `package.json` | Plugin manifest declaring `dsh.client` |
| `lib/index.js` | Host-side entry (no-op) |
| `lib/client.js` | Client entry — injects background + styles |
| `install.command` / `install.bat` | Double-click installer (macOS / Windows) |
| `uninstall.command` / `uninstall.bat` | Double-click uninstaller (macOS / Windows) |
| `install.sh` / `uninstall.sh` | Terminal installer / uninstaller |
| `install.cjs` / `uninstall.cjs` | Core logic used by the scripts above |

### Troubleshooting

- **No change after refresh?** Hard-refresh (`Cmd + Shift + R`), check the YAML indentation in Step 2, and make sure the folder is named `dsh-theme-wallpaper`.
- **"Cannot find package" on restart?** Confirm the plugin is at `~/.dsh/profiles/node_modules/dsh-theme-wallpaper/` with a `package.json` inside.

---

<a id="chinese"></a>

## 中文

### 效果

- 整页壁纸背景（居中、铺满、固定）
- 半透明面板，壁纸透出来
- 浅色 / 深色主题都适配
- 纯客户端插件，不碰主机数据，安全可卸载

### 前置条件

- 已装好 DeepSeek Harness，并能用 `npx @deepseek-ai/dsh web` 启动
> 如果你是用 `npm i -g @deepseek-ai/dsh` 全局安装的，改用 `dsh web` 即可。
- 无需其他依赖（插件自包含，背景图已内嵌）

### 安装

> 💡 **最简单 —— 双击安装（不用终端）**：下载文件夹后，Mac 上双击 `install.command`，Windows 上双击 `install.bat`，会自动完成安装和注册；然后重启 Harness 即可。（卸载就双击 `uninstall.command` / `uninstall.bat`。）

**第 1 步 · 下载插件**（任选其一）：

```bash
git clone https://github.com/xiaoloveying/deepseek_harness_theme \
  ~/.dsh/profiles/node_modules/dsh-theme-wallpaper
```

或下载 ZIP（**Code → Download ZIP**）解压后，把文件夹复制到 `~/.dsh/profiles/node_modules/`，并**改名为 `dsh-theme-wallpaper`**。

> 如果 Harness 用户目录不是 `~/.dsh`（设置了 `DSH_HOME`），请换成实际路径。

**第 2 步 · 注册插件**。编辑 `~/.dsh/profiles/web/cordis.patch.yml`（用别的 profile 就改成对应名字）：

```yaml
- insert:
    - id: theme-wallpaper
      name: dsh-theme-wallpaper
```

如果文件已有内容，就在**末尾追加**上面这段（保持 YAML 缩进一致）。

**第 3 步 · 重启**并强制刷新：

```bash
npx @deepseek-ai/dsh web
```

然后按 `Cmd + Shift + R`（Windows / Linux 用 `Ctrl + Shift + R`）。

### 一键安装

```bash
./install.sh           # 默认 profile 是 web
./install.sh myprofile # 指定别的 profile
```

脚本会自动复制插件并写入 `cordis.patch.yml`，然后你只需重启 `npx @deepseek-ai/dsh web`。

### 如何开关

重启后，这个主题会出现在 Harness 界面的「**设置 → 插件**」里（那里是只读列表，没有开关按钮）。

想**关闭**主题但又不卸载，就在 `~/.dsh/profiles/web/cordis.patch.yml` 里给这一行加上 `disabled: true`：

```yaml
- insert:
    - id: theme-wallpaper
      name: dsh-theme-wallpaper
      disabled: true
```

想**重新开启**，就把 `disabled: true` 删掉（或删掉整段）。每次改完都要重启 `npx @deepseek-ai/dsh web`。

### 卸载

**最简单 —— 运行一键卸载脚本：**

```bash
./uninstall.sh           # 默认 profile 是 web
./uninstall.sh myprofile # 指定别的 profile
```

它会自动删除插件目录、并从 `cordis.patch.yml` 里移除主题记录。然后重启 `npx @deepseek-ai/dsh web`。

**或手动删除：**

1. 删掉 `cordis.patch.yml` 里加的那段 `- insert: ...`（如果删完只剩注释，记得留一个 `[]`）。
2. 删除插件目录：

   ```bash
   rm -rf ~/.dsh/profiles/node_modules/dsh-theme-wallpaper
   ```

3. 重启 `npx @deepseek-ai/dsh web`。

### 文件说明

| 文件 | 说明 |
|---|---|
| `package.json` | 插件清单，声明 `dsh.client` |
| `lib/index.js` | 主机侧入口（无副作用） |
| `lib/client.js` | 客户端入口，注入背景与样式 |
| `install.command` / `install.bat` | 双击安装（macOS / Windows） |
| `uninstall.command` / `uninstall.bat` | 双击卸载（macOS / Windows） |
| `install.sh` / `uninstall.sh` | 终端安装 / 卸载脚本 |
| `install.cjs` / `uninstall.cjs` | 上面脚本共用的核心逻辑 |

### 常见问题

- **刷新没变化？** 强制刷新（`Cmd + Shift + R`），确认第 2 步 YAML 缩进正确、文件夹名是 `dsh-theme-wallpaper`。
- **重启报「找不到包」？** 确认插件在 `~/.dsh/profiles/node_modules/dsh-theme-wallpaper/`，里面有 `package.json`。

---

## License

MIT
