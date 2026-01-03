import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../modules/main_navigation/main_navigation_controller.dart';
import '../theme/design_tokens.dart';
import '../theme/app_theme.dart';

/// Modern bottom navigation bar with animations and glassmorphic design
class ModernBottomNavBar extends StatelessWidget {
  const ModernBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<MainNavigationController>()) {
      return const SizedBox.shrink();
    }

    final controller = Get.find<MainNavigationController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingXS,
            vertical: 2,
          ),
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: controller.navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = controller.currentIndex.value == index;

              return Expanded(
                child: _NavItem(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => controller.changePage(index),
                  index: index,
                ),
              );
            }).toList(),
          )),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.colorScheme.app;

    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated icon container
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(isSelected ? 5 : 3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                ),
                child: Icon(
                  item.icon,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                  size: isSelected ? 22 : 20,
                )
                    .animate(target: isSelected ? 1 : 0)
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      duration: 300.ms,
                      curve: Curves.elasticOut,
                    ),
              ),
              const SizedBox(height: 1),
              // Label
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: DesignTokens.captionStyle.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 9,
                  height: 1.1,
                ),
              ),
              // Active indicator
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                      duration: 300.ms,
                      curve: Curves.elasticOut,
                    ),
            ],
          ),
        ),
      );
  }
}

