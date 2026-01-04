import 'package:example/data/sample_item.dart';
import 'package:example/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// A styled card widget for displaying sample items
class ItemCard extends StatelessWidget {
  const ItemCard({
    required this.item,
    required this.index,
    super.key,
    this.onTap,
  });

  final SampleItem item;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      // 改善2: カード間の余白を広げて視覚的分離を強化
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // 改善2: 影を強調して立体感を向上
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildAvatar(context),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 改善1: ユーザー名をより目立たせる
                        Text(
                          item.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // 改善1: IDをより控えめに表示（#プレフィックス付き）
                        Text(
                          '#${index + 1}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.45,
                            ),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // シンプルな矢印アイコン
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    // 改善3: 調和の取れたカラーパレット（彩度・明度を統一）
    const colors = [
      Color(0xFF6366F1), // Indigo
      Color(0xFF14B8A6), // Teal
      Color(0xFFF97316), // Orange
      Color(0xFF8B5CF6), // Purple
      Color(0xFF06B6D4), // Cyan
      Color(0xFFEC4899), // Pink
    ];

    // 改善3: ユーザー名のハッシュから色を決定（一貫性のある配色）
    final colorIndex = item.name.hashCode.abs() % colors.length;
    final color = colors[colorIndex];

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

/// A styled grid card widget for displaying sample items
class GridItemCard extends StatelessWidget {
  const GridItemCard({
    required this.item,
    required this.index,
    super.key,
    this.onTap,
  });

  final SampleItem item;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // グラデーション: 2番目の色をより明るくしてコントラストを強調
    final gradients = [
      [const Color(0xFF667EEA), const Color(0xFF9F7AEA)], // Purple系をより明るく
      [const Color(0xFF00BFA6), const Color(0xFF5EEAD4)], // Tealをより明るく
      [const Color(0xFFFF6B6B), const Color(0xFFFFB3B3)], // Redをより明るく
      [const Color(0xFFFFBE0B), const Color(0xFFFFF176)], // Yellowをより明るく
      [const Color(0xFF6C63FF), const Color(0xFFC4B5FD)], // Indigoをより明るく
      [const Color(0xFF00D4FF), const Color(0xFF67E8F9)], // Cyanをより明るく
    ];

    final gradient = gradients[index % gradients.length];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                // シャドウを強化: より広いblurRadius、より深いoffset
                color: gradient[0].withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '#${index + 1}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
