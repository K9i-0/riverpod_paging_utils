# Riverpod Paging Utils

A Flutter package that provides utilities for implementing pagination with Riverpod. It includes a generic `PagingHelperView` widget and mixins for page-based, offset-based, and cursor-based pagination.

## Demo

| <img src="https://raw.githubusercontent.com/K9i-0/riverpod_paging_utils/main/gifs/rpu_sample.gif" alt="riverpod_paging_utils_sample"> | <img src="https://raw.githubusercontent.com/K9i-0/riverpod_paging_utils/main/gifs/rpu_first_error.gif" alt="riverpod_paging_utils_first_error"> | <img src="https://raw.githubusercontent.com/K9i-0/riverpod_paging_utils/main/gifs/rpu_second_error.gif" alt="riverpod_paging_utils_second_error"> |
|:---:|:---:|:---:|

## Features

- `PagingHelperView`: A generic widget that simplifies the implementation of pagination in Flutter apps.
- `PagePagingNotifierMixin`: A mixin for implementing page-based pagination logic.
- `OffsetPagingNotifierMixin`: A mixin for implementing offset-based pagination logic.
- `CursorPagingNotifierMixin`: A mixin for implementing cursor-based pagination logic.

## Getting Started

### Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  riverpod_paging_utils: ^0.1.0
```

Then, run `flutter pub get` to install the package.

### Usage

Here's a simple example of how to use the `PagingHelperView` widget with a Riverpod provider that uses the `CursorPagingNotifierMixin`:

```dart
/// A Riverpod provider that mixes in [CursorPagingNotifierMixin].
/// This provider handles the pagination logic for fetching [SampleItem] data using cursor-based pagination.
@riverpod
class SampleNotifier extends _$SampleNotifier
    with CursorPagingNotifierMixin<SampleItem> {
  /// Builds the initial state of the provider by fetching data with a null cursor.
  @override
  Future<CursorPagingData<SampleItem>> build() => fetch(cursor: null);

  /// Fetches paginated data from the [SampleRepository] based on the provided [cursor].
  /// Returns a [CursorPagingData] object containing the fetched items, a flag indicating whether more data is available,
  /// and the next cursor for fetching the next page.
  @override
  Future<CursorPagingData<SampleItem>> fetch({
    required String? cursor,
  }) async {
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

/// A sample page that demonstrates the usage of [PagingHelperView] with the [SampleNotifier] provider.
class SampleScreen extends StatelessWidget {
  const SampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Screen'),
      ),
      body: PagingHelperView(
        provider: sampleNotifierProvider,
        futureRefreshable: sampleNotifierProvider.future,
        notifierRefreshable: sampleNotifierProvider.notifier,
        contentBuilder: (data, endItemView) => ListView.builder(
          itemCount: data.items.length + (endItemView != null ? 1 : 0),
          itemBuilder: (context, index) {
            // If the end item view is provided and the index is the last item,
            // return the end item view.
            if (endItemView != null && index == data.items.length) {
              return endItemView;
            }

            // Otherwise, build a list tile for each sample item.
            return ListTile(
              title: Text(data.items[index].name),
              subtitle: Text(data.items[index].id),
            );
          },
        ),
      ),
    );
  }
}
```