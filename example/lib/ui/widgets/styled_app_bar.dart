import 'package:example/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// A styled app bar with optional gradient background
class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StyledAppBar({
    required this.title,
    super.key,
    this.leading,
    this.actions,
    this.bottom,
    this.useGradient = false,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    if (useGradient) {
      return DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.heroGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AppBar(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: leading,
          actions: actions,
          bottom: bottom,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      );
    }

    return AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
