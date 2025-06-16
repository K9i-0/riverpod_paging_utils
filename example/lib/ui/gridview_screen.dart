import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paging_utils/riverpod_paging_utils.dart';

part 'gridview_screen.g.dart';

@riverpod
class GridViewNotifier extends _$GridViewNotifier
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

class GridViewScreen extends StatefulWidget {
  const GridViewScreen({super.key});

  static Route<void> route() => MaterialPageRoute(
        builder: (_) => const GridViewScreen(),
      );

  @override
  State<GridViewScreen> createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  Axis _scrollDirection = Axis.vertical;

  void _toggleScrollDirection() {
    setState(() {
      _scrollDirection =
          _scrollDirection == Axis.vertical ? Axis.horizontal : Axis.vertical;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GridView Example'),
        actions: [
          IconButton(
            icon: Icon(
              _scrollDirection == Axis.vertical
                  ? Icons.swap_horiz
                  : Icons.swap_vert,
            ),
            onPressed: _toggleScrollDirection,
            tooltip: 'Toggle scroll direction',
          ),
        ],
      ),
      body: PagingHelperView(
        provider: gridViewNotifierProvider,
        futureRefreshable: gridViewNotifierProvider.future,
        notifierRefreshable: gridViewNotifierProvider.notifier,
        contentBuilder: (data, widgetCount, endItemView) {
          return GridView.builder(
            scrollDirection: _scrollDirection,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _scrollDirection == Axis.vertical ? 2 : 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: _scrollDirection == Axis.vertical ? 1 : 0.75,
            ),
            padding: const EdgeInsets.all(8),
            itemCount: widgetCount,
            itemBuilder: (context, index) {
              if (index == widgetCount - 1) {
                return endItemView;
              }

              final item = data.items[index];
              return Card(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder,
                        size: 48,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        item.id,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
