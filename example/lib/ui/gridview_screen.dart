import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:example/ui/theme/app_theme.dart';
import 'package:example/ui/widgets/item_card.dart';
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
  Future<CursorPagingData<SampleItem>> fetch({required String? cursor}) async {
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

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const GridViewScreen());

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('GridView Example'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.heroGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                _scrollDirection == Axis.vertical
                    ? Icons.swap_horiz_rounded
                    : Icons.swap_vert_rounded,
              ),
              onPressed: _toggleScrollDirection,
              tooltip: 'Toggle scroll direction',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Gradient header space
          Container(
            height: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.heroGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),
          // Content area
          Expanded(
            child: PagingHelperView(
              provider: gridViewProvider,
              futureRefreshable: gridViewProvider.future,
              notifierRefreshable: gridViewProvider.notifier,
              contentBuilder: (data, widgetCount, endItemView) {
                return GridView.builder(
                  scrollDirection: _scrollDirection,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _scrollDirection == Axis.vertical ? 2 : 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio:
                        _scrollDirection == Axis.vertical ? 0.85 : 0.75,
                  ),
                  padding: const EdgeInsets.all(16),
                  itemCount: widgetCount,
                  itemBuilder: (context, index) {
                    if (index == widgetCount - 1) {
                      return endItemView;
                    }

                    final item = data.items[index];
                    return Semantics(
                      identifier: 'grid-item-$index',
                      child: GridItemCard(item: item, index: index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
