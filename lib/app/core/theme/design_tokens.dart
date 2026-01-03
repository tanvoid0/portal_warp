import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Design tokens for Portal Warp
/// Provides consistent spacing, radii, shadows, gradients, and text styles
class DesignTokens {
  // Spacing scale
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 24.0;
  static const double spacingXXL = 32.0;

  // Corner radii
  static const double radiusM = 16.0;
  static const double radiusL = 24.0;
  static const double radiusXL = 32.0;

  // Theme-aware shadows
  static List<BoxShadow> softShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withOpacity(0.3)
            : Colors.black.withOpacity(0.08),
        blurRadius: 24,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> mediumShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withOpacity(0.4)
            : Colors.black.withOpacity(0.12),
        blurRadius: 32,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
    ];
  }


  // Theme-aware feature gradients
  static LinearGradient questGradient(BuildContext context) {
    final appColors = Theme.of(context).colorScheme.app;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        appColors.questPrimary,
        appColors.questSecondary,
        appColors.questTertiary,
      ],
    );
  }

  static LinearGradient drawerGradient(BuildContext context) {
    final appColors = Theme.of(context).colorScheme.app;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        appColors.drawerPrimary,
        appColors.drawerSecondary,
        appColors.drawerTertiary,
      ],
    );
  }

  static LinearGradient shoppingGradient(BuildContext context) {
    final appColors = Theme.of(context).colorScheme.app;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        appColors.shoppingPrimary,
        appColors.shoppingSecondary,
        appColors.shoppingTertiary,
      ],
    );
  }

  static LinearGradient planningGradient(BuildContext context) {
    final appColors = Theme.of(context).colorScheme.app;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        appColors.planningPrimary,
        appColors.planningSecondary,
        appColors.planningTertiary,
      ],
    );
  }

  // Theme-aware focus area gradients
  static LinearGradient clothesGradient(BuildContext context) {
    final appColors = Theme.of(context).colorScheme.app;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        appColors.questPrimary,
        appColors.questSecondary,
      ],
    );
  }

  static LinearGradient skincareGradient(BuildContext context) {
    final appColors = Theme.of(context).colorScheme.app;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        appColors.shoppingPrimary,
        appColors.shoppingSecondary,
      ],
    );
  }

  static LinearGradient fitnessGradient(BuildContext context) {
    final appColors = Theme.of(context).colorScheme.app;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        appColors.drawerPrimary,
        appColors.drawerSecondary,
      ],
    );
  }

  static LinearGradient cookingGradient(BuildContext context) {
    final appColors = Theme.of(context).colorScheme.app;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        appColors.planningPrimary,
        appColors.planningSecondary,
      ],
    );
  }


  // Text styles (now theme-aware via AppTheme)
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: 0.2,
  );
}
