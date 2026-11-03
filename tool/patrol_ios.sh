#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../example"
flutter pub get
if [[ -z "${PATROL_DEVICE:-}" && "${CI:-}" != "true" ]]; then
  echo "Set PATROL_DEVICE to an iOS simulator ID from flutter devices." >&2
  exit 1
fi
export PATROL_DEVICE="${PATROL_DEVICE:-}"
export PATROL_IOS_VERSION="${PATROL_IOS_VERSION:-}"
export PATROL_DEVICE_NAME="${PATROL_DEVICE_NAME:-}"
selection="$(xcrun simctl list devices available --json | python3 -c '
import json, os, re, sys
requested = os.environ["PATROL_DEVICE"]
requested_version = os.environ["PATROL_IOS_VERSION"]
requested_name = os.environ["PATROL_DEVICE_NAME"]
if requested_version and not re.fullmatch(r"[0-9]+(?:\.[0-9]+){0,2}", requested_version):
    sys.exit("PATROL_IOS_VERSION must be an iOS version such as 26.2")

def normalized(version):
    return version + (0,) * (3 - len(version))

version_filter = (
    normalized(tuple(map(int, requested_version.split("."))))
    if requested_version else None
)
candidates = []
for runtime, devices in json.load(sys.stdin)["devices"].items():
    match = re.search(r"iOS-([0-9-]+)$", runtime)
    if not match:
        continue
    version = tuple(int(part) for part in match.group(1).split("-"))
    if version_filter is not None and normalized(version) != version_filter:
        continue
    for device in devices:
        if not device.get("isAvailable", True):
            continue
        if requested and device["udid"] != requested:
            continue
        if requested_name and device["name"] != requested_name:
            continue
        if not requested and not device["name"].startswith("iPhone"):
            continue
        candidates.append((version, device["state"] == "Booted", device["udid"], device["name"]))
if not candidates:
    sys.exit(
        "No matching available iOS simulator "
        f"(device={requested!r}, runtime={requested_version!r}, model={requested_name!r})"
    )
version, _, udid, name = max(candidates)
print(udid + "|" + ".".join(map(str, version)) + "|" + name)
')"
IFS='|' read -r PATROL_DEVICE PATROL_IOS_VERSION PATROL_DEVICE_NAME <<< "$selection"
xcodebuild -version
printf 'Patrol simulator: %s (%s), iOS %s\n' "$PATROL_DEVICE_NAME" "$PATROL_DEVICE" "$PATROL_IOS_VERSION"
# -b boots only when needed, so already-booted CI simulators also work.
mkdir -p build/patrol_logs
python3 - "$PATROL_DEVICE" <<'PY' 2>&1 | tee build/patrol_logs/simulator-boot.log
import subprocess
import sys

device = sys.argv[1]
try:
    subprocess.run(
        ["xcrun", "simctl", "bootstatus", device, "-b"],
        check=True,
        timeout=600,
    )
except subprocess.TimeoutExpired:
    print(f"Simulator {device} did not finish booting within 600 seconds.", flush=True)
    print("Patrol tests were not started. Simulator diagnostics:", flush=True)
    for category in ("devices", "runtimes"):
        try:
            subprocess.run(
                ["xcrun", "simctl", "list", category, "available"],
                timeout=15,
                check=False,
            )
        except (subprocess.TimeoutExpired, OSError) as error:
            print(f"Could not collect {category}: {error}", flush=True)
    sys.exit(1)
except subprocess.CalledProcessError as error:
    sys.exit(error.returncode)
PY
exec python3 ../tool/run_patrol.py --device "$PATROL_DEVICE" --ios "$PATROL_IOS_VERSION" "$@"
