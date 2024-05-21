import 'package:flutter/material.dart';

typedef ErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace stackTrace,
  VoidCallback onRefreshButtonPressed,
);

/// A theme for [PagingHelperView].
/// This is used to configure the default appearance of [PagingHelperView].
///
/// [loadingViewBuilder] is used to build the loading view.
/// [errorViewBuilder] is used to build the error view.
/// [endItemViewChildViewBuilder] is used to build the ui of endItemView.
class PagingHelperViewTheme extends ThemeExtension<PagingHelperViewTheme> {
  PagingHelperViewTheme({
    this.loadingViewBuilder,
    this.errorViewBuilder,
    this.endItemViewChildViewBuilder,
  });
  final WidgetBuilder? loadingViewBuilder;
  final ErrorWidgetBuilder? errorViewBuilder;
  final WidgetBuilder? endItemViewChildViewBuilder;

  @override
  ThemeExtension<PagingHelperViewTheme> copyWith({
    WidgetBuilder? loadingViewBuilder,
    ErrorWidgetBuilder? errorViewBuilder,
    WidgetBuilder? endItemViewChildViewBuilder,
  }) {
    return PagingHelperViewTheme(
      loadingViewBuilder: loadingViewBuilder ?? loadingViewBuilder,
      errorViewBuilder: errorViewBuilder ?? this.errorViewBuilder,
      endItemViewChildViewBuilder:
          endItemViewChildViewBuilder ?? this.endItemViewChildViewBuilder,
    );
  }

  @override
  ThemeExtension<PagingHelperViewTheme> lerp(
      covariant ThemeExtension<PagingHelperViewTheme>? other, double t) {
    return this;
  }
}
