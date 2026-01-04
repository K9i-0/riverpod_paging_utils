import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paging_utils/riverpod_paging_utils.dart';

part 'custom_scroll_view_screen.g.dart';

@riverpod
class CustomScrollViewNotifier extends _$CustomScrollViewNotifier
    with CursorPagingNotifierMixin<SampleItem> {
  @override
  Future<CursorPagingData<SampleItem>> build() => fetch(cursor: null);

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

class CustomScrollViewScreen extends ConsumerWidget {
  const CustomScrollViewScreen({super.key});

  static Route<void> route() => MaterialPageRoute(
        builder: (_) => const CustomScrollViewScreen(),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.blue, Colors.red],
                  ),
                ),
                child: Center(
                  child: Text(
                    'PagingHelperSliverView\nExample',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          // CupertinoSliverRefreshControl for iOS-style pull-to-refresh
          CupertinoSliverRefreshControl(
            onRefresh: () async =>
                ref.refresh(customScrollViewProvider.future),
          ),
          // Static content before the list
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PagingHelperSliverView',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This example demonstrates how to use PagingHelperSliverView '
                        'within a CustomScrollView. It works seamlessly with other '
                        'slivers like SliverAppBar and SliverToBoxAdapter.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // The paginated list using PagingHelperSliverView
          PagingHelperSliverView(
            provider: customScrollViewProvider,
            futureRefreshable: customScrollViewProvider.future,
            notifierRefreshable: customScrollViewProvider.notifier,
            contentBuilder: (data, widgetCount, endItemView) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == widgetCount - 1) {
                      return endItemView;
                    }

                    final item = data.items[index];
                    return Semantics(
                      identifier: 'sliver-item-$index',
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(item.name[0]),
                        ),
                        title: Text(item.name),
                        subtitle: Text(item.id),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  },
                  childCount: widgetCount,
                ),
              );
            },
          ),
          // Additional static content after the list
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'End of Custom ScrollView',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
