import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';

void main() {
  group('PagePagingData', () {
    test('should create with correct values', () {
      final items = ['item1', 'item2', 'item3'];
      final data = PagePagingData(
        items: items,
        page: 2,
        hasMore: true,
      );

      expect(data.items, equals(items));
      expect(data.page, equals(2));
      expect(data.hasMore, isTrue);
    });

    test('copyWith should create new instance with updated values', () {
      final originalItems = ['item1', 'item2'];
      final data = PagePagingData(
        items: originalItems,
        page: 1,
        hasMore: true,
      );

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
      final data = PagePagingData(
        items: items,
        page: 1,
        hasMore: true,
      );

      final copiedData = data.copyWith();

      expect(copiedData.items, equals(data.items));
      expect(copiedData.page, equals(data.page));
      expect(copiedData.hasMore, equals(data.hasMore));
    });
  });

  group('OffsetPagingData', () {
    test('should create with correct values', () {
      final items = ['item1', 'item2', 'item3'];
      final data = OffsetPagingData(
        items: items,
        offset: 20,
        hasMore: true,
      );

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
      final data = OffsetPagingData(
        items: items,
        offset: 10,
        hasMore: false,
      );

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

      final updatedData = data.copyWith(
        nextCursor: null,
        hasMore: false,
      );

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
}