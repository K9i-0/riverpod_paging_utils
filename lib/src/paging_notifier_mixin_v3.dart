import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';

/// Base interface for pagination notifier mixins with Riverpod 3.0 support.
///
/// This interface provides the common contract for all pagination implementations,
/// with improved support for Riverpod 3.0 features like ref.mounted checks.
@internal
abstract interface class PagingNotifierMixinV3<D extends PagingData<T>, T> {
  AsyncValue<D> get state;
  set state(AsyncValue<D> newState);
  Ref<AsyncValue<D>> get ref;

  Future<void> loadNext();
  void forceRefresh();
}

/// A mixin for page-based pagination using [PagePagingData] with Riverpod 3.0 support.
///
/// Use this mixin when using @riverpod with Riverpod 3.0
abstract mixin class PagePagingNotifierMixinV3<T>
    implements PagingNotifierMixinV3<PagePagingData<T>, T> {
  /// Fetches the paginated data for the specified [page].
  Future<PagePagingData<T>> fetch({required int page});

  /// Loads the next page of data with improved safety checks.
  @override
  Future<void> loadNext() async {
    final value = state.valueOrNull;
    if (value == null || !value.hasMore) {
      return;
    }

    // Check if already loading
    if (state.isLoading && state.hasValue) {
      return;
    }

    state = AsyncLoading<PagePagingData<T>>().copyWithPrevious(state);

    try {
      final next = await fetch(page: value.page + 1);
      
      // Check if the provider is still mounted (Riverpod 3.0 feature)
      if (!ref.mounted) return;
      
      state = AsyncData(value.copyWith(
        items: [...value.items, ...next.items],
        page: value.page + 1,
        hasMore: next.hasMore,
      ));
    } catch (error, stackTrace) {
      // Preserve previous data on error
      if (!ref.mounted) return;
      
      state = AsyncError<PagePagingData<T>>(error, stackTrace)
          .copyWithPrevious(state);
    }
  }

  /// Discards the current state and force refreshes the data.
  @override
  void forceRefresh() {
    state = const AsyncLoading<PagePagingData<Never>>();
    ref.invalidateSelf();
  }
}

/// A mixin for offset-based pagination using [OffsetPagingData] with Riverpod 3.0 support.
///
/// Use this mixin when using @riverpod with Riverpod 3.0
abstract mixin class OffsetPagingNotifierMixinV3<T>
    implements PagingNotifierMixinV3<OffsetPagingData<T>, T> {
  /// Fetches the paginated data for the specified [offset].
  Future<OffsetPagingData<T>> fetch({required int offset});

  /// Loads the next set of data based on the offset with improved safety checks.
  @override
  Future<void> loadNext() async {
    final value = state.valueOrNull;
    if (value == null || !value.hasMore) {
      return;
    }

    // Check if already loading
    if (state.isLoading && state.hasValue) {
      return;
    }

    state = AsyncLoading<OffsetPagingData<T>>().copyWithPrevious(state);

    try {
      final next = await fetch(offset: value.offset);
      
      // Check if the provider is still mounted (Riverpod 3.0 feature)
      if (!ref.mounted) return;
      
      state = AsyncData(value.copyWith(
        items: [...value.items, ...next.items],
        offset: next.offset,
        hasMore: next.hasMore,
      ));
    } catch (error, stackTrace) {
      // Preserve previous data on error
      if (!ref.mounted) return;
      
      state = AsyncError<OffsetPagingData<T>>(error, stackTrace)
          .copyWithPrevious(state);
    }
  }

  /// Discards the current state and force refreshes the data.
  @override
  void forceRefresh() {
    state = const AsyncLoading<OffsetPagingData<Never>>();
    ref.invalidateSelf();
  }
}

/// A mixin for cursor-based pagination using [CursorPagingData] with Riverpod 3.0 support.
///
/// Use this mixin when using @riverpod with Riverpod 3.0
abstract mixin class CursorPagingNotifierMixinV3<T>
    implements PagingNotifierMixinV3<CursorPagingData<T>, T> {
  /// Fetches the paginated data for the specified [cursor].
  Future<CursorPagingData<T>> fetch({required String? cursor});

  /// Loads the next set of data based on the cursor with improved safety checks.
  @override
  Future<void> loadNext() async {
    final value = state.valueOrNull;
    if (value == null || !value.hasMore) {
      return;
    }

    // Check if already loading
    if (state.isLoading && state.hasValue) {
      return;
    }

    state = AsyncLoading<CursorPagingData<T>>().copyWithPrevious(state);

    try {
      final next = await fetch(cursor: value.nextCursor);
      
      // Check if the provider is still mounted (Riverpod 3.0 feature)
      if (!ref.mounted) return;
      
      state = AsyncData(value.copyWith(
        items: [...value.items, ...next.items],
        nextCursor: next.nextCursor,
        hasMore: next.hasMore,
      ));
    } catch (error, stackTrace) {
      // Preserve previous data on error
      if (!ref.mounted) return;
      
      state = AsyncError<CursorPagingData<T>>(error, stackTrace)
          .copyWithPrevious(state);
    }
  }

  /// Discards the current state and force refreshes the data.
  @override
  void forceRefresh() {
    state = const AsyncLoading<CursorPagingData<Never>>();
    ref.invalidateSelf();
  }
}