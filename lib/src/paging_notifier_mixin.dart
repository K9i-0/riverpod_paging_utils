import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_paging_utils/src/async_notifier_x.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';

mixin PagePagingNotifierMixin<T>
    on AutoDisposeAsyncNotifier<PagePagingData<T>> {
  Future<PagePagingData<T>> fetch({required int page});

  Future<void> loadNext() async {
    final value = state.valueOrNull;
    if (value == null || state.hasError) {
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

  /// 状態を破棄して再読み込みする
  void forceRefresh() {
    state = AsyncLoading<PagePagingData<T>>();
    ref.invalidateSelf();
  }
}

mixin OffsetPagingNotifierMixin<T>
    on AutoDisposeAsyncNotifier<OffsetPagingData<T>> {
  Future<OffsetPagingData<T>> fetch({required int offset});

  Future<void> loadNext() async {
    final value = state.valueOrNull;
    if (value == null || state.hasError) {
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

  /// 状態を破棄して再読み込みする
  void forceRefresh() {
    state = AsyncLoading<OffsetPagingData<T>>();
    ref.invalidateSelf();
  }
}

mixin CursorPagingNotifierMixin<T>
    on AutoDisposeAsyncNotifier<CursorPagingData<T>> {
  Future<CursorPagingData<T>> fetch({required String? cursor});

  Future<void> loadNext() async {
    final value = state.valueOrNull;
    if (value == null || state.hasError) {
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

  /// 状態を破棄して再読み込みする
  void forceRefresh() {
    state = AsyncLoading<CursorPagingData<T>>();
    ref.invalidateSelf();
  }
}
