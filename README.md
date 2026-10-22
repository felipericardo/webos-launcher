# my-webos-launcher

Custom home launcher for rooted LG webOS TVs (homelab personal project).

Shared UI across both TVs; only the Home-button takeover and boot-autostart
mechanism differs per webOS generation (see `platform/`).

## TVs targeted

- Suíte 1 — LG 65UN7100PSA, webOS 5.6.2
- Sala — LG 65UK6530PSF, webOS 4.0~4.4

Both are rooted (Homebrew Channel) via the procedure in
`ops/runbooks/root-lg-webos-tv.md`. See `ops/inventory/homelab.md` for details
(the `ops` repo is this project's context hub, not this repo).

## Layout

- `app/` — the launcher UI itself (HTML/CSS/JS), shared between both TVs.
  Written conservatively (no CSS Grid/`gap`/`inset`) to run on both the older
  Chrome 53 engine (webOS 4.x) and the newer one (webOS 5.x+).
- `platform/webos4-input-hook/` — LG Input Hook config to remap the physical
  Home key to this app (webOS 4.x; the official `defaultApps.home` setting
  doesn't take effect on this generation).
- `platform/webos5-homehook/` — foreground-app-watching helper + Homebrew
  `init.d` boot hook (webOS 5.x+).
- `scripts/` — build, `.ipk` packaging, SSH deploy to the TVs.

## Status

Not started yet — currently evaluating existing community launchers
(Mr-Neutr0n/webos-home, rudra-avatar/webos-custom-launcher) before writing
this from scratch.
