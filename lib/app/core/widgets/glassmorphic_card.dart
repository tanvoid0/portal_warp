import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';
import '../theme/app_theme.dart';

/// Enhanced glassmorphic card with better blur and transparency effects
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final double blur;
  final double opacity;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final int? index; // For staggered animations

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.gradient,
    this.blur = 10.0,
    this.opacity = 0.2,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.colorScheme.app;
    final isDark = theme.brightness == Brightness.dark;

    // Default gradient if not provided
    final cardGradient = gradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(isDark ? 0.15 : 0.1),
            theme.colorScheme.secondary.withOpacity(isDark ? 0.1 : 0.05),
          ],
        );

    Widget card = Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusL),
        boxShadow: DesignTokens.softShadow(context),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusL),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              gradient: cardGradient,
              borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusL),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusL),
                splashColor: appColors.textOnGradient.withOpacity(0.1),
                highlightColor: appColors.textOnGradient.withOpacity(0.05),
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(DesignTokens.spacingL),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (index != null) {
      card = card
          .animate()
          .fadeIn(
            duration: 300.ms,
            delay: Duration(milliseconds: index! * 50),
          )
          .slideY(
            begin: 0.1,
            end: 0,
            duration: 400.ms,
            delay: Duration(milliseconds: index! * 50),
          );
    }

    return card;
  }
}

