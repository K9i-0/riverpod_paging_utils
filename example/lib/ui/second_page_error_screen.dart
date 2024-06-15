import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paging_utils/riverpod_paging_utils.dart';

part 'second_page_error_screen.g.dart';

@riverpod
class SecondPageErrorNotifier extends _$SecondPageErrorNotifier
    with CursorPagingNotifierMixin<SampleItem> {
  @override
  Future<CursorPagingData<SampleItem>> build() => fetch(cursor: null);

  @override
  Future<CursorPagingData<SampleItem>> fetch({
    required String? cursor,
  }) async {
    if (cursor != null) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      throw Exception('Error fetching data');
    }

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

@riverpod
class ShowSecondPageErrorNotifier extends _$ShowSecondPageErrorNotifier {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

class SecondPageErrorScreen extends ConsumerWidget {
  const SecondPageErrorScreen._();

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const SecondPageErrorScreen._(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2nd Page Error Sample'),
        actions: [
          Tooltip(
            message: 'Toggle showSecondPageError',
            child: Switch(
              value: ref.watch(showSecondPageErrorNotifierProvider),
              onChanged: (_) => ref
                  .read(showSecondPageErrorNotifierProvider.notifier)
                  .toggle(),
            ),
          ),
        ],
      ),
      body: PagingHelperView(
        provider: secondPageErrorNotifierProvider,
        futureRefreshable: secondPageErrorNotifierProvider.future,
        notifierRefreshable: secondPageErrorNotifierProvider.notifier,
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
        showSecondPageError: ref.watch(showSecondPageErrorNotifierProvider),
      ),
    );
  }
}
