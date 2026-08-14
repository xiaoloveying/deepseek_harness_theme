# DeepSeek Harness 壁纸主题插件 · Wallpaper Theme Plugin

给 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) 换上一张壁纸背景 + 半透明面板的主题插件。
A client-side theme plugin that gives DeepSeek Harness a wallpaper background and semi-transparent panels.

| | 中文 | English |
|---|---|---|
| 效果 | 壁纸铺满整页，面板半透明，壁纸透出来 | Full-page wallpaper with translucent panels |
| 主题 | 浅色 / 深色都适配 | Both light & dark themes supported |
| 实现 | 纯客户端插件，不碰主机数据，安全可卸载 | Pure client plugin — no host changes, safe to remove |

---

## 效果 / Features

- 整页壁纸背景（居中、铺满、固定不随滚动）Full-page wallpaper background (cover, centered, fixed)
- 主要区域半透明遮罩，文字清晰 Semi-transparent mask on the main area for text readability
- 左侧侧边栏半透明 Semi-transparent sidebar
- 浅色 / 深色两套主题自动切换 Auto-switches between light and dark themes

---

## 前置条件 / Requirements

- 已经装好并会启动 DeepSeek Harness（`dsh web`）
- Already have DeepSeek Harness installed and running via `dsh web`
- 不需要 Node 之外的任何东西（插件自包含，背景图已内嵌）
- Nothing extra required — the plugin is self-contained (the background image is embedded)

---

## 安装 / Installation

### 第 1 步 · 下载插件 / Step 1 · Download the plugin

任选一种方式 / Pick one:

**方式 A · 用 git 克隆（推荐）/ Method A · Clone with git (recommended):**

```bash
git clone https://github.com/xiaoloveying/deepseek_harness_theme \
  ~/.dsh/profiles/node_modules/dsh-theme-wallpaper
```

**方式 B · 下载 ZIP / Method B · Download ZIP:**

1. 点击本仓库右上角 **Code → Download ZIP**，解压。
   Download the ZIP (Code → Download ZIP) and unzip it.
2. 把解压出来的整个文件夹复制到 `~/.dsh/profiles/node_modules/` 下，并**改名为 `dsh-theme-wallpaper`**。
   Copy the unzipped folder into `~/.dsh/profiles/node_modules/` and rename it to `dsh-theme-wallpaper`.

> 如果你的 Harness 用户目录不是 `~/.dsh`（设置了 `DSH_HOME`），把上面的路径换成你的实际路径。
> If your Harness home is not `~/.dsh` (you set `DSH_HOME`), use your actual path instead.

### 第 2 步 · 注册插件 / Step 2 · Register the plugin

编辑 `~/.dsh/profiles/web/cordis.patch.yml`（如果你用的是别的 profile，改成对应名字）。
Edit `~/.dsh/profiles/web/cordis.patch.yml` (change `web` to your profile name if different).

如果文件内容还是空的 `[]`，改成：
If the file is still the empty `[]`, make it:

```yaml
- insert:
    - id: theme-wallpaper
      name: dsh-theme-wallpaper
```

如果文件里已经有内容，就在**末尾追加**上面这段（注意保持 YAML 缩进一致）。
If the file already has content, append the block above to the end (keep YAML indentation consistent).

### 第 3 步 · 重启 / Step 3 · Restart

```bash
dsh web
```

然后打开页面，**强制刷新**：`Cmd + Shift + R`（Windows / Linux 用 `Ctrl + Shift + R`）。
Then hard-refresh the page: `Cmd + Shift + R` (`Ctrl + Shift + R` on Windows/Linux).

---

## 一键安装脚本 / One-command installer

如果你已经把插件下载到了本地，也可以直接运行：
If you've already downloaded the plugin locally, you can also run:

```bash
./install.sh          # 默认 profile 是 web / defaults to profile "web"
./install.sh myprofile  # 指定别的 profile / use a different profile
```

脚本会自动复制插件并写入 `cordis.patch.yml`，然后你只需重启 `dsh web`。
The script copies the plugin and writes `cordis.patch.yml` for you; then just restart `dsh web`.

---

## 卸载 / Uninstall

1. 删掉 `~/.dsh/profiles/web/cordis.patch.yml` 里加的那段 `- insert: ...`。
   Remove the `- insert: ...` block you added in `cordis.patch.yml`.
2. 删除插件目录：
   ```bash
   rm -rf ~/.dsh/profiles/node_modules/dsh-theme-wallpaper
   ```
3. 重启 `dsh web`。Restart `dsh web`.

---

## 自定义 / Customization

所有样式都在 `lib/client.js` 里。All styles live in `lib/client.js`.

### 换背景图 / Change the wallpaper

把 `var BG = "data:image/jpeg;base64,..."` 里的 base64 换成你自己的图：
Replace the base64 in `var BG = "data:image/jpeg;base64,..."` with your own image:

```bash
base64 -i 你的图片.jpg | tr -d '\n'
# 把输出拼到 "data:image/jpeg;base64," 后面
# append the output after "data:image/jpeg;base64,"
```

### 调整面板透明度 / Tune panel opacity

在 CSS 里找到这些变量并改最后一个数字（0 ~ 1，越大越实）：
Find these variables in the CSS and change the last number (0–1; higher = more solid):

| 变量 / Variable | 作用 / What it controls |
|---|---|
| `--dsw-alias-bg-base` | 主要区域遮罩 Main-area mask |
| `--dsw-specific-sidebar-fill` | 侧边栏 Sidebar |
| `--dsw-alias-button-elevated-fill` | 「新会话」按钮 New-session button |
| `--dsw-specific-input-major` | 输入框 Input/composer box |
| `--dsw-alias-bg-layer-1/2/3` | 卡片、弹窗等层级 Panels, dialogs, etc. |

改完重启 `dsh web` 生效。Restart `dsh web` to apply.

---

## 文件说明 / Files

| 文件 / File | 说明 / Description |
|---|---|
| `package.json` | 插件清单，声明 `dsh.client`（客户端插件）Plugin manifest declaring `dsh.client` |
| `lib/index.js` | 主机侧入口（无副作用）Host-side entry (no-op) |
| `lib/client.js` | 客户端入口，注入背景与样式 Client entry — injects background + styles |
| `install.sh` | 一键安装脚本 One-command installer |

---

## 常见问题 / Troubleshooting

- **刷新后没变化？** 用强制刷新 `Cmd + Shift + R`，并确认第 2 步的 YAML 缩进正确、插件目录名是 `dsh-theme-wallpaper`。
  **No change after refresh?** Hard-refresh (`Cmd + Shift + R`), check the YAML indentation in step 2, and make sure the folder is named `dsh-theme-wallpaper`.
- **重启时报错找不到包？** 确认插件在 `~/.dsh/profiles/node_modules/dsh-theme-wallpaper/` 下，并且里面有 `package.json`。
  **"Cannot find package" on restart?** Confirm the plugin is at `~/.dsh/profiles/node_modules/dsh-theme-wallpaper/` with a `package.json` inside.

---

## License

MIT
