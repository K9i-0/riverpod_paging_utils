# Design Guidelines - OSS Sample App

このドキュメントは画面間の統一感を保つためのデザインガイドラインです。

## カラーパレット

### アバター用カラー（統一）
```dart
const colors = [
  Color(0xFF6366F1), // Indigo
  Color(0xFF14B8A6), // Teal
  Color(0xFFF97316), // Orange
  Color(0xFF8B5CF6), // Purple
  Color(0xFF06B6D4), // Cyan
  Color(0xFFEC4899), // Pink
];
```

### 使用ルール
- アバターの色は `item.name.hashCode.abs() % colors.length` で決定
- グラデーションは `color` → `color.withValues(alpha: 0.75)`

## タイポグラフィ

### タイトル（ユーザー名など）
- FontWeight: `w600`
- FontSize: `16`
- LetterSpacing: `0.1`

### サブテキスト（ID番号など）
- FontWeight: `w400`
- FontSize: `12`
- Color alpha: `0.45`
- 形式: `#1`, `#2`, `#3`...

## スペーシング

### カード間
- Vertical padding: `8`
- Horizontal padding: `16`

### カード内
- Padding: `16` (all sides)
- Avatar to text gap: `16`
- Title to subtitle gap: `6`

## シャドウ

### カードシャドウ
- Light mode: `Colors.black.withValues(alpha: 0.1)`
- Dark mode: `Colors.black.withValues(alpha: 0.35)`
- BlurRadius: `12`
- Offset: `Offset(0, 4)`

### アバターシャドウ
- Color: `avatarColor.withValues(alpha: 0.3)`
- BlurRadius: `8`
- Offset: `Offset(0, 3)`

## アイコン

### 矢印アイコン（chevron）
- Icon: `Icons.chevron_right_rounded`
- Size: `22`
- Color alpha: `0.3`
- **背景なし**（シンプルに）

## ヘッダー

### 共通スタイル
- Gradient: `AppColors.heroGradient`
- BorderRadius (bottom): `28`
- ClipRRect使用で丸みの外を透明に

### タイトル構成
- メインタイトル: 20px, w600, white
- サブタイトル: 12px, w400, white70

## 避けるべきこと

- ❌ 矢印アイコンに背景ボックスを付ける
- ❌ アバターの色をindexで決定（hashCodeを使う）
- ❌ IDを単なる数字で表示（#プレフィックスを付ける）
- ❌ カード間の余白を狭くしすぎる
