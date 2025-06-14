import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_paging_utils/src/paging_data.dart';
import 'package:riverpod_paging_utils/src/paging_helper_view.dart';
import 'package:riverpod_paging_utils/src/paging_helper_view_theme.dart';
import 'package:riverpod_paging_utils/src/paging_notifier_mixin.dart';

// Test notifier for widget tests
class TestPagingNotifier extends AutoDisposeAsyncNotifier<PagePagingData<String>>
    with PagePagingNotifierMixin<String> {
  @override
  Future<PagePagingData<String>> build() async {
    return fetch(page: 0);
  }

  @override
  Future<PagePagingData<String>> fetch({required int page}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (page == 0) {
      return const PagePagingData(
        items: ['Item 1', 'Item 2', 'Item 3'],
        page: 0,
        hasMore: true,
      );
    } else if (page == 1) {
      return const PagePagingData(
        items: ['Item 4', 'Item 5', 'Item 6'],
        page: 1,
        hasMore: false,
      );
    }
    return PagePagingData(
      items: [],
      page: page,
      hasMore: false,
    );
  }
}

// Test notifier that throws error on first page
class TestErrorPagingNotifier extends AutoDisposeAsyncNotifier<PagePagingData<String>>
    with PagePagingNotifierMixin<String> {
  @override
  Future<PagePagingData<String>> build() async {
    return fetch(page: 0);
  }

  @override
  Future<PagePagingData<String>> fetch({required int page}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (page == 0) {
      throw Exception('Network error');
    }
    return PagePagingData(
      items: ['Item 1'],
      page: page,
      hasMore: false,
    );
  }
}

// Test notifier that throws error on second page
class TestSecondPageErrorNotifier extends AutoDisposeAsyncNotifier<PagePagingData<String>>
    with PagePagingNotifierMixin<String> {
  @override
  Future<PagePagingData<String>> build() async {
    return fetch(page: 0);
  }

  @override
  Future<PagePagingData<String>> fetch({required int page}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (page == 0) {
      return const PagePagingData(
        items: ['Item 1', 'Item 2', 'Item 3'],
        page: 0,
        hasMore: true,
      );
    } else {
      throw Exception('Second page error');
    }
  }
}

final testPagingProvider = AutoDisposeAsyncNotifierProvider<
    TestPagingNotifier, PagePagingData<String>>(() {
  return TestPagingNotifier();
});

final testErrorPagingProvider = AutoDisposeAsyncNotifierProvider<
    TestErrorPagingNotifier, PagePagingData<String>>(() {
  return TestErrorPagingNotifier();
});

final testSecondPageErrorProvider = AutoDisposeAsyncNotifierProvider<
    TestSecondPageErrorNotifier, PagePagingData<String>>(() {
  return TestSecondPageErrorNotifier();
});

