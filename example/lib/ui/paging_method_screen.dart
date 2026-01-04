import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:example/ui/theme/app_theme.dart';
import 'package:example/ui/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_paging_utils/riverpod_paging_utils.dart';

part 'paging_method_screen.g.dart';

@riverpod
class PageBasedNotifier extends _$PageBasedNotifier
    with PagePagingNotifierMixin<SampleItem> {
  @override
  Future<PagePagingData<SampleItem>> build() => fetch(page: 1);

  @override
  Future<PagePagingData<SampleItem>> fetch({required int page}) async {
    final repository = ref.read(sampleRepositoryProvider);
    final (items, hasMore) = await repository.getByPage(page: page, limit: 10);
    ref.keepAlive();

    return PagePagingData(items: items, hasMore: hasMore, page: page);
  }
}

@riverpod
class OffsetBasedNotifier extends _$OffsetBasedNotifier
    with OffsetPagingNotifierMixin<SampleItem> {
  @override
  Future<OffsetPagingData<SampleItem>> build() => fetch(offset: 0);

  @override
  Future<OffsetPagingData<SampleItem>> fetch({required int offset}) async {
    final repository = ref.read(sampleRepositoryProvider);
    final (items, hasMore) = await repository.getByOffset(
      offset: offset,
      limit: 15,
    );
    ref.keepAlive();

    return OffsetPagingData(
      items: items,
      hasMore: hasMore,
      offset: offset + 15,
    );
  }
}

@riverpod
class CursorBasedNotifier extends _$CursorBasedNotifier
    with CursorPagingNotifierMixin<SampleItem> {
  @override
  Future<CursorPagingData<SampleItem>> build() => fetch(cursor: null);

  @override
  Future<CursorPagingData<SampleItem>> fetch({required String? cursor}) async {
    final repository = ref.read(sampleRepositoryProvider);
    final (items, nextCursor) = await repository.getByCursor(cursor);
    ref.keepAlive();
    final hasMore = nextCursor != null && nextCursor.isNotEmpty;

    return CursorPagingData(
      items: items,
      hasMore: hasMore,
      nextCursor: nextCursor,
    );
  }
}

class PagingMethodScreen extends StatelessWidget {
  const PagingMethodScreen._();

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const PagingMethodScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = kToolbarHeight + kTextTabBarHeight + topPadding + 24;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            Container(color: Theme.of(context).scaffoldBackgroundColor),
            // Content area
            Positioned.fill(
              top: headerHeight - 16,
              child: TabBarView(
                children: [
                  // Page-based pagination
                  PagingHelperView(
                    provider: pageBasedProvider,
                    futureRefreshable: pageBasedProvider.future,
                    notifierRefreshable: pageBasedProvider.notifier,
                    contentBuilder:
                        (data, widgetCount, endItemView) => ListView.builder(
                          key: const PageStorageKey<String>('page'),
                          padding: const EdgeInsets.only(top: 24, bottom: 16),
                          itemCount: widgetCount,
                          itemBuilder: (context, index) {
                            if (index == widgetCount - 1) {
                              return endItemView;
                            }
                            return Semantics(
                              identifier: 'page-item-$index',
                              child: ItemCard(
                                key: ValueKey(data.items[index].id),
                                item: data.items[index],
                                index: index,
                              ),
                            );
                          },
                        ),
                  ),
                  // Offset-based pagination
                  PagingHelperView(
                    provider: offsetBasedProvider,
                    futureRefreshable: offsetBasedProvider.future,
                    notifierRefreshable: offsetBasedProvider.notifier,
                    contentBuilder:
                        (data, widgetCount, endItemView) => ListView.builder(
                          key: const PageStorageKey<String>('offset'),
                          padding: const EdgeInsets.only(top: 24, bottom: 16),
                          itemCount: widgetCount,
                          itemBuilder: (context, index) {
                            if (index == widgetCount - 1) {
                              return endItemView;
                            }
                            return Semantics(
                              identifier: 'offset-item-$index',
                              child: ItemCard(
                                key: ValueKey(data.items[index].id),
                                item: data.items[index],
                                index: index,
                              ),
                            );
                          },
                        ),
                  ),
                  // Cursor-based pagination
                  PagingHelperView(
                    provider: cursorBasedProvider,
                    futureRefreshable: cursorBasedProvider.future,
                    notifierRefreshable: cursorBasedProvider.notifier,
                    contentBuilder:
                        (data, widgetCount, endItemView) => ListView.builder(
                          key: const PageStorageKey<String>('cursor'),
                          padding: const EdgeInsets.only(top: 24, bottom: 16),
                          itemCount: widgetCount,
                          itemBuilder: (context, index) {
                            if (index == widgetCount - 1) {
                              return endItemView;
                            }
                            return Semantics(
                              identifier: 'cursor-item-$index',
                              child: ItemCard(
                                key: ValueKey(data.items[index].id),
                                item: data.items[index],
                                index: index,
                              ),
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
            // Gradient header with tabs
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
                  child: Column(
                    children: [
                      Padding(
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
                                children: [
                                  Text(
                                    'Paging Methods',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Page, Offset & Cursor',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TabBar(
                        indicatorColor: Colors.white,
                        indicatorWeight: 3,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white60,
                        tabs: [
                          Semantics(
                            identifier: 'page-tab',
                            child: const Tab(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.filter_1_rounded, size: 18),
                                  SizedBox(width: 6),
                                  Text('Page'),
                                ],
                              ),
                            ),
                          ),
                          Semantics(
                            identifier: 'offset-tab',
                            child: const Tab(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.format_list_numbered_rounded, size: 18),
                                  SizedBox(width: 6),
                                  Text('Offset'),
                                ],
                              ),
                            ),
                          ),
                          Semantics(
                            identifier: 'cursor-tab',
                            child: const Tab(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.arrow_forward_rounded, size: 18),
                                  SizedBox(width: 6),
                                  Text('Cursor'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
