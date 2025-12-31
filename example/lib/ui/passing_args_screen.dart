import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paging_utils/riverpod_paging_utils.dart';

part 'passing_args_screen.g.dart';

@riverpod
class PassingArgsNotifier extends _$PassingArgsNotifier
    with CursorPagingNotifierMixin<SampleItem> {
  @override
  Future<CursorPagingData<SampleItem>> build({required String id}) =>
      fetch(cursor: null);

  @override
  Future<CursorPagingData<SampleItem>> fetch({
    required String? cursor,
  }) async {
    final repository = ref.read(sampleRepositoryProvider);
    // Use the id build method parameter to fetch data.
    final (items, nextCursor) = await repository.getByCursorAndId(id, cursor);
    final hasMore = nextCursor != null && nextCursor.isNotEmpty;

    return CursorPagingData(
      items: items,
      hasMore: hasMore,
      nextCursor: nextCursor,
    );
  }
}

class PassingArgsScreen extends StatelessWidget {
  const PassingArgsScreen._();

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const PassingArgsScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = passingArgsProvider(id: '1');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passing Args Sample'),
      ),
      body: PagingHelperView(
        provider: provider,
        futureRefreshable: provider.future,
        notifierRefreshable: provider.notifier,
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
