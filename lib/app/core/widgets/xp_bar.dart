import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';

class XPBar extends StatelessWidget {
  final int currentXP;
  final int maxXP;
  final double height;

  const XPBar({
    super.key,
    required this.currentXP,
    required this.maxXP,
    this.height = 12.0,
  });

  double get progress => maxXP > 0 ? (currentXP / maxXP).clamp(0.0, 1.0) : 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'XP',
              style: DesignTokens.captionStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$currentXP / $maxXP',
              style: DesignTokens.captionStyle,
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingS),
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: Colors.grey[200],
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height / 2),
                gradient: DesignTokens.questGradient,
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .scaleX(
                  begin: 0,
                  end: 1,
                  duration: 500.ms,
                  curve: Curves.easeOut,
                ),
          ),
        ),
      ],
    );
  }
}

