import 'package:flutter/material.dart';
import 'package:riverpod_paging_utils/riverpod_paging_utils.dart';

typedef ErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace stackTrace,
  VoidCallback onRefreshButtonPressed,
);

typedef EndErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Object? error,
  VoidCallback onRetryButtonPressed,
);

/// A theme for [PagingHelperView] and [PagingHelperSliverView].
/// This is used to configure the default appearance of [PagingHelperView] and [PagingHelperSliverView].
///
/// [loadingViewBuilder] is used to build the loading view.
/// [errorViewBuilder] is used to build the error view.
/// [endLoadingViewBuilder] is used to build the ui of endItemView.
/// [endErrorViewBuilder] is used to build the ui of endItemView when an error occurs.
/// [enableRefreshIndicator] is used to enable or disable the pull-to-refresh functionality.
/// [sliverLoadingViewBuilder] is used to build the loading view for sliver widgets.
/// [sliverErrorViewBuilder] is used to build the error view for sliver widgets.
final class PagingHelperViewTheme
    extends ThemeExtension<PagingHelperViewTheme> {
  PagingHelperViewTheme({
    this.loadingViewBuilder,
    this.errorViewBuilder,
    this.endLoadingViewBuilder,
    this.endErrorViewBuilder,
    this.enableRefreshIndicator,
    this.sliverLoadingViewBuilder,
    this.sliverErrorViewBuilder,
  });
  final WidgetBuilder? loadingViewBuilder;
  final ErrorWidgetBuilder? errorViewBuilder;
  final WidgetBuilder? endLoadingViewBuilder;
  final EndErrorWidgetBuilder? endErrorViewBuilder;
  final bool? enableRefreshIndicator;
  final WidgetBuilder? sliverLoadingViewBuilder;
  final ErrorWidgetBuilder? sliverErrorViewBuilder;

  @override
  ThemeExtension<PagingHelperViewTheme> copyWith({
    WidgetBuilder? loadingViewBuilder,
    ErrorWidgetBuilder? errorViewBuilder,
    WidgetBuilder? endLoadingViewBuilder,
    EndErrorWidgetBuilder? endErrorViewBuilder,
    bool? enableRefreshIndicator,
    WidgetBuilder? sliverLoadingViewBuilder,
    ErrorWidgetBuilder? sliverErrorViewBuilder,
  }) {
    return PagingHelperViewTheme(
      loadingViewBuilder: loadingViewBuilder ?? this.loadingViewBuilder,
      errorViewBuilder: errorViewBuilder ?? this.errorViewBuilder,
      endLoadingViewBuilder:
          endLoadingViewBuilder ?? this.endLoadingViewBuilder,
      endErrorViewBuilder: endErrorViewBuilder ?? this.endErrorViewBuilder,
      enableRefreshIndicator:
          enableRefreshIndicator ?? this.enableRefreshIndicator,
      sliverLoadingViewBuilder:
          sliverLoadingViewBuilder ?? this.sliverLoadingViewBuilder,
      sliverErrorViewBuilder:
          sliverErrorViewBuilder ?? this.sliverErrorViewBuilder,
    );
  }

  @override
  ThemeExtension<PagingHelperViewTheme> lerp(
    covariant ThemeExtension<PagingHelperViewTheme>? other,
    double t,
  ) {
    return this;
  }
}
