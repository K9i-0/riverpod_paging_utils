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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Paging Methods'),
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
          bottom: TabBar(
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
        ),
        body: Column(
          children: [
            // Gradient header space (including tab bar height)
            Container(
              height:
                  kToolbarHeight +
                  kTextTabBarHeight +
                  MediaQuery.of(context).padding.top +
                  20,
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
            Expanded(
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
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
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
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
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
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
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
          ],
        ),
      ),
    );
  }
}
