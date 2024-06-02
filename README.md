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
  riverpod_paging_utils: ^{latest}
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

## UI Customization

### Basic Customization

You can easily customize the appearance of loading and error states using `ThemeExtension`.

<img src="https://raw.githubusercontent.com/K9i-0/riverpod_paging_utils/main/gifs/ui_customization.gif" alt="riverpod_paging_utils_sample" width="33%">

For example, if you're using the [loading_animation_widget](https://pub.dev/packages/loading_animation_widget) package, you can set up your code like this:

```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          PagingHelperViewTheme(
            loadingViewBuilder: (context) => Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topCenter,
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  color: Colors.red,
                  size: 100,
                ),
              ),
            ),
            endLoadingViewBuilder: (context) =>
                LoadingAnimationWidget.threeArchedCircle(
              color: Colors.red,
              size: 50,
            ),
          ),
        ],
      ),
      home: const SampleScreen(),
    );
  }
}
```

A complete sample implementation can be found in the [example/lib/main2.dart](https://github.com/K9i-0/riverpod_paging_utils/blob/main/example/lib/main2.dart) file.

### Advanced Customization

Customizing the appearance of error SnackBars or RefreshIndicators requires a bit more setup.

#### 1. Theme Configuration

First, adjust your `PagingHelperViewTheme` like this:

```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          PagingHelperViewTheme(
            // disable error snackbar
            enableErrorSnackBar: false,
            // disable pull-to-refresh
            enableRefreshIndicator: false,
          ),
        ],
      ),
      home: const SampleScreen(),
    );
  }
}
```

#### 2. Integrating Custom Refresh (e.g., with easy_refresh)

If you're using a package like [easy_refresh](https://pub.dev/packages/easy_refresh) to provide a RefreshIndicator, modify your screen code as follows:

```dart
class SampleScreen extends ConsumerWidget {
  const SampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced UI Customization'),
      ),
      body: PagingHelperView(
        provider: sampleNotifierProvider,
        futureRefreshable: sampleNotifierProvider.future,
        notifierRefreshable: sampleNotifierProvider.notifier,
        contentBuilder: (data, endItemView) {
          // Use EasyRefresh alternative to RefreshIndicator
          return EasyRefresh(
            onRefresh: () {
              ref.invalidate(sampleNotifierProvider);
              return ref.read(sampleNotifierProvider.future);
            },
            child: ListView.builder(
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
          );
        },
      ),
    );
  }
}
```

A complete sample implementation can be found in the [example/lib/main3.dart](https://github.com/K9i-0/riverpod_paging_utils/blob/main/example/lib/main3.dart) file.
