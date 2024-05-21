import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';
import 'package:riverpod_paging_utils/src/paging_helper_view_theme.dart';
import 'package:riverpod_paging_utils/src/paging_notifier_mixin.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// A generic widget for pagination.
///
/// Main features:
/// 1. Displays the widget created by [contentBuilder] when data is available.
/// 2. Shows a CircularProgressIndicator while loading the first page.
/// 3. Displays an error widget when there is an error on the first page.
/// 4. Shows error messages using a SnackBar.
/// 5. Loads the next page when the last item is displayed.
/// 6. Supports pull-to-refresh functionality.
///
/// You can customize the appearance of the loading view, error view, and endItemView using [PagingHelperViewTheme].
class PagingHelperView<N extends AutoDisposeAsyncNotifier<D>,
    D extends PagingData<I>, I> extends ConsumerWidget {
  const PagingHelperView({
    required this.provider,
    required this.contentBuilder,
    super.key,
  });

  /// Specifies the provider of a class that implements [AutoDisposeAsyncNotifier].
  final AutoDisposeAsyncNotifierProvider<N, D> provider;

  /// Specifies a function that returns a widget to display when data is available.
  /// [endItem] is a widget to detect when the last displayed item is visible.
  /// If [endItem] is non-null, it is displayed at the end of the list.
  final Widget Function(D data, Widget? endItemView) contentBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assertion since generics cannot constrain mixins
    assert(
      ref.read(provider.notifier) is PagePagingNotifierMixin ||
          ref.read(provider.notifier) is OffsetPagingNotifierMixin ||
          ref.read(provider.notifier) is CursorPagingNotifierMixin,
      'The notifier must implement PagePagingNotifierMixin, OffsetPagingNotifierMixin, or CursorPagingNotifierMixin',
    );

    // Display errors using SnackBar
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

    final theme = Theme.of(context).extension<PagingHelperViewTheme>();
    final loadingBuilder = theme?.loadingViewBuilder ??
        (context) => const Center(
              child: CircularProgressIndicator(),
            );
    final errorBuilder = theme?.errorViewBuilder ??
        (context, e, st, onPressed) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onPressed,
                    icon: const Icon(Icons.refresh),
                  ),
                  Text(e.toString()),
                ],
              ),
            );

    return ref.watch(provider).whenIgnorableError(
          data: (data, {required hasError}) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(provider.future),
              child: contentBuilder(
                data,
                // Display a widget to detect when the last element is reached
                // if there are more pages and no errors
                data.hasMore && !hasError
                    ? _EndItemView(
                        onScrollEnd: () {
                          switch (ref.read(provider.notifier)) {
                            case (final PagePagingNotifierMixin pageNotifier):
                              pageNotifier.loadNext();
                            case (final OffsetPagingNotifierMixin
                                  offsetNotifier):
                              offsetNotifier.loadNext();
                            case (final CursorPagingNotifierMixin
                                  cursorNotifier):
                              cursorNotifier.loadNext();
                          }
                        },
                      )
                    : null,
              ),
            );
          },
          // Loading state for the first page
          loading: () => loadingBuilder(context),
          // Error state for the first page
          error: (e, st) => errorBuilder(
            context,
            e,
            st,
            () {
              switch (ref.read(provider.notifier)) {
                case (final PagePagingNotifierMixin pageNotifier):
                  pageNotifier.forceRefresh();
                case (final OffsetPagingNotifierMixin offsetNotifier):
                  offsetNotifier.forceRefresh();
                case (final CursorPagingNotifierMixin cursorNotifier):
                  cursorNotifier.forceRefresh();
              }
            },
          ),
          // Prioritize data for errors on the second page and beyond
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
    final theme = Theme.of(context).extension<PagingHelperViewTheme>();
    final childBuilder = theme?.endItemViewChildViewBuilder ??
        (context) => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );

    return VisibilityDetector(
      key: key ?? const Key('EndItem'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1) {
          onScrollEnd();
        }
      },
      child: childBuilder(context),
    );
  }
}

extension _AsyncValueX<T> on AsyncValue<T> {
  /// Extends the [when] method to handle async data states more effectively,
  /// especially when maintaining data integrity despite errors.
  ///
  /// Use `skipErrorOnHasValue` to retain and display existing data
  /// even if subsequent fetch attempts result in errors,
  /// ideal for maintaining a seamless user experience.
  R whenIgnorableError<R>({
    required R Function(T data, {required bool hasError}) data,
    required R Function(Object error, StackTrace stackTrace) error,
    required R Function() loading,
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    bool skipErrorOnHasValue = false,
  }) {
    if (skipErrorOnHasValue) {
      if (hasValue && hasError) {
        return data(requireValue, hasError: true);
      }
    }

    return when(
      skipLoadingOnReload: skipLoadingOnReload,
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipError: skipError,
      data: (d) => data(d, hasError: hasError),
      error: error,
      loading: loading,
    );
  }
}
