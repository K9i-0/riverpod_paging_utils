import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paging_utils/riverpod_paging_utils.dart';

part 'second_page_error_screen.g.dart';

@riverpod
class SecondPageErrorNotifier extends _$SecondPageErrorNotifier
    with CursorPagingNotifierMixin {
  @override
  Future<CursorPagingData<SampleItem>> build() => fetch(cursor: null);

  @override
  Future<CursorPagingData<SampleItem>> fetch({
    required String? cursor,
  }) async {
    if (cursor != null) {
      await Future.delayed(const Duration(milliseconds: 500));
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

class SecondPageErrorScreen extends StatelessWidget {
  const SecondPageErrorScreen._();

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const SecondPageErrorScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2nd Page Error Screen'),
      ),
      body: PagingHelperView(
        provider: secondPageErrorNotifierProvider,
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
