import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';
import '../theme/app_theme.dart';
import '../services/item_icon_service.dart';
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

  Color _getPriorityColor(BuildContext context) {
    final appColors = Theme.of(context).colorScheme.app;
    if (priority >= 4) return appColors.error;
    if (priority >= 3) return appColors.warning;
    return appColors.textOnGradientSecondary;
  }

  IconData _getPriorityIcon() {
    if (priority >= 4) return Icons.priority_high;
    if (priority >= 3) return Icons.flag;
    return Icons.shopping_bag;
  }

  @override
  Widget build(BuildContext context) {
    final itemIcon = ItemIconService.getShoppingIcon(itemName, category);
    final appColors = Theme.of(context).colorScheme.app;
    
    final cardContent = Container(
      decoration: BoxDecoration(
        gradient: DesignTokens.shoppingGradient(context),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        itemIcon,
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
                                  itemName,
                                  style: DesignTokens.bodyStyle.copyWith(
                                    color: appColors.textOnGradient,
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
                                    color: _getPriorityColor(context).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                  ),
                                  child: Icon(
                                    _getPriorityIcon(),
                                    color: appColors.textOnGradient,
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
                                  color: appColors.textOnGradientSecondary,
                                  size: 14,
                                ),
                                const SizedBox(width: DesignTokens.spacingS),
                                Text(
                                  category!,
                                  style: DesignTokens.captionStyle.copyWith(
                                    color: appColors.textOnGradientSecondary,
                                  ),
                                ),
                                const SizedBox(width: DesignTokens.spacingM),
                              ],
                              if (quantity > 1 || unit != null) ...[
                                Icon(
                                  Icons.numbers,
                                  color: appColors.textOnGradientSecondary,
                                  size: 14,
                                ),
                                const SizedBox(width: DesignTokens.spacingS),
                                Text(
                                  '$quantity ${unit?.displayName ?? ''}',
                                  style: DesignTokens.captionStyle.copyWith(
                                    color: appColors.textOnGradientSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Checkbox
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Checkbox(
                        value: isPurchased,
                        onChanged: onTap != null ? (_) => onTap?.call() : null,
                        fillColor: WidgetStateProperty.all(
                          isPurchased ? appColors.success : appColors.textOnGradient,
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
                // Quantity counter below if editable
                if (onQuantityChanged != null && !isPurchased) ...[
                  const SizedBox(height: DesignTokens.spacingM),
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingS),
                    decoration: BoxDecoration(
                      color: appColors.surfaceOverlayLight,
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
          ),
        ),
      ),
    );

    return cardContent
        .animate()
        .fadeIn(duration: 300.ms, delay: Duration(milliseconds: (index ?? 0) * 50))
        .slideX(begin: -0.1, end: 0, duration: 400.ms, delay: Duration(milliseconds: (index ?? 0) * 50));
  }
}
