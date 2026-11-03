# Riverpod Paging Utils

Flutter/Riverpod pagination package. `lib/src/paging_data.dart` contains Freezed models; notifier mixins manage page/offset/cursor state; helper views use visibility detection to request more data. `example/` is a Pub workspace member.

## Setup and verification

Use Flutter 3.47.9 from `.mise.toml` for development. Consumer minimums remain Dart 3.7 / Flutter 3.32; example tooling uses Dart 3.13.

From the repository root:

```sh
flutter pub get
dart run melos bootstrap
flutter analyze --fatal-infos
sh tool/check_format.sh
flutter test
(cd example && flutter test)
```

After annotations or generator dependencies change, run `dart run melos run build --no-select` and review the generated diff. Do not hand-edit `.g.dart` or `.freezed.dart`. Use local `dart run melos`, not global Melos. CI checks regeneration and an independent consumer with the minimum Flutter/Riverpod versions. Before release preparation, use `dart pub publish --dry-run` on a clean commit.

Review pagination, refresh, first-page vs. load-more errors, and public API compatibility. Existing error demos deliberately fail again on Retry; expected error text is not a framework crash. Preserve existing semantics identifiers when adding keys.

## Working agreements

- Maintainers work and commit directly on `main`, then push without a separate PR. Preserve unrelated local work. Pull requests are for outside contributions and dependency bots.
- Use Conventional Commits. A `main` push runs checks and does not publish.
- Publish only when a release is requested, by pushing `<package>-v<version>` after all release checks pass. Follow [doc/releasing.md](doc/releasing.md); do not run a manual publish command.
- Choose verification for the change. Repeat passed checks only after relevant changes, failures, or unresolved concerns. Documentation-only edits need link and command checks.
- Keep public API and consumer SDK compatibility. Example developer tools may need a newer SDK.
- Record actual verification commands, SDK/device, outcomes, and limitations. Release tags are separate from a maintenance request.

## AI runtime verification

Follow [doc/ai-verification.md](doc/ai-verification.md) for startup, connection, stable keys, and scenarios. Use `example/tool/automation.dart` for native debug inspection; ordinary `example/lib/main.dart` has no Marionette initialization.

Observe the live element list before acting. Prefer keys/identifiers, confirm visible outcomes, check runtime errors, and capture relevant screenshots. Widget tests alone do not establish simulator E2E. Stop only apps/processes started by this task; do not stop other dev servers or simulators.

`.mcp.json` and `.codex/config.toml` configure Dart MCP and Marionette. Start the agent with the intended Flutter/Dart SDK on PATH. See the guide for optional CLI fallback when MCP is unavailable.

## Regression and release gate

The maintained regression suite is `example/patrol_test/`. Before a release,
run `PATROL_DEVICE=<ios-simulator-id> bash tool/patrol_ios.sh` and require every
Patrol case to pass. CI repeats the suite on the exact tagged commit before
publishing. Widget tests and manual Marionette checks do not replace this gate.
Patrol MCP runs the saved tests during development; keep exploratory Marionette
inspection available for debugging. See [doc/patrol.md](doc/patrol.md).
