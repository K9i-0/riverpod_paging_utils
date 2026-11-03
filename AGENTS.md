# Riverpod Paging Utils

Flutter/Riverpod pagination package. `lib/src/paging_data.dart` contains Freezed models; notifier mixins manage page/offset/cursor state; helper views use visibility detection to request more data. `example/` is a Pub workspace member.

## Setup and verification

Use Flutter 3.47.9 from `.mise.toml` for development. Consumer minimums remain Dart 3.7 / Flutter 3.32; example tooling uses Dart 3.13.

From the repository root:

```sh
flutter pub get
dart run melos bootstrap
flutter analyze --fatal-infos
dart format --output=none --set-exit-if-changed .
flutter test
(cd example && flutter test)
```

After annotations or generator dependencies change, run `dart run melos run build --no-select` and review the generated diff. Do not hand-edit `.g.dart` or `.freezed.dart`. Use local `dart run melos`, not global Melos. CI checks regeneration and an independent consumer with the minimum Flutter/Riverpod versions. Before release preparation, use `dart pub publish --dry-run` on a clean commit.

Review pagination, refresh, first-page vs. load-more errors, and public API compatibility. Existing error demos deliberately fail again on Retry; expected error text is not a framework crash. Preserve existing semantics identifiers when adding keys.

## Working agreements

- Inspect git status and continue the task's existing branch/PR; preserve other work.
- Choose verification for the change. Repeat passed checks only after relevant changes, failures, or unresolved concerns. Documentation-only edits need link and command checks.
- Keep public API and consumer SDK compatibility. Example developer tools may need a newer SDK.
- Publishing and merging are separate requested operations. Record actual commands, SDK/device, outcomes, and limitations in the PR.

## AI runtime verification

Follow [doc/ai-verification.md](doc/ai-verification.md) for startup, connection, stable keys, and scenarios. Use `example/tool/automation.dart` for native debug inspection; ordinary `example/lib/main.dart` has no Marionette initialization.

Observe the live element list before acting. Prefer keys/identifiers, confirm visible outcomes, check runtime errors, and capture relevant screenshots. Widget tests alone do not establish simulator E2E. Stop only apps/processes started by this task; do not stop other dev servers or simulators.

`.mcp.json` and `.codex/config.toml` configure Dart MCP and Marionette. Start the agent with the intended Flutter/Dart SDK on PATH. See the guide for optional CLI fallback when MCP is unavailable.
