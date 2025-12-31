import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart'
    show ProviderListenable, Refreshable;
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
/// 4. Shows error messages inline when loading subsequent pages.
/// 5. Loads the next page when the last item is displayed.
/// 6. Supports pull-to-refresh functionality.
///
/// You can customize the appearance of the loading view, error view, and endItemView using [PagingHelperViewTheme].
final class PagingHelperView<D extends PagingData<I>, I>
    extends ConsumerWidget {
  const PagingHelperView({
    required this.provider,
    required this.futureRefreshable,
    required this.notifierRefreshable,
    required this.contentBuilder,
    super.key,
  });

  final ProviderListenable<AsyncValue<D>> provider;
  final Refreshable<Future<D>> futureRefreshable;
  final Refreshable<PagingNotifierMixin<D, I>> notifierRefreshable;

  /// Specifies a function that returns a widget to display when data is available.
  /// endItemView is a widget to detect when the last displayed item is visible.
  /// If endItemView is non-null, it is displayed at the end of the list.
  final Widget Function(D data, int widgetCount, Widget endItemView)
      contentBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return ref.watch(provider).when(
          data: (data) {
            final content = contentBuilder(
              data,
              // Add 1 to the length to include the endItemView
              data.items.length + 1,
              _buildEndItemView(context, ref, data, theme),
            );

            final enableRefreshIndicator =
                theme?.enableRefreshIndicator ?? true;

            if (enableRefreshIndicator) {
              return RefreshIndicator(
                onRefresh: () => ref.refresh(futureRefreshable),
                child: content,
              );
            } else {
              return content;
            }
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
        );
  }

  /// Builds the end item view based on the current state.
  Widget _buildEndItemView(
    BuildContext context,
    WidgetRef ref,
    D data,
    PagingHelperViewTheme? theme,
  ) {
    // No more data to load
    if (!data.hasMore) {
      return const SizedBox.shrink();
    }

    final showSecondPageError = theme?.showSecondPageError ?? true;

    // Build widget based on loadNextStatus
    return switch (data.loadNextStatus) {
      // Idle: show visibility detector to trigger loading
      LoadNextStatus.idle => _EndVDLoadingItemView(
          onScrollEnd: () => ref.read(notifierRefreshable).loadNext(),
        ),
      // Loading: show loading indicator
      LoadNextStatus.loading => const _EndLoadingItemView(),
      // Error: show error with retry button (or hide if showSecondPageError is false)
      LoadNextStatus.error => showSecondPageError
          ? _EndErrorItemView(
              error: data.loadNextError,
              onRetryButtonPressed: () =>
                  ref.read(notifierRefreshable).loadNext(),
            )
          : const SizedBox.shrink(),
    };
  }
}

final class _EndLoadingItemView extends StatelessWidget {
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

final class _EndVDLoadingItemView extends StatelessWidget {
  const _EndVDLoadingItemView({
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
      child: const _EndLoadingItemView(),
    );
  }
}

final class _EndErrorItemView extends StatelessWidget {
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
