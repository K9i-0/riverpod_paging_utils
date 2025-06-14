# Riverpod Paging Utils - Riverpod 3.0移行計画

## エグゼクティブサマリー

本ドキュメントは、`riverpod_paging_utils`パッケージをRiverpod 2.6.1から3.0.0-dev.15への移行計画を記載したものです。Riverpod 3.0は多くの改善と新機能を含む一方、いくつかの破壊的変更も含まれているため、慎重な移行が必要です。

### 主な目標
- 既存のAPIとの互換性を可能な限り維持
- 新機能（Mutation API、オフライン永続化）の活用検討
- プレリリース版として段階的にリリース
- ユーザーへの影響を最小限に抑える

## 背景と目的

### なぜRiverpod 3.0に移行するか
1. **パフォーマンスの向上**: 内部実装の最適化
2. **新機能の活用**: Mutation APIによるページネーション実装の簡素化
3. **APIの統一**: AutoDisposeインターフェースの簡略化
4. **自動リトライ機能**: ネットワークエラー時の復元力向上
5. **将来性**: Riverpod 4.0への移行準備

### 移行のリスク
- 破壊的変更による既存ユーザーへの影響
- 実験的機能（Mutation API）の今後の変更可能性
- 依存関係の競合（analyzer 7.0以上が必要）

## 技術的な変更点

### 1. 破壊的変更

#### 1.1 AutoDisposeインターフェースの削除
```dart
// Before (2.x)
class PagingNotifier extends AutoDisposeAsyncNotifier<PagingData<T>> {
  // ...
}

// After (3.0)
class PagingNotifier extends AsyncNotifier<PagingData<T>> {
  // ...
}
```

#### 1.2 Refの型パラメータ削除
```dart
// Before (2.x)
Future<int> value(FutureProviderRef<int> ref) {
  // ...
}

// After (3.0)
Future<int> build() { // Notifier内で直接使用
  // ...
}
```

#### 1.3 ProviderObserver APIの変更
```dart
// Before (2.x)
void didAddProvider(ProviderBase provider, Object? value, ProviderContainer container) {
  // ...
}

// After (3.0)
void didAddProvider(ProviderObserverContext context, Object? value) {
  // ...
}
```

#### 1.4 エラーハンドリングの変更
```dart
// Before (2.x)
try {
  await ref.read(myProvider.future);
} on SpecificException {
  // ...
}

// After (3.0)
try {
  await ref.read(myProvider.future);
} on ProviderException catch (e) {
  if (e.exception is SpecificException) {
    // ...
  }
}
```

#### 1.5 更新フィルタリングの変更
- すべてのプロバイダーが`identical`の代わりに`==`を使用
- `updateShouldNotify`メソッドでカスタマイズ可能

### 2. 新機能

#### 2.1 Mutation API（実験的）
```dart
@riverpod
class PagingNotifier extends _$PagingNotifier {
  @override
  Future<PagingData<T>> build() async {
    // 初期データの取得
  }

  @mutation
  Future<void> loadNextPage() async {
    // 次のページを読み込む
    // UIは自動的にローディング状態を表示できる
  }
}
```

#### 2.2 自動リトライ機能
```dart
// プロバイダーレベルでの設定
@Riverpod(retry: customRetryLogic)
class MyNotifier extends _$MyNotifier {
  // ...
}

// グローバル設定
ProviderScope(
  retry: (retryCount, error) {
    if (error is NetworkException && retryCount < 3) {
      return Duration(seconds: retryCount * 2);
    }
    return null; // リトライしない
  },
  child: MyApp(),
)
```

#### 2.3 Ref.mounted
```dart
class MyNotifier extends AsyncNotifier<Data> {
  Future<void> someAsyncOperation() async {
    await Future.delayed(Duration(seconds: 1));
    
    // 非同期操作後にプロバイダーが破棄されていないかチェック
    if (ref.mounted) {
      state = AsyncData(newData);
    }
  }
}
```

## 移行手順

### フェーズ1: 準備（1週間）

1. **現状分析**
   - 既存コードの依存関係を確認
   - テストカバレッジの確認
   - 影響を受けるコードの特定

2. **開発環境の準備**
   - 新しいブランチ`feature/riverpod-3.0-migration`の作成
   - CI/CDパイプラインの設定更新準備

### フェーズ2: 基本的な移行（2週間）

1. **依存関係の更新**
   ```yaml
   dependencies:
     flutter_riverpod: ^3.0.0-dev.15
   
   dependency_overrides:
     analyzer: ^7.0.0
     test: ^1.25.8
     test_api: ^0.7.3
   ```

2. **コードの修正**
   - `AutoDisposeAsyncNotifier`を`AsyncNotifier`に変更
   - テストコードの更新
   - エラーハンドリングの更新

