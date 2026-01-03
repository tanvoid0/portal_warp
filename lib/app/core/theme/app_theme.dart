import 'package:flutter/material.dart';
import 'design_tokens.dart';

/// Custom color scheme extension for app-specific colors
class AppColorScheme {
  final ColorScheme colorScheme;
  final Brightness brightness;

  AppColorScheme({
    required this.colorScheme,
    required this.brightness,
  });

  bool get isDark => brightness == Brightness.dark;

  // Feature colors - Quest/Planning (warm tones)
  Color get questPrimary => isDark ? const Color(0xFFFF8A80) : const Color(0xFFFF6B6B);
  Color get questSecondary => isDark ? const Color(0xFFFFB3B3) : const Color(0xFFFF8E8E);
  Color get questTertiary => isDark ? const Color(0xFFFFCCCB) : const Color(0xFFFFB3B3);

  // Feature colors - Drawer (cool tones)
  Color get drawerPrimary => isDark ? const Color(0xFF7986CB) : const Color(0xFF6B6BFF);
  Color get drawerSecondary => isDark ? const Color(0xFF9FA8DA) : const Color(0xFF8E8EFF);
  Color get drawerTertiary => isDark ? const Color(0xFFC5CAE9) : const Color(0xFFB3B3FF);

  // Feature colors - Shopping (fresh tones)
  Color get shoppingPrimary => isDark ? const Color(0xFF81C784) : const Color(0xFF6BFFB3);
  Color get shoppingSecondary => isDark ? const Color(0xFFA5D6A7) : const Color(0xFF8EFFC7);
  Color get shoppingTertiary => isDark ? const Color(0xFFC8E6C9) : const Color(0xFFB3FFDB);

  // Feature colors - Planning (red accent tones)
  Color get planningPrimary => isDark ? const Color(0xFFFF8A80) : const Color(0xFFFF6B6B);
  Color get planningSecondary => isDark ? const Color(0xFFFFB3B3) : const Color(0xFFFF8E8E);
  Color get planningTertiary => isDark ? const Color(0xFFFFCCCB) : const Color(0xFFFFB3B3);

  // Semantic colors
  Color get success => isDark ? const Color(0xFF66BB6A) : const Color(0xFF4CAF50);
  Color get warning => isDark ? const Color(0xFFFFA726) : const Color(0xFFFF9800);
  Color get error => isDark ? const Color(0xFFEF5350) : const Color(0xFFF44336);
  Color get info => isDark ? const Color(0xFF42A5F5) : const Color(0xFF2196F3);

  // Text colors for gradients (ensures proper contrast)
  Color get textOnGradient => isDark ? Colors.white : Colors.white;
  Color get textOnGradientSecondary => isDark ? Colors.white70 : Colors.white70;

  // Surface overlay colors
  Color get surfaceOverlay => isDark 
      ? Colors.white.withOpacity(0.1) 
      : Colors.white.withOpacity(0.2);
  Color get surfaceOverlayLight => isDark
      ? Colors.white.withOpacity(0.05)
      : Colors.white.withOpacity(0.15);
}

extension AppColorSchemeExtension on ColorScheme {
  AppColorScheme get app => AppColorScheme(
        colorScheme: this,
        brightness: brightness,
      );
}

class AppTheme {
  // Modern color palette - centralized primary and secondary
  static const Color primaryColor = Color(0xFF6366F1); // Modern indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Modern purple
  static const Color accentColor = Color(0xFFEC4899); // Modern pink accent

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: DesignTokens.headlineStyle.copyWith(
          color: colorScheme.onSurface,
        ),
        displayMedium: DesignTokens.titleStyle.copyWith(
          color: colorScheme.onSurface,
        ),
        bodyLarge: DesignTokens.bodyStyle.copyWith(
          color: colorScheme.onSurface,
        ),
        bodyMedium: DesignTokens.bodyStyle.copyWith(
          color: colorScheme.onSurface,
        ),
        bodySmall: DesignTokens.captionStyle.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: 24,
        ),
        titleTextStyle: DesignTokens.titleStyle.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.05),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingXL,
            vertical: DesignTokens.spacingL,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 6,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary.withOpacity(0.5);
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withOpacity(0.2),
        valueIndicatorColor: colorScheme.primary,
        valueIndicatorTextStyle: DesignTokens.captionStyle.copyWith(
          color: colorScheme.onPrimary,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return colorScheme.surfaceContainerHighest;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.onPrimary;
            }
            return colorScheme.onSurface;
          }),
          side: WidgetStateProperty.all(
            BorderSide(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: const Color(0xFF818CF8), // Lighter indigo for dark theme
      secondary: const Color(0xFFA78BFA), // Lighter purple for dark theme
      tertiary: const Color(0xFFF472B6), // Lighter pink for dark theme
      brightness: Brightness.dark,
      surfaceContainerHighest: const Color(0xFF2C2C2C),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: DesignTokens.headlineStyle.copyWith(
          color: colorScheme.onSurface,
        ),
        displayMedium: DesignTokens.titleStyle.copyWith(
          color: colorScheme.onSurface,
        ),
        bodyLarge: DesignTokens.bodyStyle.copyWith(
          color: colorScheme.onSurface,
        ),
        bodyMedium: DesignTokens.bodyStyle.copyWith(
          color: colorScheme.onSurface,
        ),
        bodySmall: DesignTokens.captionStyle.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: 24,
        ),
        titleTextStyle: DesignTokens.titleStyle.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.05),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingXL,
            vertical: DesignTokens.spacingL,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 6,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary.withOpacity(0.5);
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withOpacity(0.2),
        valueIndicatorColor: colorScheme.primary,
        valueIndicatorTextStyle: DesignTokens.captionStyle.copyWith(
          color: colorScheme.onPrimary,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return colorScheme.surfaceContainerHighest;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.onPrimary;
            }
            return colorScheme.onSurface;
          }),
          side: WidgetStateProperty.all(
            BorderSide(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
