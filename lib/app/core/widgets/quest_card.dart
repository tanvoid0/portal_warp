import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';
import 'gradient_card.dart';

class QuestCard extends StatelessWidget {
  final String title;
  final String focusArea;
  final int durationMinutes;
  final Gradient gradient;
  final VoidCallback? onDone;
  final bool isCompleted;

  const QuestCard({
    super.key,
    required this.title,
    required this.focusArea,
    required this.durationMinutes,
    required this.gradient,
    this.onDone,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      gradient: gradient,
      onTap: isCompleted ? null : onDone,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingM,
                  vertical: DesignTokens.spacingS,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: Text(
                  focusArea.toUpperCase(),
                  style: DesignTokens.captionStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 24,
                ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingL),
          Text(
            title,
            style: DesignTokens.titleStyle.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingM),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: DesignTokens.spacingS),
              Text(
                '$durationMinutes min',
                style: DesignTokens.bodyStyle.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          if (!isCompleted && onDone != null) ...[
            const SizedBox(height: DesignTokens.spacingXL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    vertical: DesignTokens.spacingL,
                  ),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0, duration: 400.ms);
  }
}

