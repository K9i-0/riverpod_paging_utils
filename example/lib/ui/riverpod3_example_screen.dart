import 'package:example/data/sample_item.dart';
import 'package:example/repository/sample_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_paging_utils/riverpod_paging_utils.dart';

// Provider definitions (manual since code generation has build issues)
final riverpod3PostsNotifierProvider = AsyncNotifierProvider<Riverpod3PostsNotifier, PagePagingData<SampleItem>>(
  () => Riverpod3PostsNotifier(),
);

final riverpod3MixinNotifierProvider = AsyncNotifierProvider<Riverpod3MixinNotifier, PagePagingData<SampleItem>>(
  () => Riverpod3MixinNotifier(),
);

/// Example implementation using Riverpod 3.0's features (without @mutation due to build issues)
class Riverpod3PostsNotifier extends AsyncNotifier<PagePagingData<SampleItem>> {
  static const _pageSize = 20;

  @override
  Future<PagePagingData<SampleItem>> build() async {
    // Initial page load
    return await _fetchPage(1);
  }

  /// Loads the next page (manual implementation since @mutation causes build issues)
  Future<void> loadNextPage() async {
    final currentState = await future;
    if (!currentState.hasMore) return;

    // Show loading state while preserving previous data
    state = AsyncLoading<PagePagingData<SampleItem>>()
        .copyWithPrevious(state);

    try {
      final nextData = await _fetchPage(currentState.page + 1);
      
      // Check if still mounted before updating state
      if (!ref.mounted) return;
      
      state = AsyncData(currentState.copyWith(
        items: [...currentState.items, ...nextData.items],
        page: nextData.page,
        hasMore: nextData.hasMore,
      ));
    } catch (error, stackTrace) {
      // Preserve previous data on error
      if (!ref.mounted) return;
      
      state = AsyncError<PagePagingData<SampleItem>>(error, stackTrace)
          .copyWithPrevious(state);
    }
  }

  /// Refreshes the data from the beginning
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchPage(1));
  }

  Future<PagePagingData<SampleItem>> _fetchPage(int page) async {
    final repository = ref.read(sampleRepositoryProvider);
    final (items, hasMore) = await repository.getByPage(
      page: page,
      limit: _pageSize,
    );
    
    // Keep provider alive while data exists
    if (items.isNotEmpty) {
      ref.keepAlive();
    }
    
    return PagePagingData(
      items: items,
      page: page,
      hasMore: hasMore,
    );
  }
}

/// Alternative implementation using the mixin pattern with V3
class Riverpod3MixinNotifier extends AsyncNotifier<PagePagingData<SampleItem>>
    with PagePagingNotifierMixinV3<SampleItem> {
  @override
  Future<PagePagingData<SampleItem>> build() => fetch(page: 1);

  @override
  Future<PagePagingData<SampleItem>> fetch({required int page}) async {
    final repository = ref.read(sampleRepositoryProvider);
    final (items, hasMore) = await repository.getByPage(
      page: page,
      limit: 30,
    );
    
    ref.keepAlive();
    
    return PagePagingData(
      items: items,
      hasMore: hasMore,
      page: page,
    );
  }
}

class Riverpod3ExampleScreen extends ConsumerWidget {
  const Riverpod3ExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riverpod 3.0 Examples'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '@mutation'),
              Tab(text: 'Mixin V3'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MutationExampleView(),
            _MixinV3ExampleView(),
          ],
        ),
      ),
    );
  }
}

class _MutationExampleView extends ConsumerWidget {
  const _MutationExampleView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(riverpod3PostsNotifierProvider);
    final notifier = ref.read(riverpod3PostsNotifierProvider.notifier);
    
    return Scaffold(
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => ref.invalidate(riverpod3PostsNotifierProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (pagedData) {
          return RefreshIndicator(
            onRefresh: () async => await notifier.refresh(),
            child: ListView.builder(
              itemCount: pagedData.items.length + (pagedData.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == pagedData.items.length) {
                  // Auto-load next page when reaching the end
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    notifier.loadNextPage();
                  });
                  
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                final item = pagedData.items[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.color,
                    child: Text('${item.id}'),
                  ),
                  title: Text(item.name),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _MixinV3ExampleView extends ConsumerWidget {
  const _MixinV3ExampleView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PagingHelperViewV3(
      provider: riverpod3MixinNotifierProvider,
      futureRefreshable: riverpod3MixinNotifierProvider.future,
      notifierRefreshable: riverpod3MixinNotifierProvider.notifier,
      contentBuilder: (data, widgetCount, endItemView) {
        return ListView.builder(
          itemCount: widgetCount,
          itemBuilder: (context, index) {
            if (index == data.items.length) {
              return endItemView;
            }
            
            final item = data.items[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item.color,
                  child: Text('${item.id}'),
                ),
                title: Text(item.name),
                subtitle: Text('Page ${data.page}'),
              ),
            );
          },
        );
      },
    );
  }
}