import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
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
  Future<CursorPagingData<SampleItem>> fetch({
    required String? cursor,
  }) async {
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
            // Custom end error view with Semantics identifier for E2E testing
            endErrorViewBuilder: (context, error, onRetryPressed) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Semantics(
                      identifier: 'end-error-view',
                      child: Text('$error'),
                    ),
                    const SizedBox(height: 8),
                    Semantics(
                      identifier: 'error-retry-button',
                      button: true,
                      container: true,
                      child: GestureDetector(
                        onTap: onRetryPressed,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
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
        appBar: AppBar(
          title: const Text('2nd Page Error Sample'),
          actions: [
            Tooltip(
              message: 'Toggle showSecondPageError',
              child: Switch(
                value: showSecondPageError,
                onChanged: (_) =>
                    ref.read(showSecondPageErrorProvider.notifier).toggle(),
              ),
            ),
          ],
        ),
        body: PagingHelperView(
          provider: secondPageErrorProvider,
          futureRefreshable: secondPageErrorProvider.future,
          notifierRefreshable: secondPageErrorProvider.notifier,
          contentBuilder: (data, widgetCount, endItemView) => ListView.builder(
            itemCount: widgetCount,
            itemBuilder: (context, index) {
              // if the index is last, then
              // return the end item view.
              if (index == widgetCount - 1) {
                return endItemView;
              }

              // Otherwise, build a list tile for each sample item.
              return Semantics(
                identifier: 'sample-item-$index',
                child: ListTile(
                  key: ValueKey(data.items[index].id),
                  title: Text(data.items[index].name),
                  subtitle: Text(data.items[index].id),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
