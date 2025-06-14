import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_paging_utils/src/paging_helper_view_theme.dart';

void main() {
  group('PagingHelperViewTheme', () {
    test('should create with all properties', () {
      Widget loadingBuilder(BuildContext context) => const Text('Loading');
      Widget errorBuilder(
        BuildContext context,
        Object error,
        StackTrace stackTrace,
        VoidCallback onRefresh,
      ) =>
          const Text('Error');
      Widget endLoadingBuilder(BuildContext context) =>
          const Text('End Loading');
      Widget endErrorBuilder(
        BuildContext context,
        Object? error,
        VoidCallback onRetry,
      ) =>
          const Text('End Error');

      final theme = PagingHelperViewTheme(
        loadingViewBuilder: loadingBuilder,
        errorViewBuilder: errorBuilder,
        endLoadingViewBuilder: endLoadingBuilder,
        endErrorViewBuilder: endErrorBuilder,
        enableRefreshIndicator: false,
      );

      expect(theme.loadingViewBuilder, equals(loadingBuilder));
      expect(theme.errorViewBuilder, equals(errorBuilder));
      expect(theme.endLoadingViewBuilder, equals(endLoadingBuilder));
      expect(theme.endErrorViewBuilder, equals(endErrorBuilder));
      expect(theme.enableRefreshIndicator, isFalse);
    });

    test('should create with partial properties', () {
      Widget loadingBuilder(BuildContext context) => const Text('Loading');

      final theme = PagingHelperViewTheme(
        loadingViewBuilder: loadingBuilder,
      );

      expect(theme.loadingViewBuilder, equals(loadingBuilder));
      expect(theme.errorViewBuilder, isNull);
      expect(theme.endLoadingViewBuilder, isNull);
      expect(theme.endErrorViewBuilder, isNull);
      expect(theme.enableRefreshIndicator, isNull);
    });

    test('copyWith should update specified properties', () {
      Widget loadingBuilder1(BuildContext context) => const Text('Loading 1');
      Widget loadingBuilder2(BuildContext context) => const Text('Loading 2');
      Widget errorBuilder(
        BuildContext context,
        Object error,
        StackTrace stackTrace,
        VoidCallback onRefresh,
      ) =>
          const Text('Error');

      final originalTheme = PagingHelperViewTheme(
        loadingViewBuilder: loadingBuilder1,
        enableRefreshIndicator: true,
      );

      final updatedTheme = originalTheme.copyWith(
        loadingViewBuilder: loadingBuilder2,
        errorViewBuilder: errorBuilder,
      ) as PagingHelperViewTheme;

      expect(updatedTheme.loadingViewBuilder, equals(loadingBuilder2));
      expect(updatedTheme.errorViewBuilder, equals(errorBuilder));
      expect(updatedTheme.enableRefreshIndicator, isTrue);
    });

    test('copyWith with no parameters should preserve existing values', () {
      Widget loadingBuilder(BuildContext context) => const Text('Loading');

      final theme = PagingHelperViewTheme(
        loadingViewBuilder: loadingBuilder,
        enableRefreshIndicator: false,
      );

      final copiedTheme = theme.copyWith() as PagingHelperViewTheme;

      // Note: copyWith preserves existing values when no parameters are passed
      expect(copiedTheme.loadingViewBuilder, equals(loadingBuilder));
      expect(copiedTheme.enableRefreshIndicator, isFalse);
    });

    test('lerp should return the same instance', () {
      final theme1 = PagingHelperViewTheme(
        enableRefreshIndicator: true,
      );

      final theme2 = PagingHelperViewTheme(
        enableRefreshIndicator: false,
      );

      final lerpedTheme = theme1.lerp(theme2, 0.5) as PagingHelperViewTheme;

      // The implementation always returns 'this'
      expect(lerpedTheme, same(theme1));
      expect(lerpedTheme.enableRefreshIndicator, isTrue);
    });

    test('lerp with null other should return the same instance', () {
      final theme = PagingHelperViewTheme(
        enableRefreshIndicator: true,
      );

      final lerpedTheme = theme.lerp(null, 0.5) as PagingHelperViewTheme;

      expect(lerpedTheme, same(theme));
    });
  });

  group('PagingHelperViewTheme as ThemeExtension', () {
    testWidgets('should be accessible from Theme', (tester) async {
      Widget loadingBuilder(BuildContext context) =>
          const Text('Custom Loading');

      final theme = PagingHelperViewTheme(
        loadingViewBuilder: loadingBuilder,
        enableRefreshIndicator: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [theme],
          ),
          home: Builder(
            builder: (context) {
              final themeFromContext =
                  Theme.of(context).extension<PagingHelperViewTheme>();

              expect(themeFromContext, isNotNull);
              expect(
                themeFromContext?.loadingViewBuilder,
                equals(loadingBuilder),
              );
              expect(themeFromContext?.enableRefreshIndicator, isFalse);

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should return null when not provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(),
          home: Builder(
            builder: (context) {
              final themeFromContext =
                  Theme.of(context).extension<PagingHelperViewTheme>();

              expect(themeFromContext, isNull);

              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
