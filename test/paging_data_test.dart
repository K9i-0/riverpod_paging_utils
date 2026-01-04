import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';

void main() {
  group('PagePagingData', () {
    test('should create with correct values', () {
      final items = ['item1', 'item2', 'item3'];
      final data = PagePagingData(items: items, page: 2, hasMore: true);

      expect(data.items, equals(items));
      expect(data.page, equals(2));
      expect(data.hasMore, isTrue);
    });

    test('copyWith should create new instance with updated values', () {
      final originalItems = ['item1', 'item2'];
      final data = PagePagingData(items: originalItems, page: 1, hasMore: true);

      final newItems = ['item1', 'item2', 'item3'];
      final updatedData = data.copyWith(
        items: newItems,
        page: 2,
        hasMore: false,
      );

      expect(updatedData.items, equals(newItems));
      expect(updatedData.page, equals(2));
      expect(updatedData.hasMore, isFalse);

      // Original should remain unchanged
      expect(data.items, equals(originalItems));
      expect(data.page, equals(1));
      expect(data.hasMore, isTrue);
    });

    test('copyWith with no parameters should return identical data', () {
      final items = ['item1', 'item2'];
      final data = PagePagingData(items: items, page: 1, hasMore: true);

      final copiedData = data.copyWith();

      expect(copiedData.items, equals(data.items));
      expect(copiedData.page, equals(data.page));
      expect(copiedData.hasMore, equals(data.hasMore));
    });
  });

  group('OffsetPagingData', () {
    test('should create with correct values', () {
      final items = ['item1', 'item2', 'item3'];
      final data = OffsetPagingData(items: items, offset: 20, hasMore: true);

      expect(data.items, equals(items));
      expect(data.offset, equals(20));
      expect(data.hasMore, isTrue);
    });

    test('copyWith should create new instance with updated values', () {
      final originalItems = ['item1', 'item2'];
      final data = OffsetPagingData(
        items: originalItems,
        offset: 0,
        hasMore: true,
      );

      final newItems = ['item1', 'item2', 'item3'];
      final updatedData = data.copyWith(
        items: newItems,
        offset: 20,
        hasMore: false,
      );

      expect(updatedData.items, equals(newItems));
      expect(updatedData.offset, equals(20));
      expect(updatedData.hasMore, isFalse);

      // Original should remain unchanged
      expect(data.items, equals(originalItems));
      expect(data.offset, equals(0));
      expect(data.hasMore, isTrue);
    });

    test('copyWith with no parameters should return identical data', () {
      final items = ['item1', 'item2'];
      final data = OffsetPagingData(items: items, offset: 10, hasMore: false);

      final copiedData = data.copyWith();

      expect(copiedData.items, equals(data.items));
      expect(copiedData.offset, equals(data.offset));
      expect(copiedData.hasMore, equals(data.hasMore));
    });
  });

  group('CursorPagingData', () {
    test('should create with correct values', () {
      final items = ['item1', 'item2', 'item3'];
      const nextCursor = 'next_cursor_123';
      final data = CursorPagingData(
        items: items,
        nextCursor: nextCursor,
        hasMore: true,
      );

      expect(data.items, equals(items));
      expect(data.nextCursor, equals(nextCursor));
      expect(data.hasMore, isTrue);
    });

    test('should create with null cursor', () {
      final items = ['item1', 'item2'];
      final data = CursorPagingData(
        items: items,
        nextCursor: null,
        hasMore: false,
      );

      expect(data.items, equals(items));
      expect(data.nextCursor, isNull);
      expect(data.hasMore, isFalse);
    });

    test('copyWith should create new instance with updated values', () {
      final originalItems = ['item1', 'item2'];
      final data = CursorPagingData(
        items: originalItems,
        nextCursor: 'cursor1',
        hasMore: true,
      );

      final newItems = ['item1', 'item2', 'item3'];
      final updatedData = data.copyWith(
        items: newItems,
        nextCursor: 'cursor2',
        hasMore: false,
      );

      expect(updatedData.items, equals(newItems));
      expect(updatedData.nextCursor, equals('cursor2'));
      expect(updatedData.hasMore, isFalse);

      // Original should remain unchanged
      expect(data.items, equals(originalItems));
      expect(data.nextCursor, equals('cursor1'));
      expect(data.hasMore, isTrue);
    });

    test('copyWith can update to null cursor', () {
      final items = ['item1', 'item2'];
      final data = CursorPagingData(
        items: items,
        nextCursor: 'cursor1',
        hasMore: true,
      );

      final updatedData = data.copyWith(nextCursor: null, hasMore: false);

      expect(updatedData.nextCursor, isNull);
      expect(updatedData.hasMore, isFalse);
    });

    test('copyWith with no parameters should return identical data', () {
      final items = ['item1', 'item2'];
      final data = CursorPagingData(
        items: items,
        nextCursor: 'cursor1',
        hasMore: true,
      );

      final copiedData = data.copyWith();

      expect(copiedData.items, equals(data.items));
      expect(copiedData.nextCursor, equals(data.nextCursor));
      expect(copiedData.hasMore, equals(data.hasMore));
    });
  });

  group('Edge cases', () {
    test('PagePagingData with empty items', () {
      const data = PagePagingData(items: [], page: 0, hasMore: false);

      expect(data.items, isEmpty);
      expect(data.page, equals(0));
      expect(data.hasMore, isFalse);
    });

    test('PagePagingData with large number of items', () {
      final items = List.generate(10000, (i) => 'item$i');
      final data = PagePagingData(items: items, page: 100, hasMore: true);

      expect(data.items.length, equals(10000));
      expect(data.items.first, equals('item0'));
      expect(data.items.last, equals('item9999'));
    });

    test('PagingData with different type parameters', () {
      // Test with int
      const intData = PagePagingData(items: [1, 2, 3], page: 0, hasMore: true);
      expect(intData.items, equals([1, 2, 3]));

      // Test with custom object
      const customData = PagePagingData<CustomItem>(
        items: [
          CustomItem(id: 1, name: 'Item 1'),
          CustomItem(id: 2, name: 'Item 2'),
        ],
        page: 0,
        hasMore: false,
      );
      expect(customData.items.length, equals(2));
      expect(customData.items.first.name, equals('Item 1'));
    });

    test('OffsetPagingData with zero offset', () {
      const data = OffsetPagingData<String>(
        items: ['item1', 'item2'],
        offset: 0,
        hasMore: true,
      );

      expect(data.offset, equals(0));
      expect(data.hasMore, isTrue);
    });

    test('CursorPagingData with empty string cursor', () {
      const data = CursorPagingData<String>(
        items: ['item1'],
        nextCursor: '',
        hasMore: true,
      );

      expect(data.nextCursor, equals(''));
      expect(data.nextCursor, isNotNull);
      expect(data.hasMore, isTrue);
    });

    test('PagingData implements common interface', () {
      const pagePaging = PagePagingData<String>(
        items: ['a', 'b'],
        page: 1,
        hasMore: true,
      );

      const offsetPaging = OffsetPagingData<String>(
        items: ['c', 'd'],
        offset: 2,
        hasMore: false,
      );

      const cursorPaging = CursorPagingData<String>(
        items: ['e', 'f'],
        nextCursor: 'next',
        hasMore: true,
      );

      // All should implement PagingData interface
      expect(pagePaging, isA<PagingData<String>>());
      expect(offsetPaging, isA<PagingData<String>>());
      expect(cursorPaging, isA<PagingData<String>>());

      // Test interface methods
      expect(pagePaging.items, equals(['a', 'b']));
      expect(pagePaging.hasMore, isTrue);

      expect(offsetPaging.items, equals(['c', 'd']));
      expect(offsetPaging.hasMore, isFalse);

      expect(cursorPaging.items, equals(['e', 'f']));
      expect(cursorPaging.hasMore, isTrue);
    });
  });
}

// Test helper class
@immutable
class CustomItem {
  const CustomItem({required this.id, required this.name});

  final int id;
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
