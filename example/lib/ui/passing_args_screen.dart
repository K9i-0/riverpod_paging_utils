import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:example/ui/theme/app_theme.dart';
import 'package:example/ui/widgets/item_card.dart';
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
  Future<CursorPagingData<SampleItem>> fetch({required String? cursor}) async {
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
    return MaterialPageRoute(builder: (context) => const PassingArgsScreen._());
  }

  @override
  Widget build(BuildContext context) {
    final provider = passingArgsProvider(id: '1');
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
                // Info card
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.data_object_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Provider ID: 1',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Demonstrating family provider with arguments',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
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
                    provider: provider,
                    futureRefreshable: provider.future,
                    notifierRefreshable: provider.notifier,
                    contentBuilder:
                        (data, widgetCount, endItemView) => ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: widgetCount,
                          itemBuilder: (context, index) {
                            if (index == widgetCount - 1) {
                              return endItemView;
                            }

                            return Semantics(
                              identifier: 'passing-args-item-$index',
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
                              'Family Provider',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Passing arguments to providers',
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
