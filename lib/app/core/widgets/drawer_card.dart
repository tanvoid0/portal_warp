import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';
import 'gradient_card.dart';
import '../../data/models/item_unit.dart';
import 'quantity_counter.dart';

class DrawerCard extends StatelessWidget {
  final String title;
  final String status;
  final bool isOrganized;
  final VoidCallback? onTap;
  final int? index; // For staggered animations
  final int? currentQuantity;
  final int? targetQuantity;
  final ItemUnit? unit;
  final ValueChanged<int>? onQuantityChanged;

  const DrawerCard({
    super.key,
    required this.title,
    required this.status,
    this.isOrganized = false,
    this.onTap,
    this.index,
    this.currentQuantity,
    this.targetQuantity,
    this.unit,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      gradient: DesignTokens.drawerGradient,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingS),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    ),
                    child: Icon(
                      isOrganized ? Icons.check_circle : Icons.inventory_2,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  Text(
                    'DRAWER',
                    style: DesignTokens.captionStyle.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingM,
                  vertical: DesignTokens.spacingS,
                ),
                decoration: BoxDecoration(
                  color: isOrganized
                      ? Colors.green.withOpacity(0.3)
                      : Colors.orange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isOrganized ? Icons.check : Icons.schedule,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: DesignTokens.spacingS),
                    Text(
                      isOrganized ? 'Organized' : 'Needs Work',
                      style: DesignTokens.captionStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingL),
          Text(
            title,
            style: DesignTokens.titleStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingS),
          Row(
            children: [
              Icon(
                Icons.category,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: DesignTokens.spacingS),
              Expanded(
                child: Text(
                  status,
                  style: DesignTokens.bodyStyle.copyWith(
                    color: Colors.white70,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (currentQuantity != null && onQuantityChanged != null) ...[
            const SizedBox(height: DesignTokens.spacingL),
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingM),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              ),
              child: QuantityCounter(
                value: currentQuantity!,
                target: targetQuantity,
                unit: unit?.displayName ?? '',
                onChanged: onQuantityChanged!,
                min: 0,
                max: targetQuantity != null && targetQuantity! > 0 ? targetQuantity! * 2 : 999,
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: Duration(milliseconds: (index ?? 0) * 50))
        .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: Duration(milliseconds: (index ?? 0) * 50))
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 300.ms, delay: Duration(milliseconds: (index ?? 0) * 50));
  }
}
