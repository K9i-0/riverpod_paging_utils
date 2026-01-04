import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:example/ui/widgets/item_card.dart';
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

    // sample code
    // ignore: dead_code
    return fetch(cursor: null);
  }

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

class FirstPageErrorScreen extends StatelessWidget {
  const FirstPageErrorScreen._();

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const FirstPageErrorScreen._(),
    );
  }

  static const _gradientColors = [Color(0xFFFF9800), Color(0xFFFF5722)];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = kToolbarHeight + topPadding + 24;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: Theme.of(context).scaffoldBackgroundColor),
          // Content area
          Positioned.fill(
            top: headerHeight - 16,
            child: Column(
              children: [
                // Warning info
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Error Simulation',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'First page always throws an error',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Content area
                Expanded(
                  child: PagingHelperView(
                    provider: firstPageErrorProvider,
                    futureRefreshable: firstPageErrorProvider.future,
                    notifierRefreshable: firstPageErrorProvider.notifier,
                    contentBuilder:
                        (data, widgetCount, endItemView) => ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: widgetCount,
                          itemBuilder: (context, index) {
                            if (index == widgetCount - 1) {
                              return endItemView;
                            }

                            return Semantics(
                              identifier: 'sample-item-$index',
                              child: ItemCard(
                                key: ValueKey(data.items[index].id),
                                item: data.items[index],
                                index: index,
                              ),
                            );
                          },
                        ),
                  ),
                ),
              ],
            ),
          ),
          // Gradient header
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            child: Container(
              height: headerHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: _gradientColors,
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
                              '1st Page Error',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Initial load error handling',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
