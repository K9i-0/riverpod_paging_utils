import 'package:easy_refresh/easy_refresh.dart';
import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paging_utils/riverpod_paging_utils.dart';
import 'package:riverpod_paging_utils/theme_extension.dart';

part 'main3.g.dart';

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
            // disable pull-to-refresh
            enableRefreshIndicator: false,
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
    // Simulate a delay of 2 seconds to demonstrate the loading view.
    await Future<void>.delayed(const Duration(seconds: 2));
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
class SampleScreen extends ConsumerWidget {
  const SampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Display errors using SnackBar
    ref.listen(sampleNotifierProvider, (_, state) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced UI Customization'),
      ),
      body: PagingHelperView(
        provider: sampleNotifierProvider,
        futureRefreshable: sampleNotifierProvider.future,
        notifierRefreshable: sampleNotifierProvider.notifier,
        contentBuilder: (data, endItemView) {
          // Use EasyRefresh alternative to RefreshIndicator
          return EasyRefresh(
            onRefresh: () async => ref.refresh(sampleNotifierProvider.future),
            child: ListView.builder(
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
          );
        },
      ),
    );
  }
}
