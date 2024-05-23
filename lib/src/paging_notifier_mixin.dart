import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';

/// A mixin for page-based pagination using [PagePagingData].
mixin PagePagingNotifierMixin<T>
    on AutoDisposeAsyncNotifier<PagePagingData<T>> {
  /// Fetches the paginated data for the specified [page].
  Future<PagePagingData<T>> fetch({required int page});

  /// Loads the next page of data.
  Future<void> loadNext() async {
    final value = state.valueOrNull;
    if (value == null) {
      return;
    }

    if (value.hasMore) {
      state = AsyncLoading<PagePagingData<T>>().copyWithPrevious(state);

      state = await state.guardPreservingPreviousOnError(
        () async {
          final next = await fetch(page: value.page + 1);

          return value.copyWith(
            items: [...value.items, ...next.items],
            page: value.page + 1,
            hasMore: next.hasMore,
          );
        },
      );
    }
  }

  /// Discards the current state and force refreshes the data.
  void forceRefresh() {
    state = AsyncLoading<PagePagingData<T>>();
    ref.invalidateSelf();
  }
}

/// A mixin for offset-based pagination using [OffsetPagingData].
mixin OffsetPagingNotifierMixin<T>
    on AutoDisposeAsyncNotifier<OffsetPagingData<T>> {
  /// Fetches the paginated data for the specified [offset].
  Future<OffsetPagingData<T>> fetch({required int offset});

  /// Loads the next set of data based on the offset.
  Future<void> loadNext() async {
    final value = state.valueOrNull;
    if (value == null) {
      return;
    }

    if (value.hasMore) {
      state = AsyncLoading<OffsetPagingData<T>>().copyWithPrevious(state);

      state = await state.guardPreservingPreviousOnError(
        () async {
          final next = await fetch(offset: value.offset);

          return value.copyWith(
            items: [...value.items, ...next.items],
            offset: next.offset,
            hasMore: next.hasMore,
          );
        },
      );
    }
  }

  /// Discards the current state and force refreshes the data.
  void forceRefresh() {
    state = AsyncLoading<OffsetPagingData<T>>();
    ref.invalidateSelf();
  }
}

/// A mixin for cursor-based pagination using [CursorPagingData].
mixin CursorPagingNotifierMixin<T>
    on AutoDisposeAsyncNotifier<CursorPagingData<T>> {
  /// Fetches the paginated data for the specified [cursor].
  Future<CursorPagingData<T>> fetch({required String? cursor});

  /// Loads the next set of data based on the cursor.
  Future<void> loadNext() async {
    final value = state.valueOrNull;
    if (value == null) {
      return;
    }

    if (value.hasMore) {
      state = AsyncLoading<CursorPagingData<T>>().copyWithPrevious(state);

      state = await state.guardPreservingPreviousOnError(
        () async {
          final next = await fetch(cursor: value.nextCursor);

          return value.copyWith(
            items: [...value.items, ...next.items],
            nextCursor: next.nextCursor,
            hasMore: next.hasMore,
          );
        },
      );
    }
  }

  /// Discards the current state and force refreshes the data.
  void forceRefresh() {
    state = AsyncLoading<CursorPagingData<T>>();
    ref.invalidateSelf();
  }
}

extension _AsyncValueX<T> on AsyncValue<T> {
  /// Executes a future and returns its result as an [AsyncValue.data]. Captures
  /// exceptions, preserving the previous state as [AsyncValue.error].
  Future<AsyncValue<T>> guardPreservingPreviousOnError(
    Future<T> Function() future,
  ) async {
    try {
      return AsyncValue.data(await future());
    } on Exception catch (err, stack) {
      return AsyncValue<T>.error(err, stack).copyWithPrevious(this);
    }
  }
}
