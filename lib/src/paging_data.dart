import 'package:freezed_annotation/freezed_annotation.dart';

part 'paging_data.freezed.dart';

/// An abstract class representing paginated data.
///
/// This class provides a common interface for different types of paginated data,
/// such as page-based, offset-based, and cursor-based pagination.
@internal
abstract interface class PagingData<T> {
  /// The list of items in the current page.
  List<T> get items;

  /// Indicates whether there are more pages available.
  bool get hasMore;
}

/// Represents paginated data using page-based pagination.
///
/// This class implements the [PagingData] interface and provides additional
/// information specific to page-based pagination.
@freezed
abstract class PagePagingData<T>
    with _$PagePagingData<T>
    implements PagingData<T> {
  /// Creates a new instance of [PagePagingData].
  ///
  /// [items] is the list of items in the current page.
  /// [hasMore] indicates whether there are more pages available.
  /// [page] is the current page number.
  const factory PagePagingData({
    required List<T> items,
    required bool hasMore,
    required int page,
  }) = _PagePagingData;
}

/// Represents paginated data using offset-based pagination.
///
/// This class implements the [PagingData] interface and provides additional
/// information specific to offset-based pagination.
@freezed
abstract class OffsetPagingData<T>
    with _$OffsetPagingData<T>
    implements PagingData<T> {
  /// Creates a new instance of [OffsetPagingData].
  ///
  /// [items] is the list of items in the current page.
  /// [hasMore] indicates whether there are more items available.
  /// [offset] is the current offset value.
  const factory OffsetPagingData({
    required List<T> items,
    required bool hasMore,
    required int offset,
  }) = _OffsetPagingData;
}

/// Represents paginated data using cursor-based pagination.
///
/// This class implements the [PagingData] interface and provides additional
/// information specific to cursor-based pagination.
@freezed
abstract class CursorPagingData<T>
    with _$CursorPagingData<T>
    implements PagingData<T> {
  /// Creates a new instance of [CursorPagingData].
  ///
  /// [items] is the list of items in the current page.
  /// [hasMore] indicates whether there are more items available.
  /// [nextCursor] is the cursor value for the next page, or `null` if there are no more pages.
  const factory CursorPagingData({
    required List<T> items,
    required bool hasMore,
    required String? nextCursor,
  }) = _CursorPagingData;
}
