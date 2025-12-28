import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';

class QuantityCounter extends StatelessWidget {
  final int value;
  final int? target;
  final String unit;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const QuantityCounter({
    super.key,
    required this.value,
    this.target,
    required this.unit,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
  });

  double get progress {
    if (target == null || target == 0) return 0.0;
    return (value / target!).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingM,
        vertical: DesignTokens.spacingS,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: value > min ? () => onChanged(value - 1) : null,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(DesignTokens.spacingS),
              minimumSize: const Size(32, 32),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingM),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$value',
                    style: DesignTokens.titleStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (unit.isNotEmpty) ...[
                    const SizedBox(width: DesignTokens.spacingS),
                    Text(
                      unit,
                      style: DesignTokens.captionStyle.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
              if (target != null && target! > 0) ...[
                const SizedBox(height: 4),
                Text(
                  'of $target',
                  style: DesignTokens.captionStyle.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: progress >= 1.0 ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 200.ms)
                        .scaleX(begin: 0, end: 1, duration: 300.ms),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(width: DesignTokens.spacingM),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: value < max ? () => onChanged(value + 1) : null,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(DesignTokens.spacingS),
              minimumSize: const Size(32, 32),
            ),
          ),
        ],
      ),
    );
  }
}

