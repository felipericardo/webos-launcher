#!/bin/sh
# Remove the Home redirect: restore LG's filter chain live, restore configd's override file
# from the backup taken by deploy.sh, and reload configd.
# Usage: revert.sh <tv-host>
set -e
TV="$1"
[ -n "$TV" ] || { echo "usage: $0 <tv-host>" >&2; exit 2; }

ssh "root@$TV" 'D=/var/lib/webosbrew/home-redirect
  [ -f "$D/configd_factory_db.before.json" ] || { echo "no backup in $D, aborting" >&2; exit 1; }
  nohup luna-send -n 1 -w 4000 luna://com.webos.service.config/setConfigs "$(cat "$D/set-revert.json")" > /tmp/r1.log 2>&1 < /dev/null &
  sleep 2
  cp "$D/configd_factory_db.before.json" /var/preferences/configd_factory_db.json
  chmod 600 /var/preferences/configd_factory_db.json; sync
  nohup luna-send -n 1 -w 8000 luna://com.webos.service.config/reloadConfigs "{}" > /tmp/r2.log 2>&1 < /dev/null &
  sleep 4
  echo "setConfigs: $(cat /tmp/r1.log)"; echo "reloadConfigs: $(cat /tmp/r2.log)"
  rm -f /tmp/r1.log /tmp/r2.log /var/lib/webosbrew/keyfilters/home-redirect.js'
