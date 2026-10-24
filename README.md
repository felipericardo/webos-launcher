# webos-launcher

Custom home launcher for the rooted LG webOS TVs (homelab personal project), plus the
platform pieces that make the Home key open it.

Context, decisions and procedures live in the `ops` repo (vault): project note
`ops/projects/launcher-casa.md`, ADR-0007, runbook `ops/runbooks/webos4-home-redirect-key-filter.md`.

## TVs targeted

- Suíte 1 — LG 65UN7100PSA, webOS 5.6.2
- Sala — LG 65UK6530PSF, webOS 4.0~4.4

## Layout

- `app/` — the launcher UI (not started). Until it exists, both TVs run the community
  launcher rudra-avatar/webos-custom-launcher (`tld.my.customlauncher`) as a stand-in.
- `platform/webos4-keyfilter/` — Sala (webOS 4.x): a compositor key filter, set through
  configd `setConfigs`, that makes Home (and Back where it would open Home) open the
  launcher from the first press after boot.
  - `home-redirect.js` — the filter (`TARGET_APP` = app to open).
  - `lg-keyfilters.json` — LG's original filter chain, used to build both payloads.
  - `deploy.sh <tv-host>` / `revert.sh <tv-host>` — apply / remove it.
- `platform/webos5-homehook/` — Suíte 1 (webOS 5.x): not written yet.

Packaging and TV deploy helpers: the `webos-tools` repo.
