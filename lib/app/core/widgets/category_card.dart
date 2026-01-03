import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/design_tokens.dart';

/// Reusable category card component
/// 
/// Provides a consistent card layout for category navigation.
/// Features an icon, title, description, gradient background, and navigation.
class CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String? route;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;

  const CategoryCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.route,
    this.onTap,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = gradientColors ?? [
      theme.colorScheme.primary.withOpacity(0.1),
      theme.colorScheme.primary.withOpacity(0.05),
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          } else if (route != null) {
            Get.toNamed(route!);
          }
        },
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingM),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DesignTokens.titleStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingXS),
                    Text(
                      description,
                      style: DesignTokens.bodyStyle.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

