import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';
import 'gradient_card.dart';
import '../../data/models/item_unit.dart';
import 'quantity_counter.dart';

class ShoppingCard extends StatelessWidget {
  final String itemName;
  final String? category;
  final int quantity;
  final int priority;
  final bool isPurchased;
  final VoidCallback? onTap;
  final int? index; // For staggered animations
  final ItemUnit? unit;
  final ValueChanged<int>? onQuantityChanged;

  const ShoppingCard({
    super.key,
    required this.itemName,
    this.category,
    this.quantity = 1,
    this.priority = 1,
    this.isPurchased = false,
    this.onTap,
    this.index,
    this.unit,
    this.onQuantityChanged,
  });

  Color _getPriorityColor() {
    if (priority >= 4) return Colors.red.shade300;
    if (priority >= 3) return Colors.orange.shade300;
    return Colors.white70;
  }

  IconData _getPriorityIcon() {
    if (priority >= 4) return Icons.priority_high;
    if (priority >= 3) return Icons.flag;
    return Icons.shopping_bag;
  }

  @override
  Widget build(BuildContext context) {
    final cardContent = GradientCard(
      gradient: DesignTokens.shoppingGradient,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Checkbox with animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Checkbox(
                  value: isPurchased,
                  onChanged: onTap != null ? (_) => onTap?.call() : null,
                  fillColor: WidgetStateProperty.all(
                    isPurchased ? Colors.green : Colors.white,
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
                            itemName,
                            style: DesignTokens.bodyStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              decoration: isPurchased
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                        if (!isPurchased && priority >= 3)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingS,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor().withOpacity(0.3),
                              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                            ),
                            child: Icon(
                              _getPriorityIcon(),
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacingS),
                    Row(
                      children: [
                        if (category != null && category!.isNotEmpty) ...[
                          Icon(
                            Icons.category,
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
                          const SizedBox(width: DesignTokens.spacingM),
                        ],
                        if (quantity > 1 || unit != null) ...[
                          Icon(
                            Icons.numbers,
                            color: Colors.white70,
                            size: 14,
                          ),
                          const SizedBox(width: DesignTokens.spacingS),
                          Text(
                            '$quantity ${unit?.displayName ?? ''}',
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
              if (isPurchased)
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade100,
                  size: 24,
                ),
            ],
          ),
          // Quantity counter below if editable
          if (onQuantityChanged != null && !isPurchased) ...[
            const SizedBox(height: DesignTokens.spacingM),
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingS),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              ),
              child: QuantityCounter(
                value: quantity,
                unit: unit?.displayName ?? '',
                onChanged: onQuantityChanged!,
                min: 1,
                max: 999,
              ),
            ),
          ],
        ],
      ),
    );

    return cardContent
        .animate()
        .fadeIn(duration: 300.ms, delay: Duration(milliseconds: (index ?? 0) * 50))
        .slideX(begin: -0.1, end: 0, duration: 400.ms, delay: Duration(milliseconds: (index ?? 0) * 50));
  }
}
