import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';
import 'package:riverpod_paging_utils/src/paging_notifier_mixin.dart';

// Test implementations
class TestPagePagingNotifier
    extends Notifier<AsyncValue<PagePagingData<String>>>
    with PagePagingNotifierMixin<String> {
  List<String> Function(int page)? fetchFunction;

  @override
  AsyncValue<PagePagingData<String>> build() {
    return const AsyncValue.loading();
  }

  @override
  Future<PagePagingData<String>> fetch({required int page}) async {
    if (fetchFunction != null) {
      final items = fetchFunction!(page);
      return PagePagingData(
        items: items,
        page: page,
        hasMore: items.isNotEmpty,
      );
    }
    return PagePagingData(
      items: [
        'item${page * 3 + 1}',
        'item${page * 3 + 2}',
        'item${page * 3 + 3}',
      ],
      page: page,
      hasMore: page < 3,
    );
  }
}

class TestOffsetPagingNotifier
    extends Notifier<AsyncValue<OffsetPagingData<String>>>
    with OffsetPagingNotifierMixin<String> {
  List<String> Function(int offset)? fetchFunction;

  @override
  AsyncValue<OffsetPagingData<String>> build() {
    return const AsyncValue.loading();
  }

  @override
  Future<OffsetPagingData<String>> fetch({required int offset}) async {
    if (fetchFunction != null) {
      final items = fetchFunction!(offset);
      return OffsetPagingData(
        items: items,
        offset: offset + items.length,
        hasMore: items.isNotEmpty,
      );
    }
    return OffsetPagingData(
      items: ['item${offset + 1}', 'item${offset + 2}', 'item${offset + 3}'],
      offset: offset + 3,
      hasMore: offset < 9,
    );
  }
}

class TestCursorPagingNotifier
    extends Notifier<AsyncValue<CursorPagingData<String>>>
    with CursorPagingNotifierMixin<String> {
  List<String> Function(String? cursor)? fetchFunction;

  @override
  AsyncValue<CursorPagingData<String>> build() {
    return const AsyncValue.loading();
  }

  @override
  Future<CursorPagingData<String>> fetch({required String? cursor}) async {
    if (fetchFunction != null) {
      final items = fetchFunction!(cursor);
      return CursorPagingData(
        items: items,
        nextCursor: items.isEmpty ? null : 'cursor_${items.last}',
        hasMore: items.isNotEmpty,
      );
    }
    final page = cursor == null ? 0 : int.parse(cursor.split('_').last);
    return CursorPagingData(
      items: [
        'item${page * 3 + 1}',
        'item${page * 3 + 2}',
        'item${page * 3 + 3}',
      ],
      nextCursor: page < 2 ? 'cursor_${page + 1}' : null,
      hasMore: page < 2,
    );
  }
}

// Test providers
final testPagePagingProvider = NotifierProvider<TestPagePagingNotifier,
    AsyncValue<PagePagingData<String>>>(() {
  return TestPagePagingNotifier();
});

final testOffsetPagingProvider = NotifierProvider<TestOffsetPagingNotifier,
    AsyncValue<OffsetPagingData<String>>>(() {
  return TestOffsetPagingNotifier();
});

final testCursorPagingProvider = NotifierProvider<TestCursorPagingNotifier,
    AsyncValue<CursorPagingData<String>>>(() {
  return TestCursorPagingNotifier();
});

