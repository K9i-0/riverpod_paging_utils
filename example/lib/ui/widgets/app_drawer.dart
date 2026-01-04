import 'dart:async';

import 'package:example/ui/custom_scroll_view_screen.dart';
import 'package:example/ui/first_page_error_screen.dart';
import 'package:example/ui/gridview_screen.dart';
import 'package:example/ui/paging_method_screen.dart';
import 'package:example/ui/passing_args_screen.dart';
import 'package:example/ui/second_page_error_screen.dart';
import 'package:example/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// A styled drawer with gradient header and menu items
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSectionTitle(context, 'Examples'),
                _DrawerMenuItem(
                  icon: Icons.grid_view_rounded,
                  title: 'GridView Example',
                  subtitle: 'Grid layout with pagination',
                  onTap: () => _navigateTo(context, GridViewScreen.route()),
                ),
                _DrawerMenuItem(
                  icon: Icons.view_list_rounded,
                  title: 'CustomScrollView',
                  subtitle: 'Sliver-based pagination',
                  onTap:
                      () =>
                          _navigateTo(context, CustomScrollViewScreen.route()),
                ),
                _DrawerMenuItem(
                  icon: Icons.swap_horiz_rounded,
                  title: 'Paging Methods',
                  subtitle: 'Page, Offset, Cursor',
                  onTap: () => _navigateTo(context, PagingMethodScreen.route()),
                ),
                _DrawerMenuItem(
                  icon: Icons.data_object_rounded,
                  title: 'Passing Arguments',
                  subtitle: 'Custom args to provider',
                  onTap: () => _navigateTo(context, PassingArgsScreen.route()),
                ),
                const Divider(height: 32),
                _buildSectionTitle(context, 'Error Handling'),
                _DrawerMenuItem(
                  icon: Icons.error_outline_rounded,
                  title: '1st Page Error',
                  subtitle: 'Initial load error',
                  iconColor: Colors.orange,
                  onTap:
                      () => _navigateTo(context, FirstPageErrorScreen.route()),
                ),
                _DrawerMenuItem(
                  icon: Icons.warning_amber_rounded,
                  title: '2nd Page Error',
                  subtitle: 'Pagination error',
                  iconColor: Colors.red,
                  onTap:
                      () => _navigateTo(context, SecondPageErrorScreen.route()),
                ),
              ],
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.layers_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Riverpod Paging',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Example App',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        'v1.0.0',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _navigateTo(BuildContext context, Route<void> route) {
    final navigator = Navigator.of(context);
    navigator.pop();
    unawaited(navigator.push(route));
  }
}

class _DrawerMenuItem extends StatelessWidget {
  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (iconColor ?? theme.colorScheme.primary).withValues(
                      alpha: 0.12,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
