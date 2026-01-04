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
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = kToolbarHeight + topPadding + 24;
    final crossAxisCount = _scrollDirection == Axis.vertical ? 2 : 3;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: Theme.of(context).scaffoldBackgroundColor),
          // Content area
          Positioned.fill(
            top: headerHeight - 16,
            child: PagingHelperView(
              provider: gridViewProvider,
              futureRefreshable: gridViewProvider.future,
              notifierRefreshable: gridViewProvider.notifier,
              contentBuilder: (data, widgetCount, endItemView) {
                // Calculate if we need to show loading indicator
                final hasEndItem = widgetCount > data.items.length;
                final gridItemCount =
                    hasEndItem ? widgetCount - 1 : widgetCount;

                return CustomScrollView(
                  scrollDirection: _scrollDirection,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio:
                              _scrollDirection == Axis.vertical ? 0.85 : 0.75,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = data.items[index];
                            return Semantics(
                              identifier: 'grid-item-$index',
                              child: GridItemCard(item: item, index: index),
                            );
                          },
                          childCount: gridItemCount,
                        ),
                      ),
                    ),
                    // Show loading/error indicator centered at the bottom
                    if (hasEndItem)
                      SliverToBoxAdapter(
                        child: Center(child: endItemView),
                      ),
                  ],
                );
              },
            ),
          ),
          // Gradient header with rounded corners
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            child: Container(
              height: headerHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.heroGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded),
                        color: Colors.white,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'GridView Example',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Grid layout with pagination',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 4),
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
                          color: Colors.white,
                          onPressed: _toggleScrollDirection,
                          tooltip: 'Toggle scroll direction',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
