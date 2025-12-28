import 'package:flutter/material.dart';

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

  // Shadows - soft, wide blur
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 24,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 32,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
      ];

  // Feature gradients
  // Quests = coral
  static const LinearGradient questGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B6B), // Coral red
      Color(0xFFFF8E8E), // Light coral
      Color(0xFFFFB3B3), // Very light coral
    ],
  );

  // Drawer = indigo
  static const LinearGradient drawerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6B6BFF), // Indigo
      Color(0xFF8E8EFF), // Light indigo
      Color(0xFFB3B3FF), // Very light indigo
    ],
  );

  // Shopping = mint
  static const LinearGradient shoppingGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6BFFB3), // Mint
      Color(0xFF8EFFC7), // Light mint
      Color(0xFFB3FFDB), // Very light mint
    ],
  );

  // Planning = amber
  static const LinearGradient planningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFB36B), // Amber
      Color(0xFFFFC78E), // Light amber
      Color(0xFFFFDBB3), // Very light amber
    ],
  );

  // Focus area gradients
  // Clothes = coral
  static const LinearGradient clothesGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B6B),
      Color(0xFFFF8E8E),
    ],
  );

  // Skincare = mint
  static const LinearGradient skincareGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6BFFB3),
      Color(0xFF8EFFC7),
    ],
  );

  // Fitness = indigo
  static const LinearGradient fitnessGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6B6BFF),
      Color(0xFF8E8EFF),
    ],
  );

  // Cooking = amber
  static const LinearGradient cookingGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFB36B),
      Color(0xFFFFC78E),
    ],
  );

  // Text styles
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

