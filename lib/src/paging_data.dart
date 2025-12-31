import 'package:freezed_annotation/freezed_annotation.dart';

part 'paging_data.freezed.dart';

/// The status of loading the next page.
enum LoadNextStatus {
  /// Idle state, ready to load next page.
  idle,

  /// Currently loading the next page.
  loading,

  /// An error occurred while loading the next page.
  error,
}

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

  /// The status of loading the next page.
  LoadNextStatus get loadNextStatus;

  /// The error that occurred while loading the next page, if any.
  Object? get loadNextError;

  /// The stack trace of the error that occurred while loading the next page.
  StackTrace? get loadNextStackTrace;
}

/// Extension methods for [PagingData].
extension PagingDataX<T> on PagingData<T> {
  /// Returns `true` if the next page is currently being loaded.
  bool get isLoadingNext => loadNextStatus == LoadNextStatus.loading;

  /// Returns `true` if an error occurred while loading the next page.
  bool get hasLoadNextError => loadNextStatus == LoadNextStatus.error;
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
  /// [loadNextStatus] is the status of loading the next page.
  /// [loadNextError] is the error that occurred while loading the next page.
  /// [loadNextStackTrace] is the stack trace of the error.
  const factory PagePagingData({
    required List<T> items,
    required bool hasMore,
    required int page,
    @Default(LoadNextStatus.idle) LoadNextStatus loadNextStatus,
    @Default(null) Object? loadNextError,
    @Default(null) StackTrace? loadNextStackTrace,
  }) = _PagePagingData<T>;
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
  /// [loadNextStatus] is the status of loading the next page.
  /// [loadNextError] is the error that occurred while loading the next page.
  /// [loadNextStackTrace] is the stack trace of the error.
  const factory OffsetPagingData({
    required List<T> items,
    required bool hasMore,
    required int offset,
    @Default(LoadNextStatus.idle) LoadNextStatus loadNextStatus,
    @Default(null) Object? loadNextError,
    @Default(null) StackTrace? loadNextStackTrace,
  }) = _OffsetPagingData<T>;
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
  /// [loadNextStatus] is the status of loading the next page.
  /// [loadNextError] is the error that occurred while loading the next page.
  /// [loadNextStackTrace] is the stack trace of the error.
  const factory CursorPagingData({
    required List<T> items,
    required bool hasMore,
    required String? nextCursor,
    @Default(LoadNextStatus.idle) LoadNextStatus loadNextStatus,
    @Default(null) Object? loadNextError,
    @Default(null) StackTrace? loadNextStackTrace,
  }) = _CursorPagingData<T>;
}
