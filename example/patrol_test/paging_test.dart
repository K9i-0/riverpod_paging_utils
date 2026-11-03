import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart' show expect, isFalse, isTrue;
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('loads the first page and the next cursor page', ($) async {
    await _launch($);
    await $(const ValueKey('1')).waitUntilVisible();
    await $(const ValueKey('31')).scrollTo(
      view: $(const ValueKey('sample-list')),
      step: 300,
      maxScrolls: 30,
    );
  });

  for (final (mode, nextItem) in [
    ('page', '11'),
    ('offset', '16'),
    ('cursor', '31'),
  ]) {
    patrolTest('$mode pagination loads the next page', ($) async {
      await _launch($);
      await _openMenu($, 'paging-method');
      await $(ValueKey('$mode-tab')).tap();
      await $(ValueKey(nextItem)).scrollTo(
        view: $(PageStorageKey<String>(mode)),
        step: 300,
        maxScrolls: 30,
      );
    });
  }

  patrolTest('first-page error can retry and reports the demo error again', (
    $,
  ) async {
    await _launch($);
    await _openMenu($, 'first-page-error');
    await $(const ValueKey('retry-button'))
        .tap(settlePolicy: SettlePolicy.noSettle);
    expect($(const ValueKey('retry-button')).exists, isFalse);
    await $(const ValueKey('retry-button')).waitUntilVisible();
  });

  patrolTest('load-more retry preserves the first page', ($) async {
    await _launch($);
    await _openMenu($, 'second-page-error');
    await $(const ValueKey('error-retry-button'))
        .tap(settlePolicy: SettlePolicy.noSettle);
    expect($(const ValueKey('error-retry-button')).exists, isFalse);
    await $(const ValueKey('error-retry-button')).waitUntilVisible();
    await $(const ValueKey('item-0')).waitUntilVisible();
  });

  patrolTest('load-more errors can be hidden without removing items', (
    $,
  ) async {
    await _launch($);
    await _openMenu($, 'second-page-error');
    await $(const ValueKey('error-retry-button')).tap();
    await $(const ValueKey('show-second-page-error-switch')).tap();
    expect(
      $.tester
          .widget<Switch>($(const ValueKey('show-second-page-error-switch')))
          .value,
      isFalse,
    );
    expect($(const ValueKey('error-retry-button')).exists, isFalse);
    await $(const ValueKey('item-0')).waitUntilVisible();
    await $(const ValueKey('show-second-page-error-switch')).tap();
    expect(
      $.tester
          .widget<Switch>($(const ValueKey('show-second-page-error-switch')))
          .value,
      isTrue,
    );
    await $(const ValueKey('error-retry-button')).waitUntilVisible();
  });

  patrolTest('provider arguments survive loading another page', ($) async {
    await _launch($);
    await _openMenu($, 'passing-args');
    await $(const ValueKey('31')).scrollTo(
      view: $(const ValueKey('passing-args-list')),
      step: 300,
      maxScrolls: 30,
    );
    await $(const ValueKey('back-button')).tap();
    await $(const ValueKey('drawer-menu-button')).waitUntilVisible();
    expect($(const ValueKey('menu-passing-args')).visible, isFalse);
  });

  patrolTest('grid paginates and changes scroll direction', ($) async {
    await _launch($);
    await _openMenu($, 'grid-view');
    await $(const ValueKey('grid-item-31')).scrollTo(
      view: $(const ValueKey('sample-grid')),
      step: 300,
      maxScrolls: 30,
    );
    await $(const ValueKey('grid-scroll-direction-button')).tap();
    expect(
      $.tester
          .widget<GridView>($(const ValueKey('sample-grid')))
          .scrollDirection,
      Axis.horizontal,
    );
  });

  patrolTest('sliver list loads another page inside a custom scroll view', (
    $,
  ) async {
    await _launch($);
    await _openMenu($, 'custom-scroll-view');
    await $(const ValueKey('sliver-item-1')).waitUntilVisible();
    await $(const ValueKey('sliver-item-31')).scrollTo(
      view: $(const ValueKey('sample-custom-scroll-view')),
      // Slow drags prevent iOS momentum from skipping the lazy target item.
      step: 150,
      dragDuration: const Duration(milliseconds: 500),
      maxScrolls: 30,
    );
  }, tags: ['sliver']);
}

Future<void> _launch(PatrolIntegrationTester $) async {
  await $.pumpWidgetAndSettle(
    ProviderScope(retry: (retryCount, error) => null, child: const MainApp()),
  );
}

Future<void> _openMenu(PatrolIntegrationTester $, String menu) async {
  await $(const ValueKey('drawer-menu-button')).tap();
  await $(ValueKey('menu-$menu'))
      .scrollTo(view: $(const ValueKey('drawer-menu-list')));
  await $(ValueKey('menu-$menu')).tap();
}
