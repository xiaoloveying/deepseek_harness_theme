/**
 * dsh-theme-wallpaper — host half.
 *
 * This plugin contributes nothing on the host side: the entire effect lives in
 * the client bundle (lib/client.js), which injects the wallpaper CSS. The host
 * entry exists only so the plugin can be composed as an ordinary Cordis row and
 * have its client bundle discovered/served.
 */
export function apply() {}
