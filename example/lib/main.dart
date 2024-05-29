import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:example/ui/first_page_error_screen.dart';
import 'package:example/ui/id_screen.dart';
import 'package:example/ui/second_page_error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paging_utils/riverpod_paging_utils.dart';
import 'package:riverpod_paging_utils/theme_extension.dart';

part 'main.g.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
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
        title: const Text('Sample Screen'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('1st page error'),
              onTap: () => Navigator.of(context).push(
                FirstPageErrorScreen.route(),
              ),
            ),
            ListTile(
              title: const Text('2nd page error'),
              onTap: () => Navigator.of(context).push(
                SecondPageErrorScreen.route(),
              ),
            ),
            ListTile(
              title: const Text('Id screen'),
              onTap: () => Navigator.of(context).push(
                IdScreen.route(),
              ),
            ),
          ],
        ),
      ),
      body: PagingHelperView(
        provider: sampleNotifierProvider,
        futureRefreshable: sampleNotifierProvider.future,
        notifierRefreshable: sampleNotifierProvider.notifier,
        contentBuilder: (data, endItemView) => ListView.builder(
          itemCount: data.items.length + (endItemView != null ? 1 : 0),
          itemBuilder: (context, index) {
            // If the end item view is provided and the index is the last item,
            // return the end item view.
            if (endItemView != null && index == data.items.length) {
              return endItemView;
            }

            // Otherwise, build a list tile for each sample item.
            return ListTile(
              title: Text(data.items[index].name),
              subtitle: Text(data.items[index].id),
            );
          },
        ),
      ),
    );
  }
}
