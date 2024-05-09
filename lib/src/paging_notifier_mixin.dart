import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_paging_utils/src/async_notifier_x.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';

mixin PageBasedPagingNotifierMixin<T>
    on AutoDisposeAsyncNotifier<PageBasedPagingData<T>> {
  Future<PageBasedPagingData<T>> fetch({required int page});

  Future<void> loadNext() async {
    final value = state.valueOrNull;
    if (value == null || state.hasError) {
      return;
    }

    if (value.hasMore) {
      state = AsyncLoading<PageBasedPagingData<T>>().copyWithPrevious(state);

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

  /// 状態を破棄して再読み込みする
  void forceRefresh() {
    state = AsyncLoading<PageBasedPagingData<T>>();
    ref.invalidateSelf();
  }
}

mixin OffsetBasedPagingNotifierMixin<T>
    on AutoDisposeAsyncNotifier<OffsetBasedPagingData<T>> {
  Future<OffsetBasedPagingData<T>> fetch({required int offset});

  Future<void> loadNext() async {
    final value = state.valueOrNull;
    if (value == null || state.hasError) {
      return;
    }

    if (value.hasMore) {
      state = AsyncLoading<OffsetBasedPagingData<T>>().copyWithPrevious(state);

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

  /// 状態を破棄して再読み込みする
  void forceRefresh() {
    state = AsyncLoading<OffsetBasedPagingData<T>>();
    ref.invalidateSelf();
  }
}

mixin CursorBasedPagingNotifierMixin<T>
    on AutoDisposeAsyncNotifier<CursorBasedPagingData<T>> {
  Future<CursorBasedPagingData<T>> fetch({required String? cursor});

  Future<void> loadNext() async {
    final value = state.valueOrNull;
    if (value == null || state.hasError) {
      return;
    }

    if (value.hasMore) {
      state = AsyncLoading<CursorBasedPagingData<T>>().copyWithPrevious(state);

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

  /// 状態を破棄して再読み込みする
  void forceRefresh() {
    state = AsyncLoading<CursorBasedPagingData<T>>();
    ref.invalidateSelf();
  }
}
