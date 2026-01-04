# Riverpod 3 対応 新設計 (v1.0)

## 設計方針

1. **Mutationは使わない** - ページングは「データ読み込み」であり「副作用」ではない
2. **状態分離** - 追加ロード状態をPagingData内で管理
3. **copyWithPrevious不要** - AsyncData内でデータを維持するため不要に
4. **ユーザーAPI最小変更** - 既存の使い方をできるだけ維持

---

## 1. PagingData 構造

### 現在 (v0.8)

```dart
@freezed
abstract class PagePagingData<T> with _$PagePagingData<T> implements PagingData<T> {
  const factory PagePagingData({
    required List<T> items,
    required bool hasMore,
    required int page,
  }) = _PagePagingData<T>;
}
```

### 新設計 (v1.0)

```dart
/// 追加ロードの状態
enum LoadNextStatus {
  /// アイドル状態（ロード可能）
  idle,
  /// ロード中
  loading,
  /// エラー発生（リトライ可能）
  error,
}

/// 共通インターフェース
@internal
abstract interface class PagingData<T> {
  List<T> get items;
  bool get hasMore;

  // 新規追加
  LoadNextStatus get loadNextStatus;
  Object? get loadNextError;
  StackTrace? get loadNextStackTrace;

  /// ロード中かどうか
  bool get isLoadingNext => loadNextStatus == LoadNextStatus.loading;

  /// エラーがあるかどうか
  bool get hasLoadNextError => loadNextStatus == LoadNextStatus.error;
}

@freezed
abstract class PagePagingData<T> with _$PagePagingData<T> implements PagingData<T> {
  const factory PagePagingData({
    required List<T> items,
    required bool hasMore,
    required int page,
    // 新規追加（デフォルト値あり = 後方互換性）
    @Default(LoadNextStatus.idle) LoadNextStatus loadNextStatus,
    @Default(null) Object? loadNextError,
    @Default(null) StackTrace? loadNextStackTrace,
  }) = _PagePagingData<T>;
}

@freezed
abstract class OffsetPagingData<T> with _$OffsetPagingData<T> implements PagingData<T> {
  const factory OffsetPagingData({
    required List<T> items,
    required bool hasMore,
    required int offset,
    @Default(LoadNextStatus.idle) LoadNextStatus loadNextStatus,
    @Default(null) Object? loadNextError,
    @Default(null) StackTrace? loadNextStackTrace,
  }) = _OffsetPagingData<T>;
}

@freezed
abstract class CursorPagingData<T> with _$CursorPagingData<T> implements PagingData<T> {
  const factory CursorPagingData({
    required List<T> items,
    required bool hasMore,
    required String? nextCursor,
    @Default(LoadNextStatus.idle) LoadNextStatus loadNextStatus,
    @Default(null) Object? loadNextError,
    @Default(null) StackTrace? loadNextStackTrace,
  }) = _CursorPagingData<T>;
}
```

---

## 2. Mixin 設計

### 現在 (v0.8)

```dart
abstract interface class PagingNotifierMixin<D extends PagingData<T>, T> {
  AsyncValue<D> get state;
  set state(AsyncValue<D> newState);
  Ref<AsyncValue<D>> get ref;  // 型パラメータあり

  Future<void> loadNext();
  void forceRefresh();
}

abstract mixin class PagePagingNotifierMixin<T>
    implements PagingNotifierMixin<PagePagingData<T>, T> {
  Future<PagePagingData<T>> fetch({required int page});

  @override
  Future<void> loadNext() async {
    final value = state.valueOrNull;  // valueOrNull使用
    if (value == null) return;

    if (value.hasMore) {
      // copyWithPrevious 使用（Riverpod 3で使用不可）
      state = AsyncLoading<PagePagingData<T>>().copyWithPrevious(state);

      state = await state.guardPreservingPreviousOnError(
        () async {
          final next = await fetch(page: value.page + 1);
          return value.copyWith(
            items: [...value.items, ...next.items],
            page: value.page + 1,
            hasMore: next.hasMore,
          );
        },
      );
    }
  }
}
```

### 新設計 (v1.0)

