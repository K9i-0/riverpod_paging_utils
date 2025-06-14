# Riverpod Paging Utils - 開発メモ

## プロジェクト概要
Riverpodを使用したページネーション実装を簡単にするFlutterパッケージ
- ページングデータの状態管理とローディング/エラー処理
- `PagingHelperView`ウィジェットとMixinの提供

## 開発タスク

### タスク1: テストの追加
1. `feature/add-tests`ブランチを作成
2. testディレクトリを作成
3. pubspec.yamlにtest依存を追加
4. テストファイルを作成
   - `test/paging_data_test.dart` - PagingDataクラスのユニットテスト
   - `test/paging_notifier_mixin_test.dart` - Mixinのユニットテスト
   - `test/paging_helper_view_test.dart` - ウィジェットテスト
5. すべてのテストがパスすることを確認
6. PRを作成（URL: https://github.com/K9i-0/riverpod_paging_utils/pull/new/feature/add-tests）

### 環境設定
- GitHub CLI (gh) がインストール済み
- miseで`.mise.toml`を使用しFlutter 3.27.0を管理
- miseでFlutter 3.27.0がインストール済み

### タスク2: Riverpod 3.0への移行
1. 新PRのために別ブランチ`feature/riverpod-3.0-migration`を作成
2. 依存関係の更新
   - `flutter_riverpod: ^3.0.0-dev.15`に更新
3. 破壊的変更への対応
   - AutoDisposeNotifierをNotifierに変更
   - Refのwatch機能をlistenに変更
   - updateShouldNotifyの挙動変更への対応
4. テストの実行と修正
5. exampleアプリの更新と動作確認
6. PRの作成と提出

## Riverpod 3.0の主な変更点
- **API変更**: AutoDisposeNotifierが非推奨となりNotifierに統合
- **Refパラメータの変更**: watchメソッドが削除されlistenのみ利用可能
- **updateShouldNotifyの挙動変更**: デフォルトの比較が`==`に変更
- **パフォーマンス**: 内部実装の最適化によりパフォーマンス向上

## コマンド集
```bash
# テスト実行
flutter test

# 依存関係の更新
flutter pub get

# ブランチ作成
git checkout -b feature/branch-name

# PR作成（gh CLI使用）
gh pr create --title "title" --body "description"
```