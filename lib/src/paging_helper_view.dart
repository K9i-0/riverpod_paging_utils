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
class PagingHelperView<D extends PagingData<I>, I> extends ConsumerWidget {
  const PagingHelperView({
    required this.provider,
    required this.futureRefreshable,
    required this.notifierRefreshable,
    required this.contentBuilder,
    this.showSecondPageError = true,
    super.key,
  });

  final ProviderListenable<AsyncValue<D>> provider;
  final Refreshable<Future<D>> futureRefreshable;
  final Refreshable<PagingNotifierMixin<D, I>> notifierRefreshable;

  /// Specifies a function that returns a widget to display when data is available.
  /// [endItem] is a widget to detect when the last displayed item is visible.
  /// If [endItem] is non-null, it is displayed at the end of the list.
  final Widget Function(D data, Widget? endItemView) contentBuilder;

  final bool showSecondPageError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          data: (data,
              {required hasError, required isLoading, required error}) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(futureRefreshable),
              child: contentBuilder(
                  data,
                  switch ((data.hasMore, hasError, isLoading)) {
                    // Display a widget to detect when the last element is reached
                    // if there are more pages and no errors
                    (true, false, _) => _EndVisibilityDetectorLoadingItemView(
                        onScrollEnd: () =>
                            ref.read(notifierRefreshable).loadNext(),
                      ),
                    (true, true, false) when showSecondPageError =>
                      _EndErrorItemView(
                        error: error,
                        onRetryButtonPressed: () =>
                            ref.read(notifierRefreshable).loadNext(),
                      ),
                    (true, true, true) => const _EndLoadingItemView(),
                    _ => null,
                  }),
            );
          },
          // Loading state for the first page
          loading: () => loadingBuilder(context),
          // Error state for the first page
          error: (e, st) => errorBuilder(
            context,
            e,
            st,
            () => ref.read(notifierRefreshable).forceRefresh(),
          ),
          // Prioritize data for errors on the second page and beyond
          skipErrorOnHasValue: true,
        );
  }
}

class _EndVisibilityDetectorLoadingItemView extends StatelessWidget {
  const _EndVisibilityDetectorLoadingItemView({
    required this.onScrollEnd,
  });
  final VoidCallback onScrollEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<PagingHelperViewTheme>();
    final childBuilder = theme?.endLoadingViewBuilder ??
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

class _EndLoadingItemView extends StatelessWidget {
  const _EndLoadingItemView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<PagingHelperViewTheme>();
    final childBuilder = theme?.endLoadingViewBuilder ??
        (context) => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );

    return childBuilder(context);
  }
}

class _EndErrorItemView extends StatelessWidget {
  const _EndErrorItemView({
    required this.error,
    required this.onRetryButtonPressed,
  });
  final Object? error;
  final VoidCallback onRetryButtonPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<PagingHelperViewTheme>();
    final childBuilder = theme?.endErrorViewBuilder ??
        (context, e, onPressed) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: onPressed,
                      icon: const Icon(Icons.refresh),
                    ),
                    Text(
                      error.toString(),
                    ),
                  ],
                ),
              ),
            );

    return childBuilder(context, error, onRetryButtonPressed);
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
    required R Function(T data,
            {required bool hasError,
            required bool isLoading,
            required Object? error})
        data,
    required R Function(Object error, StackTrace stackTrace) error,
    required R Function() loading,
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    bool skipErrorOnHasValue = false,
  }) {
    if (skipErrorOnHasValue) {
      if (hasValue && hasError) {
        return data(requireValue,
            hasError: true, isLoading: isLoading, error: this.error);
      }
    }

    return when(
      skipLoadingOnReload: skipLoadingOnReload,
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipError: skipError,
      data: (d) =>
          data(d, hasError: hasError, isLoading: isLoading, error: this.error),
      error: error,
      loading: loading,
    );
  }
}
