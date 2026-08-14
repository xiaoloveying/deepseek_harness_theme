/**
 * dsh-theme-wallpaper — host half.
 *
 * Injects a tiny script right after <body> that forces dark mode, so the dark
 * wallpaper theme shows immediately (no light-mode flash). The client bundle
 * (lib/client.js) also forces dark and injects the wallpaper CSS.
 */
function forceDarkScript() {
  return "<script>(() => { document.documentElement.style.colorScheme = 'dark'; document.body.toggleAttribute('data-ds-dark-theme', true); })()<\/script>";
}

function injectForceDark(html) {
  const script = forceDarkScript();
  const body = /<body(?:\s[^>]*)?>/i.exec(html);
  if (body === null) return `${html}${script}`;
  const at = body.index + body[0].length;
  return `${html.slice(0, at)}${script}${html.slice(at)}`;
}

export function apply(ctx) {
  ctx.inject(["webServer"], (httpCtx) => {
    httpCtx.effect(() => httpCtx.webServer.tapIndex((html) => injectForceDark(html)), "dsh-theme-wallpaper: force dark theme");
  });
}
