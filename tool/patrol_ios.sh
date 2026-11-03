#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../example"
flutter pub get
if [[ -z "${PATROL_DEVICE:-}" && "${CI:-}" != "true" ]]; then
  echo "Set PATROL_DEVICE to an iOS simulator ID from flutter devices." >&2
  exit 1
fi
export PATROL_DEVICE="${PATROL_DEVICE:-}"
selection="$(xcrun simctl list devices available --json | python3 -c '
import json, os, re, sys
requested = os.environ["PATROL_DEVICE"]
candidates = []
for runtime, devices in json.load(sys.stdin)["devices"].items():
    match = re.search(r"iOS-([0-9-]+)$", runtime)
    if not match:
        continue
    version = tuple(int(part) for part in match.group(1).split("-"))
    for device in devices:
        if not device.get("isAvailable", True):
            continue
        if requested and device["udid"] != requested:
            continue
        if not requested and not device["name"].startswith("iPhone"):
            continue
        candidates.append((version, device["state"] == "Booted", device["udid"]))
if not candidates:
    sys.exit("No matching available iOS simulator")
version, _, udid = max(candidates)
print(udid + "|" + ".".join(map(str, version)))
')"
IFS='|' read -r PATROL_DEVICE PATROL_IOS_VERSION <<< "$selection"
# -b boots only when needed, so already-booted CI simulators also work.
xcrun simctl bootstatus "$PATROL_DEVICE" -b
exec python3 ../tool/run_patrol.py --device "$PATROL_DEVICE" --ios "$PATROL_IOS_VERSION" "$@"
