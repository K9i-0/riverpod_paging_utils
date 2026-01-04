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

  static const _gradientColors = [Color(0xFFE53935), Color(0xFFEF5350)];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSecondPageError = ref.watch(showSecondPageErrorProvider);
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = kToolbarHeight + topPadding + 24;

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
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.red.withValues(alpha: 0.3)),
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
                                '2nd Page Error',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Pagination error handling',
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
                          padding: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Error',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Switch(
                                value: showSecondPageError,
                                onChanged: (_) => ref
                                    .read(showSecondPageErrorProvider.notifier)
                                    .toggle(),
                                activeThumbColor: Colors.white,
                                activeTrackColor: Colors.white24,
                              ),
                            ],
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
    );
  }
}
