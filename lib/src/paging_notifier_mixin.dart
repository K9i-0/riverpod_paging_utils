import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';

/// A mixin interface for pagination notifiers.
///
/// This interface defines the common contract for all pagination notifiers,
/// providing access to the current state, the Riverpod [Ref], and methods
/// for loading more data and refreshing.
@internal
abstract interface class PagingNotifierMixin<D extends PagingData<T>, T> {
  /// The current state of the pagination data.
  AsyncValue<D> get state;

  /// Sets the current state of the pagination data.
  set state(AsyncValue<D> newState);

  /// The Riverpod [Ref] for this notifier.
  // Note: Riverpod 3.0 removed the type parameter from Ref
  Ref get ref;

  /// Loads the next page of data.
  Future<void> loadNext();

  /// Discards the current state and force refreshes the data.
  void forceRefresh();
}

/// A mixin for page-based pagination using [PagePagingData].
///
/// Use this mixin when using @riverpod
abstract mixin class PagePagingNotifierMixin<T>
    implements PagingNotifierMixin<PagePagingData<T>, T> {
  /// Fetches the paginated data for the specified [page].
  Future<PagePagingData<T>> fetch({required int page});

  /// Loads the next page of data.
  @override
  Future<void> loadNext() async {
    // Riverpod 3.0: valueOrNull is renamed to value
    final value = state.value;
    if (value == null) {
      return;
    }

    // Skip if already loading or no more data
    if (value.isLoadingNext || !value.hasMore) {
      return;
    }

    // Set loading state while preserving data
    state = AsyncData(
      value.copyWith(
        loadNextStatus: LoadNextStatus.loading,
        loadNextError: null,
        loadNextStackTrace: null,
      ),
    );

    try {
      final next = await fetch(page: value.page + 1);

      // Success: merge items and reset status
      state = AsyncData(
        value.copyWith(
          items: [...value.items, ...next.items],
          page: value.page + 1,
          hasMore: next.hasMore,
          loadNextStatus: LoadNextStatus.idle,
        ),
      );
    } on Object catch (e, st) {
      // Error: preserve data and set error status
      state = AsyncData(
        value.copyWith(
          loadNextStatus: LoadNextStatus.error,
          loadNextError: e,
          loadNextStackTrace: st,
        ),
      );
    }
  }

  /// Discards the current state and force refreshes the data.
  @override
  void forceRefresh() {
    state = const AsyncLoading();
    ref.invalidateSelf();
  }
}

/// A mixin for offset-based pagination using [OffsetPagingData].
///
/// Use this mixin when using @riverpod
abstract mixin class OffsetPagingNotifierMixin<T>
    implements PagingNotifierMixin<OffsetPagingData<T>, T> {
  /// Fetches the paginated data for the specified [offset].
  Future<OffsetPagingData<T>> fetch({required int offset});

  /// Loads the next set of data based on the offset.
  @override
  Future<void> loadNext() async {
    // Riverpod 3.0: valueOrNull is renamed to value
    final value = state.value;
    if (value == null) {
      return;
    }

    // Skip if already loading or no more data
    if (value.isLoadingNext || !value.hasMore) {
      return;
    }

    // Set loading state while preserving data
    state = AsyncData(
      value.copyWith(
        loadNextStatus: LoadNextStatus.loading,
        loadNextError: null,
        loadNextStackTrace: null,
      ),
    );

    try {
      final next = await fetch(offset: value.offset);

      // Success: merge items and reset status
      state = AsyncData(
        value.copyWith(
          items: [...value.items, ...next.items],
          offset: next.offset,
          hasMore: next.hasMore,
          loadNextStatus: LoadNextStatus.idle,
        ),
      );
    } on Object catch (e, st) {
      // Error: preserve data and set error status
      state = AsyncData(
        value.copyWith(
          loadNextStatus: LoadNextStatus.error,
          loadNextError: e,
          loadNextStackTrace: st,
        ),
      );
    }
  }

  /// Discards the current state and force refreshes the data.
  @override
  void forceRefresh() {
    state = const AsyncLoading();
    ref.invalidateSelf();
  }
}

/// A mixin for cursor-based pagination using [CursorPagingData].
///
/// Use this mixin when using @riverpod
abstract mixin class CursorPagingNotifierMixin<T>
    implements PagingNotifierMixin<CursorPagingData<T>, T> {
  /// Fetches the paginated data for the specified [cursor].
  Future<CursorPagingData<T>> fetch({required String? cursor});

  /// Loads the next set of data based on the cursor.
  @override
  Future<void> loadNext() async {
    // Riverpod 3.0: valueOrNull is renamed to value
    final value = state.value;
    if (value == null) {
      return;
    }

    // Skip if already loading or no more data
    if (value.isLoadingNext || !value.hasMore) {
      return;
    }

    // Set loading state while preserving data
    state = AsyncData(
      value.copyWith(
        loadNextStatus: LoadNextStatus.loading,
        loadNextError: null,
        loadNextStackTrace: null,
      ),
    );

    try {
      final next = await fetch(cursor: value.nextCursor);

      // Success: merge items and reset status
      state = AsyncData(
        value.copyWith(
          items: [...value.items, ...next.items],
          nextCursor: next.nextCursor,
          hasMore: next.hasMore,
          loadNextStatus: LoadNextStatus.idle,
        ),
      );
    } on Object catch (e, st) {
      // Error: preserve data and set error status
      state = AsyncData(
        value.copyWith(
          loadNextStatus: LoadNextStatus.error,
          loadNextError: e,
          loadNextStackTrace: st,
        ),
      );
    }
  }

  /// Discards the current state and force refreshes the data.
  @override
  void forceRefresh() {
    state = const AsyncLoading();
    ref.invalidateSelf();
  }
}
