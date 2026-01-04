# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Riverpod Paging Utils

A Flutter package that provides utilities for implementing pagination with Riverpod.

## Development Commands

### Building and Testing
```bash
# Run all tests
flutter test

# Run a single test file
flutter test test/paging_helper_view_test.dart

# Run tests with coverage
flutter test --coverage

# Code generation (required after modifying files with freezed or riverpod annotations)
melos run build

# Watch mode for code generation
melos run watch

# Update dependencies using melos
melos bs

# Run linter
dart analyze

# Format code
dart format .
```

### Example App
```bash
# Run the example app
cd example
flutter run

# Generate code for example app
cd example
dart run build_runner build --delete-conflicting-outputs
```

## Architecture Overview

### Core Components

1. **PagingData Models** (`lib/src/paging_data.dart`)
   - `PagePagingData`: Page number-based pagination
   - `OffsetPagingData`: Offset/limit-based pagination  
   - `CursorPagingData`: Cursor-based pagination
   - All models use Freezed for immutability and include `items`, `hasMore`, and pagination-specific fields

2. **Notifier Mixins** (`lib/src/paging_notifier_mixin.dart`)
   - `PagingNotifierMixin<D, I>`: Base mixin with common logic
   - `PagePagingNotifierMixin`: Page-based implementation
   - `OffsetPagingNotifierMixin`: Offset-based implementation
   - `CursorPagingNotifierMixin`: Cursor-based implementation
   - Handles loading states, error recovery, and automatic pagination

3. **View Widgets**
   - `PagingHelperView`: Main widget for regular scrollable views (ListView, GridView)
   - `PagingHelperSliverView`: Sliver version for CustomScrollView
   - Both have identical APIs except:
     - PagingHelperSliverView wraps loading/error states with SliverFillRemaining
     - Uses sliverLoadingViewBuilder/sliverErrorViewBuilder from theme
     - No RefreshIndicator support (use CupertinoSliverRefreshControl)

4. **Theme System** (`lib/src/paging_helper_view_theme.dart`)
   - Customizable loading, error, and end item views
   - Separate builders for regular and sliver widgets
   - RefreshIndicator enable/disable control

### Key Architecture Patterns

1. **Mixin-based Pagination Logic**: The package uses mixins to add pagination behavior to Riverpod notifiers. Users create their own notifier class and mix in the appropriate pagination mixin.

2. **Generic Type System**: 
   - `D extends PagingData<I>`: The pagination data type
   - `I`: The item type
   - This allows type-safe pagination for any data model

3. **State Management**: Uses Riverpod's AsyncValue for loading/error/data states with custom extension methods for handling partial errors (data with error state for subsequent pages).

4. **Visibility Detection**: Uses visibility_detector package to automatically trigger next page loading when the last item becomes visible.

## Development Environment

- Flutter SDK: 3.27.0 (managed by mise)
- Dart SDK: >=3.6.0 <4.0.0
- Dependency management: melos
- Code generation: build_runner with freezed and riverpod_generator

## Current Development Status

### Riverpod 3.0 Migration
The package is being prepared for Riverpod 3.0 migration with the following changes planned:
- AutoDisposeAsyncNotifier → AsyncNotifier
- Mutation API support for experimental features
- Maintaining backward compatibility

### Recent Features
- Added PagingHelperSliverView for CustomScrollView support
- Enhanced theme customization options
- Improved test coverage

## Testing Strategy

Tests are organized by component:
- `test/paging_data_test.dart`: Data model tests
- `test/paging_notifier_mixin_test.dart`: Mixin behavior tests  
- `test/paging_helper_view_test.dart`: Widget tests
- `test/paging_helper_sliver_view_test.dart`: Sliver widget tests
- `test/paging_helper_view_theme_test.dart`: Theme system tests

Note: Some sliver tests may have timer issues and are skipped in CI.

## E2E Testing with Dart MCP and Maestro MCP

### MCP Configuration
The project uses two MCP servers for interactive development and E2E testing:
- **Dart MCP**: Flutter app launch, hot reload, widget tree inspection, runtime error detection
- **Maestro MCP**: Screenshot capture, UI element inspection, tap/input operations

### E2E Test Files
Maestro test files are located in `example/.maestro/`:
- `launch_test.yaml`: Basic app launch verification
- `paging_test.yaml`: Pagination functionality test
- `drawer_navigation_test.yaml`: Drawer menu navigation test
- `error_handling_test.yaml`: Error handling test

### Running E2E Tests

#### iOS Simulator
```bash
# Boot simulator
xcrun simctl boot "iPhone 16 Pro"

# Build and install
flutter build ios --simulator
xcrun simctl install booted example/build/ios/iphonesimulator/Runner.app

# Run Maestro test
MAESTRO_DRIVER_STARTUP_TIMEOUT=120000 \
maestro --device "<DEVICE_ID>" \
  test -e APP_ID=com.k9i.materialbuttonassist.example \
  example/.maestro/launch_test.yaml
```

#### Android Emulator
```bash
maestro test -e APP_ID=com.k9i.material_button_assist.example \
  example/.maestro/launch_test.yaml
```

### Interactive Development with MCP

#### Dart MCP Operations
1. `launch_app()` - Launch the example app
2. `connect_dart_tooling_daemon()` - Connect to DTD for debugging
3. `get_widget_tree()` - Inspect widget structure
4. `hot_reload()` - Apply code changes instantly
5. `get_runtime_errors()` - Check for runtime errors

#### Maestro MCP Operations
1. `inspect_view_hierarchy()` - Get UI element hierarchy (lightweight, preferred)
2. `tap_on(id="...")` - Tap by Semantics identifier
3. `input_text(text="...")` - Input text
4. `take_screenshot()` - Capture screenshot (use sparingly for final verification)

### Semantics Identifiers
Example app widgets use Semantics identifiers for E2E testing:
- `drawer-menu-button`: Drawer menu icon button
- `sample-item-{index}`: List items in main/error screens
- `grid-item-{index}`: Grid items in GridView screen
- `sliver-item-{index}`: Sliver list items in CustomScrollView screen

### Best Practices
- Prefer `inspect_view_hierarchy` over `take_screenshot` for element inspection (faster)
- Use `take_screenshot` only for final visual verification
- Add Semantics identifiers to new interactive widgets
- Follow naming convention: `{feature}-{element-type}[-{dynamic-id}]`