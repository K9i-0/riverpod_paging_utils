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
    return const PagePagingData(
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
    return const PagePagingData(
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
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

      expect(find.text('Network error'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
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
      await tester.pumpAndSettle();

      // Find the notifier and trigger loadNext
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PagingHelperView<PagePagingData<String>, String>)),
      );
      final notifier = container.read(testSecondPageErrorProvider.notifier);
      
      // Trigger loading next page
      await notifier.loadNext();
      await tester.pumpAndSettle();

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
    });

    testWidgets('supports custom error view', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          theme: PagingHelperViewTheme(
            errorViewBuilder: (context, error, retry) => Column(
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
      await tester.pumpAndSettle();

      expect(find.text('Custom Error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('supports refresh indicator when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          theme: const PagingHelperViewTheme(
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
      await tester.pumpAndSettle();

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
          theme: const PagingHelperViewTheme(
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
      await tester.pumpAndSettle();

      // Check that RefreshIndicator is not present
      expect(find.byType(RefreshIndicator), findsNothing);
    });
  });
}