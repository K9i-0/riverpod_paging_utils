import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:example/ui/custom_scroll_view_screen.dart';
import 'package:example/ui/first_page_error_screen.dart';
import 'package:example/ui/gridview_screen.dart';
import 'package:example/ui/paging_method_screen.dart';
import 'package:example/ui/passing_args_screen.dart';
import 'package:example/ui/second_page_error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paging_utils/riverpod_paging_utils.dart';

part 'main.g.dart';

void main() {
  runApp(
    ProviderScope(
      // Disable automatic retry for testing error screens
      retry: (retryCount, error) => null,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          PagingHelperViewTheme(
              // loadingViewBuilder: (context) => const Center(
              //   child: CircularProgressIndicator(
              //     color: Colors.red,
              //   ),
              // ),
              ),
        ],
      ),
      home: const SampleScreen(),
    );
  }
}

/// A Riverpod provider that mixes in [CursorPagingNotifierMixin].
/// This provider handles the pagination logic for fetching [SampleItem] data using cursor-based pagination.
@riverpod
class SampleNotifier extends _$SampleNotifier
    with CursorPagingNotifierMixin<SampleItem> {
  /// Builds the initial state of the provider by fetching data with a null cursor.
  @override
  Future<CursorPagingData<SampleItem>> build() => fetch(cursor: null);

  /// Fetches paginated data from the [SampleRepository] based on the provided [cursor].
  /// Returns a [CursorPagingData] object containing the fetched items, a flag indicating whether more data is available,
  /// and the next cursor for fetching the next page.
  @override
  Future<CursorPagingData<SampleItem>> fetch({
    required String? cursor,
  }) async {
    final repository = ref.read(sampleRepositoryProvider);
    final (items, nextCursor) = await repository.getByCursor(cursor);
    final hasMore = nextCursor != null && nextCursor.isNotEmpty;

    return CursorPagingData(
      items: items,
      hasMore: hasMore,
      nextCursor: nextCursor,
    );
  }
}

/// A sample page that demonstrates the usage of [PagingHelperView] with the [SampleNotifier] provider.
class SampleScreen extends StatelessWidget {
  const SampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => Semantics(
            identifier: 'drawer-menu-button',
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        title: const Text('Sample Screen'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('1st page error'),
              onTap: () async => Navigator.of(context).push(
                FirstPageErrorScreen.route(),
              ),
            ),
            ListTile(
              title: const Text('2nd page error'),
              onTap: () async => Navigator.of(context).push(
                SecondPageErrorScreen.route(),
              ),
            ),
            ListTile(
              title: const Text('Passing args screen'),
              onTap: () async => Navigator.of(context).push(
                PassingArgsScreen.route(),
              ),
            ),
            ListTile(
              title: const Text('Paging method screen'),
              onTap: () async => Navigator.of(context).push(
                PagingMethodScreen.route(),
              ),
            ),
            ListTile(
              title: const Text('GridView example'),
              onTap: () async => Navigator.of(context).push(
                GridViewScreen.route(),
              ),
            ),
            ListTile(
              title: const Text('CustomScrollView example'),
              onTap: () async => Navigator.of(context).push(
                CustomScrollViewScreen.route(),
              ),
            ),
          ],
        ),
      ),
      body: PagingHelperView(
        provider: sampleProvider,
        futureRefreshable: sampleProvider.future,
        notifierRefreshable: sampleProvider.notifier,
        contentBuilder: (data, widgetCount, endItemView) => ListView.builder(
          itemCount: widgetCount,
          itemBuilder: (context, index) {
            // if the index is last, then
            // return the end item view.
            if (index == widgetCount - 1) {
              return endItemView;
            }

            // Otherwise, build a list tile for each sample item.
            return Semantics(
              identifier: 'sample-item-$index',
              child: ListTile(
                key: ValueKey(data.items[index].id),
                title: Text(data.items[index].name),
                subtitle: Text(data.items[index].id),
              ),
            );
          },
        ),
      ),
    );
  }
}
