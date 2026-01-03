import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';
import '../theme/app_theme.dart';
import '../services/item_icon_service.dart';
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
  final List<String>? styles; // Style/occasion tags

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
    this.styles,
  });

  @override
  Widget build(BuildContext context) {
    // Extract category from status (format: "category • location" or just "category")
    final category = status.contains(' • ') ? status.split(' • ').first : status;
    final itemIcon = ItemIconService.getDrawerIcon(title, category);
    final appColors = Theme.of(context).colorScheme.app;
    
    return Container(
      decoration: BoxDecoration(
        gradient: DesignTokens.drawerGradient(context),
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
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingM,
              vertical: DesignTokens.spacingS,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon component - smaller
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: appColors.surfaceOverlay,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  ),
                  child: Icon(
                    itemIcon,
                    color: appColors.textOnGradient,
                    size: 20,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: DesignTokens.bodyStyle.copyWith(
                                color: appColors.textOnGradient,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: DesignTokens.spacingXS),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingS,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isOrganized
                                  ? appColors.success.withOpacity(0.3)
                                  : appColors.warning.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(DesignTokens.spacingS),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isOrganized ? Icons.check : Icons.schedule,
                                  color: appColors.textOnGradient,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isOrganized ? 'Done' : 'Needs Work',
                                  style: DesignTokens.captionStyle.copyWith(
                                    color: appColors.textOnGradient,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              status,
                              style: DesignTokens.captionStyle.copyWith(
                                color: appColors.textOnGradientSecondary,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Style tags
                          if (styles != null && styles!.isNotEmpty) ...[
                            const SizedBox(width: DesignTokens.spacingXS),
                            ...styles!.take(2).map((style) => Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: appColors.surfaceOverlay.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(DesignTokens.spacingS),
                                ),
                                child: Text(
                                  style,
                                  style: DesignTokens.captionStyle.copyWith(
                                    color: appColors.textOnGradient,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )),
                            if (styles!.length > 2)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: appColors.surfaceOverlay.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(DesignTokens.spacingS),
                                  ),
                                  child: Text(
                                    '+${styles!.length - 2}',
                                    style: DesignTokens.captionStyle.copyWith(
                                      color: appColors.textOnGradient,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                          if (currentQuantity != null) ...[
                            const SizedBox(width: DesignTokens.spacingXS),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: onQuantityChanged != null && currentQuantity! > 0
                                      ? () => onQuantityChanged!(currentQuantity! - 1)
                                      : null,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: appColors.surfaceOverlay,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      size: 14,
                                      color: appColors.textOnGradient,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    '${currentQuantity}${targetQuantity != null && targetQuantity! > 0 ? '/$targetQuantity' : ''} ${unit?.displayName ?? ''}',
                                    style: DesignTokens.captionStyle.copyWith(
                                      color: appColors.textOnGradient,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (onQuantityChanged != null)
                                  GestureDetector(
                                    onTap: () => onQuantityChanged!(currentQuantity! + 1),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: appColors.surfaceOverlay,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 14,
                                        color: appColors.textOnGradient,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
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
        .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: Duration(milliseconds: (index ?? 0) * 50))
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 300.ms, delay: Duration(milliseconds: (index ?? 0) * 50));
  }
}