```dart
/// Riverpod 3対応: Refの型パラメータを削除
@internal
abstract interface class PagingNotifierMixin<D extends PagingData<T>, T> {
  AsyncValue<D> get state;
  set state(AsyncValue<D> newState);
  Ref get ref;  // 型パラメータなし

  Future<void> loadNext();
  void forceRefresh();
}

abstract mixin class PagePagingNotifierMixin<T>
    implements PagingNotifierMixin<PagePagingData<T>, T> {

  /// ユーザーが実装するフェッチメソッド
  Future<PagePagingData<T>> fetch({required int page});

  @override
  Future<void> loadNext() async {
    // Riverpod 3: valueOrNull → value
    final value = state.value;
    if (value == null) return;

    // 既にロード中 or これ以上データがない場合は何もしない
    if (value.isLoadingNext || !value.hasMore) return;

    // ローディング状態に更新（データは維持）
    // copyWithPrevious 不要！AsyncData内で状態を管理
    state = AsyncData(value.copyWith(
      loadNextStatus: LoadNextStatus.loading,
      loadNextError: null,
      loadNextStackTrace: null,
    ));

    try {
      final next = await fetch(page: value.page + 1);

      // 成功: アイテムを追加し、状態をidleに
      state = AsyncData(value.copyWith(
        items: [...value.items, ...next.items],
        page: value.page + 1,
        hasMore: next.hasMore,
        loadNextStatus: LoadNextStatus.idle,
      ));
    } catch (e, st) {
      // エラー: データは維持し、エラー状態に
      state = AsyncData(value.copyWith(
        loadNextStatus: LoadNextStatus.error,
        loadNextError: e,
        loadNextStackTrace: st,
      ));
    }
  }

  @override
  void forceRefresh() {
    // 初期ロード状態に戻す（データは破棄）
    state = const AsyncLoading();
    ref.invalidateSelf();
  }
}

// OffsetPagingNotifierMixin, CursorPagingNotifierMixin も同様のパターン
```

---

## 3. PagingHelperView 設計

### 現在 (v0.8)

```dart
final class PagingHelperView<D extends PagingData<I>, I> extends ConsumerWidget {
  const PagingHelperView({
    required this.provider,
    required this.futureRefreshable,
    required this.notifierRefreshable,
    required this.contentBuilder,
    this.showSecondPageError = true,
    super.key,
  });

  final ProviderListenable<AsyncValue<D>> provider;
  final Refreshable<Future<D>> futureRefreshable;
  final Refreshable<PagingNotifierMixin<D, I>> notifierRefreshable;
  final Widget Function(D data, int widgetCount, Widget endItemView) contentBuilder;
  final bool showSecondPageError;
}
```

### 新設計 (v1.0)

```dart
final class PagingHelperView<D extends PagingData<I>, I> extends ConsumerWidget {
  const PagingHelperView({
    required this.provider,
    required this.futureRefreshable,
    required this.notifierRefreshable,
    required this.contentBuilder,
    // showSecondPageError は削除（PagingData内の状態で判断）
    super.key,
  });

  final ProviderListenable<AsyncValue<D>> provider;
  final Refreshable<Future<D>> futureRefreshable;
  final Refreshable<PagingNotifierMixin<D, I>> notifierRefreshable;

  /// [endItemView] の意味が変わる:
  /// - hasMore=true & idle: VisibilityDetector + ローディング表示
  /// - hasMore=true & loading: ローディング表示
  /// - hasMore=true & error: エラー + リトライボタン
  /// - hasMore=false: 空のWidget
  final Widget Function(D data, int widgetCount, Widget endItemView) contentBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<PagingHelperViewTheme>();

    final loadingBuilder = theme?.loadingViewBuilder ?? _defaultLoadingBuilder;
    final errorBuilder = theme?.errorViewBuilder ?? _defaultErrorBuilder;

    return ref.watch(provider).when(
      data: (data) {
        final content = contentBuilder(
          data,
          data.items.length + 1,
          _buildEndItemView(context, ref, data, theme),
        );

        final enableRefreshIndicator = theme?.enableRefreshIndicator ?? true;

        if (enableRefreshIndicator) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(futureRefreshable),
            child: content,
          );
        }
        return content;
      },
      // 初回ロード中
      loading: () => loadingBuilder(context),
      // 初回エラー
      error: (e, st) => errorBuilder(
        context,
        e,
        st,
        () => ref.read(notifierRefreshable).forceRefresh(),
      ),
    );
  }

  /// endItemView を構築
  Widget _buildEndItemView(
    BuildContext context,
    WidgetRef ref,
    D data,
    PagingHelperViewTheme? theme,
  ) {
    // これ以上データがない場合
    if (!data.hasMore) {
      return const SizedBox.shrink();
    }

    // 状態に応じてWidgetを返す
    return switch (data.loadNextStatus) {
      // アイドル: VisibilityDetectorで自動ロード
      LoadNextStatus.idle => _EndVDLoadingItemView(
        onScrollEnd: () => ref.read(notifierRefreshable).loadNext(),
      ),
      // ローディング中
      LoadNextStatus.loading => _EndLoadingItemView(),
      // エラー: リトライボタン表示
      LoadNextStatus.error => _EndErrorItemView(
        error: data.loadNextError,
        onRetryButtonPressed: () => ref.read(notifierRefreshable).loadNext(),
      ),
    };
  }
}
```

