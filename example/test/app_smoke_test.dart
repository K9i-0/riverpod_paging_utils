import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('loads the first page and loads more when scrolled', (
    tester,
  ) async {
    await _launch(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await _pumpFor(tester, const Duration(milliseconds: 700));
    expect(find.byKey(const ValueKey('sample-list')), findsOneWidget);
    expect(find.byKey(const ValueKey('1')), findsOneWidget);
    await _scrollToItem(tester, const ValueKey('sample-list'), '31');
  });

  final destinations = <(String, String)>[
    ('first-page-error', '1st Page Error Sample'),
    ('second-page-error', '2nd Page Error Sample'),
    ('passing-args', 'Passing Args Sample'),
    ('paging-method', 'Paging Method Sample'),
    ('grid-view', 'GridView Example'),
    ('custom-scroll-view', 'PagingHelperSliverView'),
  ];
  for (final (menu, title) in destinations) {
    testWidgets('opens $menu and returns with the drawer closed', (
      tester,
    ) async {
      await _launch(tester);
      await _openMenu(tester, menu);
      await _pumpFor(tester, const Duration(milliseconds: 1200));
      expect(find.text(title), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(const ValueKey('back-button')));
      await _pumpFor(tester, const Duration(milliseconds: 400));
      expect(find.text('Sample Screen'), findsOneWidget);
      final scaffold = tester.state<ScaffoldState>(
        find.descendant(
          of: find.byType(SampleScreen),
          matching: find.byType(Scaffold),
        ),
      );
      expect(scaffold.isDrawerOpen, isFalse);
    });
  }

  testWidgets('first-page retry loads before the demo error returns', (
    tester,
  ) async {
    await _launch(tester);
    await _openMenu(tester, 'first-page-error');
    await _pumpFor(tester, const Duration(milliseconds: 700));
    final retry = find.byKey(const ValueKey('retry-button'));
    expect(retry, findsOneWidget);
    expect(find.text('Error: Exception: Error fetching data'), findsOneWidget);
    await tester.tap(retry);
    await tester.pump();
    expect(retry, findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await _pumpFor(tester, const Duration(milliseconds: 700));
    expect(retry, findsOneWidget);
  });

  testWidgets('second-page retry and error toggle preserve items', (
    tester,
  ) async {
    await _launch(tester);
    await _openMenu(tester, 'second-page-error');
    await _pumpFor(tester, const Duration(milliseconds: 1200));
    final retry = find.byKey(const ValueKey('error-retry-button'));
    final toggle = find.byKey(const ValueKey('show-second-page-error-switch'));
    expect(retry, findsOneWidget);
    expect(find.byKey(const ValueKey('item-0')), findsOneWidget);
    await tester.tap(retry);
    await tester.pump();
    expect(retry, findsNothing);
    expect(find.byKey(const ValueKey('item-0')), findsOneWidget);
    await _pumpFor(tester, const Duration(milliseconds: 700));
    expect(retry, findsOneWidget);
    await tester.tap(toggle);
    await tester.pump();
    expect(tester.widget<Switch>(toggle).value, isFalse);
    expect(retry, findsNothing);
    expect(find.byKey(const ValueKey('item-0')), findsOneWidget);
    await tester.tap(toggle);
    await tester.pump();
    expect(tester.widget<Switch>(toggle).value, isTrue);
    expect(retry, findsOneWidget);
  });

  for (final (mode, nextItem) in [
    ('page', '11'),
    ('offset', '16'),
    ('cursor', '31'),
  ]) {
    testWidgets('$mode tab loads the next page', (tester) async {
      await _launch(tester);
      await _openMenu(tester, 'paging-method');
      await tester.tap(find.byKey(ValueKey('$mode-tab')));
      await _pumpFor(tester, const Duration(milliseconds: 900));
      await _scrollToItem(tester, PageStorageKey<String>(mode), nextItem);
    });
  }

  testWidgets('grid switches vertical and horizontal scrolling', (
    tester,
  ) async {
    await _launch(tester);
    await _openMenu(tester, 'grid-view');
    await _pumpFor(tester, const Duration(milliseconds: 700));
    final grid = find.byKey(const ValueKey('sample-grid'));
    expect(tester.widget<GridView>(grid).scrollDirection, Axis.vertical);
    await tester.tap(
      find.byKey(const ValueKey('grid-scroll-direction-button')),
    );
    await tester.pump();
    expect(tester.widget<GridView>(grid).scrollDirection, Axis.horizontal);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _launch(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(retry: (retryCount, error) => null, child: const MainApp()),
  );
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}

Future<void> _openMenu(WidgetTester tester, String menu) async {
  await tester.tap(find.byKey(const ValueKey('drawer-menu-button')));
  await _pumpFor(tester, const Duration(milliseconds: 300));
  final item = find.byKey(ValueKey('menu-$menu'));
  await tester.ensureVisible(item);
  await tester.tap(item);
  await _pumpFor(tester, const Duration(milliseconds: 400));
}

Future<void> _pumpFor(WidgetTester tester, Duration duration) async {
  const frame = Duration(milliseconds: 100);
  for (var elapsed = Duration.zero; elapsed < duration; elapsed += frame) {
    await tester.pump(frame);
  }
}

Future<void> _scrollToItem(
  WidgetTester tester,
  Key listKey,
  String itemId,
) async {
  final item = find.byKey(ValueKey(itemId)).hitTestable();
  for (var attempt = 0; attempt < 20 && item.evaluate().isEmpty; attempt++) {
    await tester.drag(find.byKey(listKey), const Offset(0, -400));
    await _pumpFor(tester, const Duration(milliseconds: 700));
  }
  expect(item, findsOneWidget);
}
