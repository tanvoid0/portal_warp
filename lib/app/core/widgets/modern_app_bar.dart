import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import '../theme/app_theme.dart';

/// Modern AppBar with enhanced styling
class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;
  final Color? backgroundColor;
  final double? elevation;

  const ModernAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.leading,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(
        title,
        style: DesignTokens.titleStyle.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation ?? 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: isDark
          ? Colors.black.withOpacity(0.3)
          : Colors.black.withOpacity(0.1),
      iconTheme: IconThemeData(
        color: theme.colorScheme.onSurface,
        size: 24,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(0),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

