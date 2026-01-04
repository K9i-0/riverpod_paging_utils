import 'package:example/data/sample_item.dart';
import 'package:example/ui/theme/app_theme.dart';
import 'package:example/ui/widgets/item_card.dart';
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

  static const _pageSize = 5;

  @override
  Future<CursorPagingData<SampleItem>> fetch({required String? cursor}) async {
    // 2nd page以降はエラーを発生させる
    if (cursor != null) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      throw Exception('Error fetching data');
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));

    // 最初のページのみ5件を返す
    final items = List.generate(
      _pageSize,
      (index) => SampleItem(id: 'item-$index', name: 'Item $index'),
    );

    return CursorPagingData(
      items: items,
      hasMore: true,
      nextCursor: '$_pageSize',
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
    final showSecondPageError = ref.watch(showSecondPageErrorProvider);

    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          PagingHelperViewTheme(
            showSecondPageError: showSecondPageError,
            endErrorViewBuilder:
                (context, error, onRetryPressed) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Semantics(
                          identifier: 'end-error-view',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  '$error',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Semantics(
                          identifier: 'error-retry-button',
                          button: true,
                          container: true,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: onRetryPressed,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: AppColors.primaryGradient,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.refresh_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Retry',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
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
                  ),
                ),
          ),
        ],
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('2nd Page Error'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade600, Colors.red.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          foregroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text('Show Error', style: TextStyle(fontSize: 12)),
                    ),
                    Switch(
                      value: showSecondPageError,
                      onChanged:
                          (_) =>
                              ref
                                  .read(showSecondPageErrorProvider.notifier)
                                  .toggle(),
                      activeThumbColor: Colors.white,
                      activeTrackColor: Colors.white24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Gradient header space
            Container(
              height: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade600, Colors.red.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),
            // Warning info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red,
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
                            'Pagination Error',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Error occurs when loading more items',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
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
                provider: secondPageErrorProvider,
                futureRefreshable: secondPageErrorProvider.future,
                notifierRefreshable: secondPageErrorProvider.notifier,
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
    );
  }
}