3. **テストの実行と修正**
   ```bash
   melos bs
   flutter test
   ```

### フェーズ3: 新機能の実装（オプション、3週間）

1. **Mutation APIを使用した新しい実装**
   - `mutation_paging_notifier.dart`の作成
   - `mutation_paging_helper_view.dart`の作成
   - 使用例の作成

2. **既存APIとの共存**
   - 既存のAPIを維持しつつ、新しいAPIを追加
   - ドキュメントで両方のアプローチを説明

### フェーズ4: テストとドキュメント（1週間）

1. **包括的なテスト**
   - ユニットテスト
   - ウィジェットテスト
   - 統合テスト

2. **ドキュメントの更新**
   - README.mdの更新
   - CHANGELOG.mdの更新
   - 移行ガイドの作成

### フェーズ5: リリース（1週間）

1. **プレリリース版の公開**
   - バージョン`0.9.0-dev.1`として公開
   - pub.devでのプレリリースタグ

2. **フィードバックの収集**
   - GitHubのIssueでフィードバックを収集
   - 必要に応じて修正

## テスト戦略

### 1. 後方互換性テスト
- 既存のAPIが引き続き動作することを確認
- 既存のexampleアプリが正常に動作することを確認

### 2. 新機能テスト
- Mutation APIの動作確認
- 自動リトライ機能のテスト
- エラーハンドリングのテスト

### 3. パフォーマンステスト
- ページネーションのパフォーマンスが劣化していないことを確認
- メモリリークがないことを確認

## ロールバック計画

問題が発生した場合のロールバック手順：

1. **即座の対応**
   - プレリリース版を非推奨としてマーク
   - ユーザーに2.x系の使用を推奨

2. **修正とリトライ**
   - 問題の根本原因を特定
   - 修正版をプレリリースとして再公開

3. **コミュニケーション**
   - GitHubのIssueで状況を説明
   - 移行タイムラインの再評価

## 今後の展望

### 短期的（3-6ヶ月）
- Riverpod 3.0の安定版リリースを待つ
- ユーザーフィードバックに基づく改善
- Mutation APIの成熟を待つ

### 長期的（6-12ヶ月）
- Riverpod 4.0への準備
- オフライン永続化機能の統合検討
- より高度なページネーション機能の追加

## 付録

### A. 依存関係の競合解決

Riverpod 3.0はanalyzer 7.0以上を要求するため、以下の設定が必要：

```yaml
dependency_overrides:
  analyzer: ^7.0.0
  test: ^1.25.8
  test_api: ^0.7.3
```

### B. Mutation APIの詳細例

```dart
@riverpod
class PagingMutationNotifier extends _$PagingMutationNotifier {
  @override
  Future<PagingData<Item>> build() async {
    return _fetchInitialPage();
  }

  @mutation
  Future<void> loadNextPage() async {
    final currentData = await future;
    final nextPage = await _fetchPage(currentData.nextPageKey);
    
    state = AsyncData(PagingData(
      items: [...currentData.items, ...nextPage.items],
      hasMore: nextPage.hasMore,
      nextPageKey: nextPage.nextPageKey,
    ));
  }

  @mutation
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// UI側の実装
class PagingListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingData = ref.watch(pagingMutationNotifierProvider);
    final loadNextPage = ref.watch(pagingMutationNotifierProvider.loadNextPage);

    return pagingData.when(
      data: (data) => ListView.builder(
        itemCount: data.items.length + (data.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == data.items.length) {
            // 最後のアイテム = ローディングインジケーター
            return switch (loadNextPage.state) {
              MutationIdle() => ElevatedButton(
                onPressed: () => loadNextPage(),
                child: Text('Load More'),
              ),
              MutationPending() => CircularProgressIndicator(),
              MutationErrored(:final error) => Column(
                children: [
                  Text('Error: $error'),
                  ElevatedButton(
                    onPressed: () => loadNextPage(),
                    child: Text('Retry'),
                  ),
                ],
              ),
              MutationSucceeded() => SizedBox.shrink(),
            };
          }
          
          return ListTile(
            title: Text(data.items[index].title),
          );
        },
      ),
      error: (error, stack) => Text('Error: $error'),
      loading: () => CircularProgressIndicator(),
    );
  }
}
```

### C. 参考リンク

- [Riverpod 3.0 Migration Guide](https://riverpod.dev/docs/3.0_migration)
- [What's new in Riverpod 3.0](https://riverpod.dev/docs/whats_new)
- [Riverpod GitHub Repository](https://github.com/rrousselGit/riverpod)
- [flutter_riverpod 3.0.0-dev.15 on pub.dev](https://pub.dev/packages/flutter_riverpod/versions/3.0.0-dev.15)