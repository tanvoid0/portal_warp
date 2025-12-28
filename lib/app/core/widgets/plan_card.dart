import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';
import 'gradient_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      gradient: DesignTokens.planningGradient,
      onTap: onTap,
      child: Row(
        children: [
          // Checkbox with animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Checkbox(
              value: isCompleted,
              onChanged: onTap != null ? (_) => onTap?.call() : null,
              fillColor: WidgetStateProperty.all(
                isCompleted ? Colors.green : Colors.white,
              ),
              checkColor: Colors.white,
              side: BorderSide(
                color: Colors.white.withOpacity(0.5),
                width: 2,
              ),
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
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                    if (isCompleted)
                      Icon(
                        Icons.check_circle,
                        color: Colors.green.shade100,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingS),
                Row(
                  children: [
                    if (category != null && category!.isNotEmpty) ...[
                      Icon(
                        Icons.label,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: DesignTokens.spacingS),
                      Text(
                        category!,
                        style: DesignTokens.captionStyle.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      if (time != null) const SizedBox(width: DesignTokens.spacingM),
                    ],
                    if (time != null) ...[
                      Icon(
                        Icons.access_time,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: DesignTokens.spacingS),
                      Text(
                        time!,
                        style: DesignTokens.captionStyle.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: Duration(milliseconds: (index ?? 0) * 50))
        .slideX(begin: -0.1, end: 0, duration: 400.ms, delay: Duration(milliseconds: (index ?? 0) * 50));
  }
}
