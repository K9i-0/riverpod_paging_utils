import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_paging_utils/src/async_notifier_x.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';
import 'package:riverpod_paging_utils/src/paging_notifier_mixin.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// ページングのための汎用Widget
///
/// 主な機能
/// 1. データがある場合は、[contentBuilder]で作ったWidgetを表示する
/// 2. 1ページの読み込み中は、CircularProgressIndicatorを表示する
/// 3. 1ページ目のエラー時は、エラーWidgetを表示する
/// 4. エラー時にスナックバーでエラーを表示する
/// 5. 最後のアイテムが表示されたら、次のページを読み込む
/// 6. Pull to Refreshに対応する
class CommonPagingView<N extends AutoDisposeAsyncNotifier<D>,
    D extends PagingData<I>, I> extends ConsumerWidget {
  const CommonPagingView({
    required this.provider,
    required this.contentBuilder,
    super.key,
  });

  /// [AutoDisposeAsyncNotifier]を実装したクラスのProviderを指定する
  final AutoDisposeAsyncNotifierProvider<N, D> provider;

  /// データがある場合に表示するWidgetを返す関数を指定する
  /// [endItem]は最後に表示されたアイテムが表示されたことを検知するためのWidgetで、non nullの時にリストの最後に表示する
  final Widget Function(D data, Widget? endItemView) contentBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // genericsでMixinの制約ができなそうだったので
    assert(
      ref.read(provider.notifier) is PageBasedPagingNotifierMixin ||
          ref.read(provider.notifier) is OffsetBasedPagingNotifierMixin ||
          ref.read(provider.notifier) is CursorBasedPagingNotifierMixin,
    );

    // スナックバーによるエラー表示
    ref.listen(provider, (_, state) {
      if (!state.isLoading && state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.error!.toString(),
            ),
          ),
        );
      }
    });

    return ref.watch(provider).whenIgnorableError(
          data: (data, {required hasError}) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(provider.future),
              child: contentBuilder(
                data,
                // 次のページがあり、かつエラーがない場合に、最後の要素に達したことを検知するためのWidgetを表示する
                data.hasMore && !hasError
                    ? _EndItemView(
                        onScrollEnd: () {
                          switch (ref.read(provider.notifier)) {
                            case (final PageBasedPagingNotifierMixin
                                  pageNotifier):
                              pageNotifier.loadNext();
                            case (final OffsetBasedPagingNotifierMixin
                                  offsetNotifier):
                              offsetNotifier.loadNext();
                            case (final CursorBasedPagingNotifierMixin
                                  cursorNotifier):
                              cursorNotifier.loadNext();
                          }
                        },
                      )
                    : null,
              ),
            );
          },
          // TODO(K9i-0): loading、errorはTheme Extensionで設定できると良さそう
          // １ページ目のロード中
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          // １ページ目のエラー
          error: (e, st) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    switch (ref.read(provider.notifier)) {
                      case (final PageBasedPagingNotifierMixin pageNotifier):
                        pageNotifier.forceRefresh();
                      case (final OffsetBasedPagingNotifierMixin
                            offsetNotifier):
                        offsetNotifier.forceRefresh();
                      case (final CursorBasedPagingNotifierMixin
                            cursorNotifier):
                        cursorNotifier.forceRefresh();
                    }
                  },
                  icon: const Icon(Icons.refresh),
                ),
                Text(e.toString()),
              ],
            ),
          ),
          // 2ページ目以降のエラーでデータを優先する
          skipErrorOnHasValue: true,
        );
  }
}

class _EndItemView extends StatelessWidget {
  const _EndItemView({
    required this.onScrollEnd,
  });
  final VoidCallback onScrollEnd;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: key ?? const Key('EndItem'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1) {
          onScrollEnd();
        }
      },
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