Widget createTestWidget({
  required Widget child,
  PagingHelperViewTheme? theme,
}) {
  return ProviderScope(
    child: MaterialApp(
      theme: ThemeData(
        extensions: theme != null ? [theme] : [],
      ),
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  group('PagingHelperView', () {
    testWidgets('shows loading indicator on initial load', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: PagingHelperView(
            provider: testPagingProvider,
            futureRefreshable: testPagingProvider.future,
            notifierRefreshable: testPagingProvider.notifier,
            contentBuilder: (data, widgetCount, endItemView) {
              return ListView.builder(
                itemCount: widgetCount,
                itemBuilder: (context, index) {
                  if (index == widgetCount - 1) {
                    return endItemView;
                  }
                  return ListTile(title: Text(data.items[index]));
                },
              );
            },
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays content when data is loaded', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: PagingHelperView(
            provider: testPagingProvider,
            futureRefreshable: testPagingProvider.future,
            notifierRefreshable: testPagingProvider.notifier,
            contentBuilder: (data, widgetCount, endItemView) {
              return ListView.builder(
                itemCount: widgetCount,
                itemBuilder: (context, index) {
                  if (index == widgetCount - 1) {
                    return endItemView;
                  }
                  return ListTile(title: Text(data.items[index]));
                },
              );
            },
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('shows error view on first page error', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: PagingHelperView(
            provider: testErrorPagingProvider,
            futureRefreshable: testErrorPagingProvider.future,
            notifierRefreshable: testErrorPagingProvider.notifier,
            contentBuilder: (data, widgetCount, endItemView) {
              return ListView.builder(
                itemCount: widgetCount,
                itemBuilder: (context, index) {
                  if (index == widgetCount - 1) {
                    return endItemView;
                  }
                  return ListTile(title: Text(data.items[index]));
                },
              );
            },
          ),
        ),
      );

      // Wait for error to occur
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(find.text('Exception: Network error'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('shows snackbar on second page error when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: PagingHelperView(
            provider: testSecondPageErrorProvider,
            futureRefreshable: testSecondPageErrorProvider.future,
            notifierRefreshable: testSecondPageErrorProvider.notifier,
            showSecondPageError: true,
            contentBuilder: (data, widgetCount, endItemView) {
              return ListView.builder(
                itemCount: widgetCount,
                itemBuilder: (context, index) {
                  if (index == widgetCount - 1) {
                    return endItemView;
                  }
                  return ListTile(title: Text(data.items[index]));
                },
              );
            },
          ),
        ),
      );

      // Wait for initial data to load
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Find the notifier and trigger loadNext
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PagingHelperView<PagePagingData<String>, String>)),
      );
      final notifier = container.read(testSecondPageErrorProvider.notifier);
      
      // Trigger loading next page
      await notifier.loadNext();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Check for snackbar
      expect(find.text('Second page error'), findsOneWidget);
    });

    testWidgets('supports custom loading view', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          theme: PagingHelperViewTheme(
            loadingViewBuilder: (context) => const Text('Custom Loading'),
          ),
          child: PagingHelperView(
            provider: testPagingProvider,
            futureRefreshable: testPagingProvider.future,
            notifierRefreshable: testPagingProvider.notifier,
            contentBuilder: (data, widgetCount, endItemView) {
              return ListView.builder(
                itemCount: widgetCount,
                itemBuilder: (context, index) {
                  if (index == widgetCount - 1) {
                    return endItemView;
                  }
                  return ListTile(title: Text(data.items[index]));
                },
              );
            },
          ),
        ),
      );

      expect(find.text('Custom Loading'), findsOneWidget);
      
      // Allow timer to complete
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('supports custom error view', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          theme: PagingHelperViewTheme(
            errorViewBuilder: (context, error, stackTrace, retry) => Column(
              children: [
                const Text('Custom Error'),
                ElevatedButton(
                  onPressed: retry,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          child: PagingHelperView(
            provider: testErrorPagingProvider,
            futureRefreshable: testErrorPagingProvider.future,
            notifierRefreshable: testErrorPagingProvider.notifier,
            contentBuilder: (data, widgetCount, endItemView) {
              return ListView.builder(
                itemCount: widgetCount,
                itemBuilder: (context, index) {
                  if (index == widgetCount - 1) {
                    return endItemView;
                  }
                  return ListTile(title: Text(data.items[index]));
                },
              );
            },
          ),
        ),
      );

      // Wait for error to occur
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(find.text('Custom Error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('supports refresh indicator when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          theme: PagingHelperViewTheme(
            enableRefreshIndicator: true,
          ),
          child: PagingHelperView(
            provider: testPagingProvider,
            futureRefreshable: testPagingProvider.future,
            notifierRefreshable: testPagingProvider.notifier,
            contentBuilder: (data, widgetCount, endItemView) {
              return ListView.builder(
                itemCount: widgetCount,
                itemBuilder: (context, index) {
                  if (index == widgetCount - 1) {
                    return endItemView;
                  }
                  return ListTile(title: Text(data.items[index]));
                },
              );
            },
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Check that RefreshIndicator is present
      expect(find.byType(RefreshIndicator), findsOneWidget);

      // Trigger pull to refresh
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pump();

      // RefreshIndicator should be showing
      expect(find.byType(RefreshProgressIndicator), findsOneWidget);
    });

    testWidgets('disables refresh indicator when configured', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          theme: PagingHelperViewTheme(
            enableRefreshIndicator: false,
          ),
          child: PagingHelperView(
            provider: testPagingProvider,
            futureRefreshable: testPagingProvider.future,
            notifierRefreshable: testPagingProvider.notifier,
            contentBuilder: (data, widgetCount, endItemView) {
              return ListView.builder(
                itemCount: widgetCount,
                itemBuilder: (context, index) {
                  if (index == widgetCount - 1) {
                    return endItemView;
                  }
                  return ListTile(title: Text(data.items[index]));
                },
              );
            },
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Check that RefreshIndicator is not present
      expect(find.byType(RefreshIndicator), findsNothing);
    });

    testWidgets('does not show snackbar when showSecondPageError is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: PagingHelperView(
            provider: testSecondPageErrorProvider,
            futureRefreshable: testSecondPageErrorProvider.future,
            notifierRefreshable: testSecondPageErrorProvider.notifier,
            showSecondPageError: false,
            contentBuilder: (data, widgetCount, endItemView) {
              return ListView.builder(
                itemCount: widgetCount,
                itemBuilder: (context, index) {
                  if (index == widgetCount - 1) {
                    return endItemView;
                  }
                  return ListTile(title: Text(data.items[index]));
                },
              );
            },
          ),
        ),
      );

      // Wait for initial data to load
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Find the notifier and trigger loadNext
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PagingHelperView<PagePagingData<String>, String>)),
      );
      final notifier = container.read(testSecondPageErrorProvider.notifier);
      
      // Trigger loading next page
      await notifier.loadNext();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Check that no error widget is shown
      expect(find.text('Exception: Second page error'), findsNothing);
      expect(find.byIcon(Icons.refresh), findsNothing);
    });

    testWidgets('handles empty items list correctly', (WidgetTester tester) async {
      // Create a notifier that returns empty items
      final emptyProvider = AutoDisposeAsyncNotifierProvider<
          EmptyItemsNotifier, PagePagingData<String>>(() {
        return EmptyItemsNotifier();
      });

      await tester.pumpWidget(
        createTestWidget(
          child: PagingHelperView(
            provider: emptyProvider,
            futureRefreshable: emptyProvider.future,
            notifierRefreshable: emptyProvider.notifier,
            contentBuilder: (data, widgetCount, endItemView) {
              if (data.items.isEmpty) {
                return const Center(child: Text('No items'));
              }
              return ListView.builder(
                itemCount: widgetCount,
                itemBuilder: (context, index) {
                  if (index == widgetCount - 1) {
                    return endItemView;
                  }
                  return ListTile(title: Text(data.items[index]));
                },
              );
            },
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(find.text('No items'), findsOneWidget);
    });

    testWidgets('supports custom end loading view', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          theme: PagingHelperViewTheme(
            endLoadingViewBuilder: (context) => const Text('Loading more...'),
          ),
          child: PagingHelperView(
            provider: testPagingProvider,
            futureRefreshable: testPagingProvider.future,
            notifierRefreshable: testPagingProvider.notifier,
            contentBuilder: (data, widgetCount, endItemView) {
              return ListView.builder(
                itemCount: widgetCount,
                itemBuilder: (context, index) {
                  if (index == widgetCount - 1) {
                    return endItemView;
                  }
                  return ListTile(title: Text(data.items[index]));
                },
              );
            },
          ),
        ),
      );

      // Wait for initial data to load
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Scroll to trigger loading more
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pump();

      // Should show custom loading view
      expect(find.text('Loading more...'), findsOneWidget);
    });

    testWidgets('supports custom end error view', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          theme: PagingHelperViewTheme(
            endErrorViewBuilder: (context, error, onRetry) => Column(
              children: [
                const Text('Failed to load more'),
                TextButton(
                  onPressed: onRetry,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
          child: PagingHelperView(
            provider: testSecondPageErrorProvider,
            futureRefreshable: testSecondPageErrorProvider.future,
            notifierRefreshable: testSecondPageErrorProvider.notifier,
            contentBuilder: (data, widgetCount, endItemView) {
              return ListView.builder(
                itemCount: widgetCount,
                itemBuilder: (context, index) {
                  if (index == widgetCount - 1) {
                    return endItemView;
                  }
                  return ListTile(title: Text(data.items[index]));
                },
              );
            },
          ),
        ),
      );

      // Wait for initial data to load
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Trigger error on second page
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PagingHelperView<PagePagingData<String>, String>)),
      );
      final notifier = container.read(testSecondPageErrorProvider.notifier);
      await notifier.loadNext();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Should show custom error view
      expect(find.text('Failed to load more'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });
  });
}

// Add empty items notifier for testing
class EmptyItemsNotifier extends AutoDisposeAsyncNotifier<PagePagingData<String>>
    with PagePagingNotifierMixin<String> {
  @override
  Future<PagePagingData<String>> build() async {
    return fetch(page: 0);
  }

  @override
  Future<PagePagingData<String>> fetch({required int page}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return PagePagingData(
      items: [],
      page: page,
      hasMore: false,
    );
  }
}