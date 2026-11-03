# Patrol regression checks

Use the saved `example/patrol_test/` suite as the release gate. Tests exercise the
ordinary example with Patrol's test binding; do not run the Marionette automation
entrypoint inside Patrol. Existing widget tests provide quicker feedback and
Marionette remains useful for exploratory inspection.

## Run the suite

Use the repository's pinned Flutter SDK and resolve dependencies first. Patrol,
Patrol CLI, and Patrol MCP are pinned in the example's dev dependencies; there is
no global CLI version to drift from the project. Run from the repository root:

```sh
PATROL_DEVICE=<ios-simulator-id> bash tool/patrol_ios.sh
```

Select a simulator ID from `flutter devices`; boot an available iPhone simulator
if needed. Auto-selection is CI-only; an explicitly selected simulator is booted if needed. Additional
Patrol options can be passed after the command. For parallel local sessions use
distinct `--test-server-port` and `--app-server-port` values.

CI uses macOS 26, Xcode 26.2, and an iPhone 17 with iOS 26.2. Its job sets
`DEVELOPER_DIR`, `PATROL_IOS_VERSION`, and `PATROL_DEVICE_NAME` explicitly so
runner image updates do not silently mix an older Xcode with a newer simulator.
The helper prints the selected Xcode, runtime, model, and simulator ID. Locally,
`PATROL_DEVICE` alone still detects that simulator's runtime; the version and
model variables are optional exact filters. A filter with no match fails before
starting Patrol.

Simulator boot has a 600-second limit. A timeout fails the gate and prints device
and runtime diagnostics; it does not erase or restart the simulator. Boot output
is also saved in `example/build/patrol_logs/simulator-boot.log` and uploaded with
CI diagnostics. Allow normal first-boot migration to complete before concluding
that boot has stalled.

Require a zero exit code and check the reported case count: no failed or skipped
cases. A successful compile or app launch is not a passing E2E run. Patrol writes
native result bundles under the example's `build/` directory; CI uploads them as
`patrol-results` when available. Inspect failures before retrying and fix causes
rather than adding unconditional sleeps or disabling assertions. Do not mutate
the application's global error handler inside a test to hide failures.

The generated `patrol_test/test_bundle.dart` and `.patrol.env` are ignored.
Formatting uses Git's tracked and non-ignored files so generated runner files do
not break ordinary checks.

## Patrol MCP

The project-local `.mcp.json` and `.codex/config.toml` start
`sh tool/patrol_mcp.sh`. The wrapper runs `dart run patrol_mcp` in the example,
sets `PROJECT_ROOT` to that app, and keeps terminal spawning off. Start the agent
with the pinned Dart/Flutter SDK on PATH and reload its MCP configuration.
No global `patrol_mcp` installation is needed.

Use `devices`/`status`, then `run` for a saved test file and an explicit device.
Do not let device auto-selection choose a connected personal phone. Read the
run result and logs, inspect screenshots/native trees when supported, and use
`quit` for sessions you started. On macOS use the CLI if the current MCP device
picker does not support that target. MCP-assisted exploration does not replace
the committed suite or change release criteria.

## Release requirement

The tag workflow reuses the CI workflow and requires its Patrol job to succeed
for the exact tagged commit before obtaining publish credentials. Never use
`continue-on-error`, skipped cases, or a manual publish to bypass a failed gate.
Main pushes run validation only; a release requires an explicitly requested tag.

References: [Patrol](https://pub.dev/packages/patrol),
[Patrol MCP](https://pub.dev/packages/patrol_mcp), and the
[official platform setup](https://patrol.leancode.co/documentation).
