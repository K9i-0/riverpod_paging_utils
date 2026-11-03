# AI verification of the example

For repeatable regressions and the required release gate, use [Patrol](patrol.md).
This guide covers exploratory runtime inspection.

Use this guide with [AGENTS.md](../AGENTS.md). Run
`example/tool/automation.dart` for native **debug-only** Marionette inspection,
log collection, and session reports. It starts the ordinary demo from
`example/lib/main.dart`; that ordinary entrypoint does not initialize Marionette.
Web/profile/release runs do not expose the automation extensions.

Use Flutter **3.47.9** from `.mise.toml`. The unpublished example uses Dart 3.13
tooling; the published library's Dart 3.7 / Flutter 3.32 minimums are unchanged.
Marionette remains an example development dependency.

## Setup

Start the agent with the selected Flutter SDK's `bin` directory on PATH, so
`flutter`, `dart`, Dart MCP, and globally activated Dart tools use the same SDK.
The Dart global executable directory must also be on PATH. Check
`flutter --version` and `dart --version` before starting.

From the repository root:

```sh
flutter pub get
dart run melos bootstrap
dart pub global activate marionette_mcp 0.7.0
```

Root and example resolve as a Pub workspace. If annotations or generator
dependencies changed, regenerate with `dart run melos run build --no-select`.
Do not edit generated files manually.

