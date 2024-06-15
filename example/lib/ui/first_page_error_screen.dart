import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paging_utils/riverpod_paging_utils.dart';

part 'first_page_error_screen.g.dart';

@riverpod
class FirstPageErrorNotifier extends _$FirstPageErrorNotifier
    with CursorPagingNotifierMixin<SampleItem> {
  @override
  Future<CursorPagingData<SampleItem>> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    throw Exception('Error fetching data');
    // ignore: dead_code
    return fetch(cursor: null);
  }

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

class FirstPageErrorScreen extends StatelessWidget {
  const FirstPageErrorScreen._();

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const FirstPageErrorScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1st Page Error Sample'),
      ),
      body: PagingHelperView(
        provider: firstPageErrorNotifierProvider,
        futureRefreshable: firstPageErrorNotifierProvider.future,
        notifierRefreshable: firstPageErrorNotifierProvider.notifier,
        contentBuilder: (data, widgetCount, endItemView) => ListView.builder(
          itemCount: widgetCount,
          itemBuilder: (context, index) {
            // if the index is last, then
            // return the end item view.
            if (index == widgetCount - 1) {
              return endItemView;
            }

            // Otherwise, build a list tile for each sample item.
            return ListTile(
              key: ValueKey(data.items[index].id),
              title: Text(data.items[index].name),
              subtitle: Text(data.items[index].id),
            );
          },
        ),
      ),
    );
  }
}
