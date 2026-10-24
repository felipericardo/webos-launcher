# webos-home-redirect

System pieces that make the Home key on rooted LG webOS TVs open a launcher app of your
choice instead of the native Home. The launcher itself lives in
[tv-launcher](https://github.com/felipericardo/tv-launcher). Renamed from `webos-launcher` on
2026-10-24.

## TVs targeted

- LG 65UK6530PSF, webOS 4.0~4.4 (done)
- LG 65UN7100PSA, webOS 5.6.2 (not written yet)

## Layout

- `platform/webos4-keyfilter/` — webOS 4.x: makes Home (and Back where it would open Home)
  open the launcher, from the first press after boot.
  - `home-redirect.js` — the filter (`TARGET_APP` = app to open).
  - `lg-keyfilters.json` — LG's original filter chain, used to build both payloads.
  - `deploy.sh <tv-host>` / `revert.sh <tv-host>` — apply / remove it.
- `platform/webos5-homehook/` — webOS 5.x: not written yet.

Packaging and TV install helpers: [webos-tools](https://github.com/felipericardo/webos-tools).

## How the webOS 4.x Home redirect works

webOS 4.x has no `defaultApps.home` setting: the native Home ribbon is QML built into the
compositor (`surface-manager-starfish`). How it handles keys:

- **Configurable filter chain.** Keys go through a chain of JavaScript filters listed in the
  configd setting `com.webos.surfacemanager.keyFilters`. The compositor subscribes to that
  setting and reloads the chain live.
- **Persistent.** configd `setConfigs` stores overrides in
  `/var/preferences/configd_factory_db.json`, read before the compositor starts.

`deploy.sh` puts `home-redirect.js` first in that chain:

- Home opens `TARGET_APP` and consumes the key.
- Back opens it only where the system would have opened Home.
- Modal alerts, first-use setup and restricted modes stay with the system, and any error falls
  back to native behaviour.

No firmware file is changed. `revert.sh` restores the original configd file from the backup
`deploy.sh` takes.

Requires root (Homebrew Channel) and SSH as root. Tested on LG 65UK6530PSF, firmware 05.50.70.
Use at your own risk.

## License

MIT, see [LICENSE](LICENSE).