void main() {
  group('PagePagingNotifierMixin', () {
    test('loadNext should load next page when hasMore is true', () async {
      final container = ProviderContainer();
      final notifier = container.read(testPagePagingProvider.notifier);

      // Set initial data
      notifier.state = const AsyncValue.data(
        PagePagingData<String>(
          items: ['item1', 'item2', 'item3'],
          page: 0,
          hasMore: true,
        ),
      );

      await notifier.loadNext();

      final state = container.read(testPagePagingProvider);
      expect(state.hasValue, isTrue);
      expect(state.value!.items.length, equals(6));
      expect(
        state.value!.items,
        equals(['item1', 'item2', 'item3', 'item4', 'item5', 'item6']),
      );
      expect(state.value!.page, equals(1));
    });

    test('loadNext should not load when hasMore is false', () async {
      final container = ProviderContainer();
      final notifier = container.read(testPagePagingProvider.notifier);

      // Set initial data with hasMore = false
      notifier.state = const AsyncValue.data(
        PagePagingData<String>(
          items: ['item1', 'item2', 'item3'],
          page: 3,
          hasMore: false,
        ),
      );

      await notifier.loadNext();

      final state = container.read(testPagePagingProvider);
      expect(state.value!.items.length, equals(3));
      expect(state.value!.page, equals(3));
    });

    test('loadNext should handle errors gracefully', () async {
      final container = ProviderContainer();
      final notifier = container.read(testPagePagingProvider.notifier);

      // Set fetch function that throws error
      notifier.fetchFunction = (page) => throw Exception('Fetch error');

      notifier.state = const AsyncValue.data(
        PagePagingData<String>(
          items: ['item1', 'item2', 'item3'],
          page: 0,
          hasMore: true,
        ),
      );

      await notifier.loadNext();

      final state = container.read(testPagePagingProvider);
      expect(state.hasError, isTrue);
      expect(state.error.toString(), contains('Fetch error'));
      // Previous data should be preserved
      expect(state.valueOrNull?.items, equals(['item1', 'item2', 'item3']));
    });

    test('forceRefresh should clear state and invalidate', () {
      final container = ProviderContainer();
      final notifier = container.read(testPagePagingProvider.notifier);

      notifier.state = const AsyncValue.data(
        PagePagingData<String>(
          items: ['item1', 'item2', 'item3'],
          page: 1,
          hasMore: true,
        ),
      );

      notifier.forceRefresh();

      final state = container.read(testPagePagingProvider);
      expect(state.isLoading, isTrue);
      expect(state.value, isNull);
    });

    test('loadNext should handle concurrent calls properly', () async {
      final container = ProviderContainer();
      final notifier = container.read(testPagePagingProvider.notifier);

      // Set initial data
      notifier.state = const AsyncValue.data(
        PagePagingData<String>(
          items: ['item1', 'item2', 'item3'],
          page: 0,
          hasMore: true,
        ),
      );

      // Call loadNext multiple times concurrently
      final future1 = notifier.loadNext();
      final future2 = notifier.loadNext();
      final future3 = notifier.loadNext();

      await Future.wait([future1, future2, future3]);

      final state = container.read(testPagePagingProvider);
      // Should only load once, not three times
      expect(state.value!.items.length, equals(6));
      expect(state.value!.page, equals(1));
    });

    test('loadNext should do nothing when state is null', () async {
      final container = ProviderContainer();
      final notifier = container.read(testPagePagingProvider.notifier);

      // Keep state as loading (no value)
      notifier.state = const AsyncValue.loading();

      await notifier.loadNext();

      final state = container.read(testPagePagingProvider);
      expect(state.isLoading, isTrue);
      expect(state.valueOrNull, isNull);
    });

    test('loadNext should work correctly after error recovery', () async {
      final container = ProviderContainer();
      final notifier = container.read(testPagePagingProvider.notifier);

      // Set initial data
      notifier.state = const AsyncValue.data(
        PagePagingData<String>(
          items: ['item1', 'item2', 'item3'],
          page: 0,
          hasMore: true,
        ),
      );

      // First attempt fails
      notifier.fetchFunction = (page) => throw Exception('Network error');
      await notifier.loadNext();

      // Verify error state with preserved data
      var state = container.read(testPagePagingProvider);
      expect(state.hasError, isTrue);
      expect(state.valueOrNull?.items, equals(['item1', 'item2', 'item3']));

      // Fix the fetch function and retry
      notifier.fetchFunction = null; // Reset to default
      await notifier.loadNext();

      // Should successfully load next page
      state = container.read(testPagePagingProvider);
      expect(state.hasError, isFalse);
      expect(state.value!.items.length, equals(6));
      expect(state.value!.page, equals(1));
    });
  });

  group('OffsetPagingNotifierMixin', () {
    test('loadNext should load next items when hasMore is true', () async {
      final container = ProviderContainer();
      final notifier = container.read(testOffsetPagingProvider.notifier);

      // Set initial data
      notifier.state = const AsyncValue.data(
        OffsetPagingData<String>(
          items: ['item1', 'item2', 'item3'],
          offset: 3,
          hasMore: true,
        ),
      );

      await notifier.loadNext();

      final state = container.read(testOffsetPagingProvider);
      expect(state.hasValue, isTrue);
      expect(state.value!.items.length, equals(6));
      expect(
        state.value!.items,
        equals(['item1', 'item2', 'item3', 'item4', 'item5', 'item6']),
      );
      expect(state.value!.offset, equals(6));
    });

    test('loadNext should not load when hasMore is false', () async {
      final container = ProviderContainer();
      final notifier = container.read(testOffsetPagingProvider.notifier);

      // Set initial data with hasMore = false
      notifier.state = const AsyncValue.data(
        OffsetPagingData<String>(
          items: ['item1', 'item2', 'item3'],
          offset: 12,
          hasMore: false,
        ),
      );

      await notifier.loadNext();

      final state = container.read(testOffsetPagingProvider);
      expect(state.value!.items.length, equals(3));
      expect(state.value!.offset, equals(12));
    });

    test('loadNext should handle errors gracefully', () async {
      final container = ProviderContainer();
      final notifier = container.read(testOffsetPagingProvider.notifier);

      // Set fetch function that throws error
      notifier.fetchFunction = (offset) => throw Exception('Fetch error');

      notifier.state = const AsyncValue.data(
        OffsetPagingData<String>(
          items: ['item1', 'item2', 'item3'],
          offset: 3,
          hasMore: true,
        ),
      );

      await notifier.loadNext();

      final state = container.read(testOffsetPagingProvider);
      expect(state.hasError, isTrue);
      expect(state.error.toString(), contains('Fetch error'));
      // Previous data should be preserved
      expect(state.valueOrNull?.items, equals(['item1', 'item2', 'item3']));
    });

    test('forceRefresh should clear state and invalidate', () {
      final container = ProviderContainer();
      final notifier = container.read(testOffsetPagingProvider.notifier);

      notifier.state = const AsyncValue.data(
        OffsetPagingData<String>(
          items: ['item1', 'item2', 'item3'],
          offset: 3,
          hasMore: true,
        ),
      );

      notifier.forceRefresh();

      final state = container.read(testOffsetPagingProvider);
      expect(state.isLoading, isTrue);
      expect(state.value, isNull);
    });
  });

  group('CursorPagingNotifierMixin', () {
    test('loadNext should load next items when hasMore is true', () async {
      final container = ProviderContainer();
      final notifier = container.read(testCursorPagingProvider.notifier);

      // Set initial data
      notifier.state = const AsyncValue.data(
        CursorPagingData<String>(
          items: ['item1', 'item2', 'item3'],
          nextCursor: 'cursor_1',
          hasMore: true,
        ),
      );

      await notifier.loadNext();

      final state = container.read(testCursorPagingProvider);
      expect(state.hasValue, isTrue);
      expect(state.value!.items.length, equals(6));
      expect(
        state.value!.items,
        equals(['item1', 'item2', 'item3', 'item4', 'item5', 'item6']),
      );
      expect(state.value!.nextCursor, equals('cursor_2'));
    });

    test('loadNext should not load when hasMore is false', () async {
      final container = ProviderContainer();
      final notifier = container.read(testCursorPagingProvider.notifier);

      // Set initial data with hasMore = false
      notifier.state = const AsyncValue.data(
        CursorPagingData<String>(
          items: ['item1', 'item2', 'item3'],
          nextCursor: null,
          hasMore: false,
        ),
      );

      await notifier.loadNext();

      final state = container.read(testCursorPagingProvider);
      expect(state.value!.items.length, equals(3));
      expect(state.value!.nextCursor, isNull);
    });

    test('loadNext should handle errors gracefully', () async {
      final container = ProviderContainer();
      final notifier = container.read(testCursorPagingProvider.notifier);

      // Set fetch function that throws error
      notifier.fetchFunction = (cursor) => throw Exception('Fetch error');

      notifier.state = const AsyncValue.data(
        CursorPagingData<String>(
          items: ['item1', 'item2', 'item3'],
          nextCursor: 'cursor_1',
          hasMore: true,
        ),
      );

      await notifier.loadNext();

      final state = container.read(testCursorPagingProvider);
      expect(state.hasError, isTrue);
      expect(state.error.toString(), contains('Fetch error'));
      // Previous data should be preserved
      expect(state.valueOrNull?.items, equals(['item1', 'item2', 'item3']));
    });

    test('forceRefresh should clear state and invalidate', () {
      final container = ProviderContainer();
      final notifier = container.read(testCursorPagingProvider.notifier);

      notifier.state = const AsyncValue.data(
        CursorPagingData<String>(
          items: ['item1', 'item2', 'item3'],
          nextCursor: 'cursor_1',
          hasMore: true,
        ),
      );

      notifier.forceRefresh();

      final state = container.read(testCursorPagingProvider);
      expect(state.isLoading, isTrue);
      expect(state.value, isNull);
    });
  });
}
