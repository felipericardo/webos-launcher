"""Build the configd setConfigs payloads for the webOS 4.x Home redirect.

Writes into <out-dir>:
  set-apply.json   our filter first, then LG's original filters
  set-revert.json  LG's original filters only

Usage: build_payloads.py <out-dir>
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
FILTER = {"file": "/var/lib/webosbrew/keyfilters/home-redirect.js", "handler": "handleHomeRedirect"}
KEY = "com.webos.surfacemanager.keyFilters"


def write(path, filters):
    with open(path, "w") as fh:
        json.dump({"configs": {KEY: filters}}, fh, separators=(",", ":"))


def main():
    out = sys.argv[1]
    os.makedirs(out, exist_ok=True)
    with open(os.path.join(HERE, "lg-keyfilters.json")) as fh:
        lg = json.load(fh)
    write(os.path.join(out, "set-apply.json"), [FILTER] + lg)
    write(os.path.join(out, "set-revert.json"), lg)
    print(f"{out}: set-apply.json ({len(lg) + 1} filters), set-revert.json ({len(lg)} filters)")


if __name__ == "__main__":
    main()
