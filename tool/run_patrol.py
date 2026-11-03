#!/usr/bin/env python3
"""Run Patrol and require a fresh, completely passing native result bundle."""
import json
from pathlib import Path
import subprocess
import sys
import time

APP = Path(__file__).resolve().parent.parent / 'example'
PLATFORM = 'ios'


def verify_summary(summary, started_at):
    total = summary.get("totalTestCount", 0)
    if summary.get("startTime", 0) < started_at:
        raise ValueError("Result bundle predates this Patrol invocation")
    if (
        summary.get("result") != "Passed"
        or total < 1
        or summary.get("passedTests") != total
        or summary.get("failedTests", 0) != 0
        or summary.get("skippedTests", 0) != 0
        or summary.get("expectedFailures", 0) != 0
    ):
        raise ValueError("All Patrol tests must pass, with no skips or expected failures")
    return total


def main():
    started_at = time.time()
    subprocess.run(
        ["dart", "run", "patrol_cli:main", "test", *sys.argv[1:]],
        cwd=APP,
        check=True,
    )
    bundles = list((APP / "build").glob(PLATFORM + "_results_*.xcresult"))
    if not bundles:
        raise ValueError("Patrol produced no native result bundle")
    bundle = max(bundles, key=lambda candidate: candidate.stat().st_mtime)
    output = subprocess.check_output(
        ["xcrun", "xcresulttool", "get", "test-results", "summary", "--path", str(bundle)],
        text=True,
    )
    total = verify_summary(json.loads(output), started_at)
    print(f"Release gate passed: {total} Patrol tests, 0 failures, 0 skips. {bundle}")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        sys.exit(str(error))
