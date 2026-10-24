#!/bin/sh
# Install/refresh the Home redirect key filter on a webOS 4.x TV and apply it.
# Usage: deploy.sh <tv-host>          (e.g. deploy.sh 192.168.1.82)
# Revert: revert.sh <tv-host>
set -e
TV="$1"
[ -n "$TV" ] || { echo "usage: $0 <tv-host>" >&2; exit 2; }
HERE=$(cd "$(dirname "$0")" && pwd)
OUT=$(mktemp -d)

python3 -I "$HERE/build_payloads.py" "$OUT"

ssh "root@$TV" 'mkdir -p /var/lib/webosbrew/keyfilters /var/lib/webosbrew/home-redirect
  [ -f /var/lib/webosbrew/home-redirect/configd_factory_db.before.json ] ||
    cp /var/preferences/configd_factory_db.json /var/lib/webosbrew/home-redirect/configd_factory_db.before.json'
scp "$HERE/home-redirect.js" "root@$TV:/var/lib/webosbrew/keyfilters/"
scp "$OUT/set-apply.json" "$OUT/set-revert.json" "root@$TV:/var/lib/webosbrew/home-redirect/"

# luna-send prints nothing when run straight in an SSH session: run it detached and read a file.
# The compositor only re-reads the filter file when the config value changes, so revert then apply.
ssh "root@$TV" 'set_cfg() {
    nohup luna-send -n 1 -w 4000 luna://com.webos.service.config/setConfigs "$(cat "$1")" > /tmp/hr.log 2>&1 < /dev/null &
    sleep 2; cat /tmp/hr.log; rm -f /tmp/hr.log; echo; }
  set_cfg /var/lib/webosbrew/home-redirect/set-revert.json
  set_cfg /var/lib/webosbrew/home-redirect/set-apply.json'
