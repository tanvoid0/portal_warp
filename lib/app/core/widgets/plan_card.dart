import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';
import '../theme/app_theme.dart';

class PlanCard extends StatelessWidget {
  final String title;
  final String? time;
  final String? category;
  final bool isCompleted;
  final VoidCallback? onTap;
  final int? index; // For staggered animations

  const PlanCard({
    super.key,
    required this.title,
    this.time,
    this.category,
    this.isCompleted = false,
    this.onTap,
    this.index,
  });

  IconData _getPlanIcon() {
    final lowerTitle = title.toLowerCase();
    final lowerCategory = category?.toLowerCase() ?? '';
    
    if (lowerTitle.contains('meeting') || lowerTitle.contains('call')) {
      return Icons.phone;
    }
    if (lowerTitle.contains('workout') || lowerTitle.contains('exercise') || lowerTitle.contains('gym')) {
      return Icons.fitness_center;
    }
    if (lowerTitle.contains('meal') || lowerTitle.contains('lunch') || lowerTitle.contains('dinner')) {
      return Icons.restaurant;
    }
    if (lowerTitle.contains('shopping') || lowerTitle.contains('store')) {
      return Icons.shopping_cart;
    }
    if (lowerTitle.contains('doctor') || lowerTitle.contains('appointment') || lowerTitle.contains('medical')) {
      return Icons.medical_services;
    }
    if (lowerCategory.contains('work') || lowerCategory.contains('business')) {
      return Icons.business;
    }
    if (lowerCategory.contains('personal') || lowerCategory.contains('self')) {
      return Icons.person;
    }
    if (lowerCategory.contains('social') || lowerCategory.contains('event')) {
      return Icons.event;
    }
    
    return Icons.calendar_today;
  }

  @override
  Widget build(BuildContext context) {
    final planIcon = _getPlanIcon();
    final theme = Theme.of(context);
    final appColors = theme.colorScheme.app;
    
    return Container(
      decoration: BoxDecoration(
        gradient: DesignTokens.planningGradient(context),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        boxShadow: DesignTokens.softShadow(context),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          splashColor: appColors.textOnGradient.withOpacity(0.2),
          highlightColor: appColors.textOnGradient.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingL),
            child: Row(
              children: [
                // Icon component
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: appColors.surfaceOverlay,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  ),
                  child: Icon(
                    planIcon,
                    color: appColors.textOnGradient,
                    size: 28,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: DesignTokens.bodyStyle.copyWith(
                                color: appColors.textOnGradient,
                                fontWeight: FontWeight.w600,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                          // Checkbox
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: Checkbox(
                              value: isCompleted,
                              onChanged: onTap != null ? (_) => onTap?.call() : null,
                              fillColor: WidgetStateProperty.all(
                                isCompleted ? appColors.success : appColors.textOnGradient,
                              ),
                              checkColor: appColors.textOnGradient,
                              side: BorderSide(
                                color: appColors.textOnGradient.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.spacingS),
                      Wrap(
                        spacing: DesignTokens.spacingS,
                        runSpacing: DesignTokens.spacingS,
                        children: [
                          if (category != null && category!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: DesignTokens.spacingS,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: appColors.textOnGradient.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                border: Border.all(
                                  color: appColors.textOnGradient.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.label_outline,
                                    color: appColors.textOnGradient,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    category!,
                                    style: DesignTokens.captionStyle.copyWith(
                                      color: appColors.textOnGradient,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (time != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: DesignTokens.spacingS,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: appColors.textOnGradientSecondary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: appColors.textOnGradientSecondary,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    time!,
                                    style: DesignTokens.captionStyle.copyWith(
                                      color: appColors.textOnGradientSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: Duration(milliseconds: (index ?? 0) * 50))
        .slideX(begin: -0.1, end: 0, duration: 400.ms, delay: Duration(milliseconds: (index ?? 0) * 50));
  }
}
