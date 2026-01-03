import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';
import '../theme/app_theme.dart';

/// Modern stat card component for displaying metrics with icons, values, and trends
class ModernStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? gradientStart;
  final Color? gradientEnd;
  final String? trend; // e.g., "+12%", "-5%"
  final bool isPositiveTrend;
  final VoidCallback? onTap;
  final int? index; // For staggered animations

  const ModernStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    this.gradientStart,
    this.gradientEnd,
    this.trend,
    this.isPositiveTrend = true,
    this.onTap,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.colorScheme.app;
    final isDark = theme.brightness == Brightness.dark;

    // Use provided colors or fall back to theme colors
    final startColor = gradientStart ?? theme.colorScheme.primary;
    final endColor = gradientEnd ?? theme.colorScheme.secondary;
    final iconBgColor = iconColor ?? theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            startColor.withOpacity(isDark ? 0.2 : 0.1),
            endColor.withOpacity(isDark ? 0.15 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: DesignTokens.softShadow(context),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(DesignTokens.spacingM),
                      decoration: BoxDecoration(
                        color: iconBgColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      ),
                      child: Icon(
                        icon,
                        color: iconBgColor,
                        size: 24,
                      ),
                    ),
                    // Trend indicator
                    if (trend != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingS,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (isPositiveTrend
                                  ? appColors.success
                                  : appColors.error)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositiveTrend
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              size: 14,
                              color: isPositiveTrend
                                  ? appColors.success
                                  : appColors.error,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trend!,
                              style: DesignTokens.captionStyle.copyWith(
                                color: isPositiveTrend
                                    ? appColors.success
                                    : appColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingM),
                // Value
                Text(
                  value,
                  style: DesignTokens.headlineStyle.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXS),
                // Label
                Text(
                  label,
                  style: DesignTokens.bodyStyle.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 300.ms,
          delay: Duration(milliseconds: (index ?? 0) * 100),
        )
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 400.ms,
          delay: Duration(milliseconds: (index ?? 0) * 100),
        );
  }
}