`.mcp.json` and `.codex/config.toml` define the `dart-mcp` and `marionette` servers
for Claude Code and Codex respectively. Dart MCP uses
`dart mcp-server --enable flutter_app_lifecycle` to expose device discovery and
app lifecycle tools; verify their presence in the current tool list before use.
Project MCP configuration in Codex is
loaded for trusted projects; see the
[official MCP documentation](https://learn.chatgpt.com/codex/extend/mcp).
Reload the agent after changing PATH/configuration and inspect its available
tools. If a global tool reports an invalid SDK hash, reactivate its pinned version
using the selected SDK.

## Start and connect with MCP

1. Use Dart MCP `list_devices` or `flutter devices` to discover an available
   native target supported by `example/`. Choose a booted iOS simulator or Android
   emulator as appropriate; do not hard-code a machine-specific ID.
2. Call Dart MCP `launch_app` with the `example/` directory's file URI as `root`
   (for example `file:///absolute/path/to/checkout/example`),
   `target: "tool/automation.dart"`, and the discovered `device` ID. The directory
   must be inside a root allowed by the MCP client. Retain the returned process ID.
3. Read `get_app_logs` for that process until startup completes. Extract the
   current `wsUri` from the `app.debugPort` event.
4. Call Marionette `connect` with that URI, then `get_interactive_elements`.
   Confirm `Sample Screen` and, once loading completes, `sample-list`.

The launch result's `dtdUri` connects Dart Tooling Daemon tools; it is not the
VM-service URI that Marionette expects.

On every new screen and after a gesture, inspect the live elements before the
next action. Prefer a returned key, then semantics identifier, then text.
Scroll an off-screen target into view and observe again. Names are randomly
generated: verify numeric item IDs, stable keys, and screen titles instead.
The ordinary repository delay is 500 ms; poll for the expected visible state
with a bounded timeout rather than assuming a single short wait is sufficient.

## Scenarios and expected outcomes

Open the drawer with `drawer-menu-button`. Its list has key `drawer-menu-list`;
scroll that list if a menu entry is off-screen. Each destination has a
`back-button`; returning must show `Sample Screen` with the drawer closed.

| Scenario and navigation key | What to inspect or operate | Expected outcome |
| --- | --- | --- |
| Main cursor list | `sample-list`; item keys `1`, then `31` | First data loads, scrolling to the end loads another page, and item `31` becomes visible. |
| First-page error: `menu-first-page-error` | Title `1st Page Error Sample`; identifier `error-view`; `retry-button` | `Error: Exception: Error fetching data` appears. Retry shows loading, then the same deliberate error returns. |
| Later-page error: `menu-second-page-error` | `second-page-error-list`; item `item-0`; `error-retry-button` | The five initial items remain visible while the next page fails. Retry attempts loading and returns to the same error without clearing those items. |
| Error display toggle on that screen | `show-second-page-error-switch` | Off hides the inline error/retry UI and preserves the items; on restores the inline error UI. |
| Paging modes: `menu-paging-method` | `page-tab`, `offset-tab`, `cursor-tab` | Each tab loads data and another page on scroll. First next-page IDs are `11`, `16`, and `31` respectively. |
| Argument passing: `menu-passing-args` | Title `Passing Args Sample`; `passing-args-list` | Data loads, and scrolling loads beyond the initial 30 items. |
| Grid: `menu-grid-view` | `sample-grid`; `grid-scroll-direction-button`; item keys such as `grid-item-1` | Data loads. The toggle changes vertical scrolling to horizontal scrolling; use an upward or leftward swipe as appropriate. |
| Slivers: `menu-custom-scroll-view` | `sample-custom-scroll-view`; item keys such as `sliver-item-1` | The header and list coexist, further pages load on scroll, and pulling down at the top refreshes without a framework error. |

The paging-mode lists use `PageStorageKey<String>` values `page`, `offset`, and
`cursor`. Select the visible tab first and use the live listing to scope a swipe;
the same numeric item key can exist in more than one tab. Existing semantics
identifiers such as `page-item-0` use a zero-based index, while item key `1`
represents item ID 1. Do not confuse the two.

First-page and later-page failures are intentional fixtures: Retry is expected
to fail again. Successful retry feedback does not mean recovery to normal data.
Inspect runtime errors separately from the expected on-screen exception text.

## CLI fallback

The official [Marionette CLI](https://marionette.leancode.co/docs/drive/) offers
the same runtime actions when MCP tools are unavailable in the current session:

```sh
dart pub global activate marionette_cli 0.7.0
marionette help-ai
```

Launch in a retained terminal/session, replacing the device placeholder:

```sh
cd example
flutter run --machine -d '<device-id>' -t tool/automation.dart
```

Read that run's `app.debugPort.wsUri`. In another terminal at the repository root:

```sh
EXAMPLE_VM_URI='<wsUri from app.debugPort>'
mkdir -p artifacts
marionette --uri "$EXAMPLE_VM_URI" get-interactive-elements
marionette --uri "$EXAMPLE_VM_URI" swipe --key sample-list --direction up --distance 500
marionette --uri "$EXAMPLE_VM_URI" get-interactive-elements
```

Read CLI startup errors in the original terminal. Dart MCP `get_app_logs` only
collects processes started by its own `launch_app` tool.

Continue bounded, observed swipes until item `31` is visible. To navigate:

```sh
marionette --uri "$EXAMPLE_VM_URI" tap --key drawer-menu-button
marionette --uri "$EXAMPLE_VM_URI" get-interactive-elements
marionette --uri "$EXAMPLE_VM_URI" tap --key menu-first-page-error
marionette --uri "$EXAMPLE_VM_URI" get-interactive-elements
```

Wait for the error UI, then inspect the result of `tap --key retry-button`.
Collect logs and relevant visual evidence:

```sh
marionette --uri "$EXAMPLE_VM_URI" get-logs
marionette --uri "$EXAMPLE_VM_URI" take-screenshots --output artifacts/first-page-error.png
```

Use `marionette <command> --help` for installed options. If the default connection
timeout is insufficient, add global `--timeout 20` before the command; investigate
a missing app or incorrect URI rather than repeatedly retrying.

## Tests, evidence, and cleanup

Fast example regression checks live in
[`example/test/app_smoke_test.dart`](../example/test/app_smoke_test.dart):

```sh
(cd example && flutter test)
```

Use bounded `pump` calls during asynchronous loading and active spinners;
`pumpAndSettle` cannot settle an indeterminate animation. The tests also control
visibility-detector timing. Follow that pattern for pagination tests and dispose
the widget tree at teardown. Widget tests do not establish native launch or
runtime-automation success.

Existing [Maestro flows](../example/.maestro/) remain available. This guide adds
MCP/CLI inspection alongside them; it does not make those flows redundant or
claim they passed. Preserve their semantics identifiers when editing the example.

Read Marionette `get_logs` plus the launch logs and, when connected, Dart MCP
runtime-error inspection. Confirm screen outcomes and take relevant screenshots
for layout or error-state changes. An empty screenshot result is a limitation,
not visual verification. Keep captures and session reports in ignored
`artifacts/` and `.marionette/` directories. Record the SDK/device, entrypoint,
scenario results, and unverified areas; do not commit authenticated VM-service URIs.

Disconnect Marionette, then call Dart MCP `stop_app` with the saved process ID.
For a CLI launch, interrupt its original terminal/session. Stop only processes
started for this task, leaving other Flutter sessions and simulators alone.
Keep the preview running only when continued access is requested.
