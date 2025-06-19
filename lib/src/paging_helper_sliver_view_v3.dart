import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';
import 'package:riverpod_paging_utils/src/paging_helper_view_theme.dart';
import 'package:riverpod_paging_utils/src/paging_notifier_mixin_v3.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// A generic sliver widget for pagination with Riverpod 3.0 support.
///
/// This version includes improved safety checks and leverages Riverpod 3.0 features.
///
/// Use this widget in a CustomScrollView for more flexible layouts.
/// Unlike PagingHelperViewV3, this widget:
/// - Does not support RefreshIndicator (use CupertinoSliverRefreshControl instead)
/// - Wraps loading and error states with SliverFillRemaining
/// - Uses sliverLoadingViewBuilder and sliverErrorViewBuilder from the theme
///
/// All other behaviors are identical to PagingHelperViewV3.
final class PagingHelperSliverViewV3<D extends PagingData<I>, I>
    extends ConsumerWidget {
  const PagingHelperSliverViewV3({
    required this.provider,
    required this.futureRefreshable,
    required this.notifierRefreshable,
    required this.contentBuilder,
    this.showSecondPageError = true,
    super.key,
  });

  final ProviderListenable<AsyncValue<D>> provider;
  final Refreshable<Future<D>> futureRefreshable;
  final Refreshable<PagingNotifierMixinV3<D, I>> notifierRefreshable;

  /// Specifies a function that returns a sliver to display when data is available.
  /// endItemView is a widget to detect when the last displayed item is visible.
  /// If endItemView is non-null, it is displayed at the end of the list.
  final Widget Function(D data, int widgetCount, Widget endItemView)
      contentBuilder;

  final bool showSecondPageError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<PagingHelperViewTheme>();

    final loadingBuilder = theme?.sliverLoadingViewBuilder ??
        (context) => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
    final errorBuilder = theme?.sliverErrorViewBuilder ??
        (context, e, st, onPressed) => SliverFillRemaining(
              child: Center(
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
              ),
            );

    return ref.watch(provider).whenIgnorableError(
          data: (
            data, {
            required hasError,
            required isLoading,
            required error,
          }) {
            return contentBuilder(
              data,
              // Add 1 to the length to include the endItemView
              data.items.length + 1,
              switch ((data.hasMore, hasError, isLoading)) {
                // Display a widget to detect when the last element is reached
                // if there are more pages and no errors
                (true, false, _) => _EndVDLoadingItemViewV3(
                    onScrollEnd: () async {
                      // Safety check before calling async operation
                      if (ref.mounted) {
                        await ref.read(notifierRefreshable).loadNext();
                      }
                    },
                  ),
                (true, true, false) when showSecondPageError =>
                  _EndErrorItemViewV3(
                    error: error,
                    onRetryButtonPressed: () async {
                      // Safety check before calling async operation
                      if (ref.mounted) {
                        await ref.read(notifierRefreshable).loadNext();
                      }
                    },
                  ),
                (true, true, true) => const _EndLoadingItemViewV3(),
                _ => const SizedBox.shrink(),
              },
            );
          },
          loading: () => loadingBuilder(context),
          error: (e, st) => errorBuilder(
            context,
            e,
            st,
            () {
              if (ref.mounted) {
                ref.invalidate(provider);
              }
            },
          ),
        );
  }
}

final class _EndVDLoadingItemViewV3 extends StatefulWidget {
  const _EndVDLoadingItemViewV3({
    required this.onScrollEnd,
  });

  final Future<void> Function() onScrollEnd;

  @override
  State<_EndVDLoadingItemViewV3> createState() =>
      _EndVDLoadingItemViewV3State();
}

final class _EndVDLoadingItemViewV3State
    extends State<_EndVDLoadingItemViewV3> {
  var isLoadingNextPage = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('EndVDLoadingItemViewV3'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0 && !isLoadingNextPage) {
          isLoadingNextPage = true;
          widget.onScrollEnd();
        }
      },
      child: const _EndLoadingItemViewV3(),
    );
  }
}

final class _EndLoadingItemViewV3 extends StatelessWidget {
  const _EndLoadingItemViewV3();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<PagingHelperViewTheme>();
    final endItemBuilder = theme?.endLoadingItemViewBuilder ??
        (context) => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

    return endItemBuilder(context);
  }
}

final class _EndErrorItemViewV3 extends StatelessWidget {
  const _EndErrorItemViewV3({
    required this.error,
    required this.onRetryButtonPressed,
  });

  final Object error;
  final void Function() onRetryButtonPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<PagingHelperViewTheme>();

    final endErrorItemBuilder = theme?.endErrorItemViewBuilder ??
        (
          context,
          error,
          onRetryButtonPressed,
        ) =>
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(error.toString()),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: onRetryButtonPressed,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );

    return endErrorItemBuilder(context, error, onRetryButtonPressed);
  }
}

// Extension to handle AsyncValue with data and error states
extension _AsyncValueIgnorableErrorExtensionV3 on AsyncValue<T> {
  R whenIgnorableError<R>({
    required R Function(
      T data, {
      required bool hasError,
      required bool isLoading,
      required Object error,
    })
        data,
    required R Function() loading,
    required R Function(Object error, StackTrace stackTrace) error,
  }) {
    if (hasValue) {
      final hasError = this.hasError;
      final errorValue = hasError ? this.error! : null;
      return data(
        requireValue,
        hasError: hasError,
        isLoading: isLoading,
        error: errorValue ?? '',
      );
    }

    return when(
      data: (d) => data(
        d,
        hasError: false,
        isLoading: false,
        error: '',
      ),
      error: error,
      loading: loading,
    );
  }
}