---

## 4. ユーザーコードの変更

### 現在 (v0.8)

```dart
@riverpod
class PageBasedNotifier extends _$PageBasedNotifier
    with PagePagingNotifierMixin<SampleItem> {
  @override
  Future<PagePagingData<SampleItem>> build() => fetch(page: 1);

  @override
  Future<PagePagingData<SampleItem>> fetch({required int page}) async {
    final repository = ref.read(sampleRepositoryProvider);
    final (items, hasMore) = await repository.getByPage(page: page, limit: 50);

    return PagePagingData(
      items: items,
      hasMore: hasMore,
      page: page,
    );
  }
}
```

### 新設計 (v1.0)

```dart
// ユーザーコードは変更なし！
// 新しいフィールドはデフォルト値があるので互換性維持
@riverpod
class PageBasedNotifier extends _$PageBasedNotifier
    with PagePagingNotifierMixin<SampleItem> {
  @override
  Future<PagePagingData<SampleItem>> build() => fetch(page: 1);

  @override
  Future<PagePagingData<SampleItem>> fetch({required int page}) async {
    final repository = ref.read(sampleRepositoryProvider);
    final (items, hasMore) = await repository.getByPage(page: page, limit: 50);

    return PagePagingData(
      items: items,
      hasMore: hasMore,
      page: page,
      // loadNextStatus, loadNextError はデフォルトでidleなので指定不要
    );
  }
}
```

### UIコード

```dart
// UIコードも変更なし！
PagingHelperView(
  provider: pageBasedNotifierProvider,
  futureRefreshable: pageBasedNotifierProvider.future,
  notifierRefreshable: pageBasedNotifierProvider.notifier,
  contentBuilder: (data, widgetCount, endItemView) => ListView.builder(
    itemCount: widgetCount,
    itemBuilder: (context, index) {
      if (index == widgetCount - 1) {
        return endItemView;
      }
      return ListTile(
        title: Text(data.items[index].name),
      );
    },
  ),
)
```

---

## 5. 削除される機能

### whenIgnorableError 拡張メソッド

```dart
// 現在: AsyncValueを拡張してエラー時もデータを表示
extension _AsyncValueX<T> on AsyncValue<T> {
  R whenIgnorableError<R>({...}) { ... }
}

// 新設計: 不要（PagingData内でエラー状態を管理するため）
// 通常のAsyncValue.when()を使用
```

### guardPreservingPreviousOnError 拡張メソッド

```dart
// 現在: エラー時に前のデータを保持
extension _AsyncValueX<T> on AsyncValue<T> {
  Future<AsyncValue<T>> guardPreservingPreviousOnError(...) { ... }
}

// 新設計: 不要（try-catchで直接処理）
```

---

## 6. 依存関係の更新

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^3.0.0  # 2.6.1 → 3.0.0
  freezed_annotation: ^3.0.0
  visibility_detector: ^0.4.0+2
```

---

## 7. マイグレーションガイド

### 破壊的変更

1. **Riverpod 3.0 必須**
   - `flutter_riverpod: ^3.0.0` に更新

2. **showSecondPageError パラメータ削除**
   - 代わりに `PagingData.loadNextStatus` で判断

### 非破壊的変更

1. **PagingData に新フィールド追加**
   - `loadNextStatus`, `loadNextError`, `loadNextStackTrace`
   - デフォルト値があるため既存コードは動作

2. **ユーザーのNotifier/UIコード**
   - 変更不要

---

## 8. 将来の拡張

### オプション1: カスタム endItemView

```dart
PagingHelperView(
  // 現在のAPIを維持しつつ、カスタマイズ可能に
  endItemViewBuilder: (context, data, defaultView) {
    // カスタムUIを返すことも可能
    return defaultView;
  },
)
```

### オプション2: プログレス表示

```dart
@freezed
abstract class PagePagingData<T> {
  const factory PagePagingData({
    // ...
    @Default(null) double? loadNextProgress,  // 0.0 〜 1.0
  }) = _PagePagingData<T>;
}
```

---

## 9. 比較表

| 観点 | v0.8 (現在) | v1.0 (新設計) |
|------|-------------|---------------|
| Riverpod | 2.x | 3.x |
| 状態管理 | AsyncValue + copyWithPrevious | AsyncData内で完結 |
| エラー時データ保持 | copyWithPrevious | PagingData.loadNextError |
| Ref型パラメータ | `Ref<AsyncValue<D>>` | `Ref` |
| valueOrNull | 使用 | value に変更 |
| ユーザーNotifierコード | 変更必要 | **変更不要** |
| ユーザーUIコード | 変更必要 | **変更不要** |
| showSecondPageError | パラメータ | 削除（自動判断） |
