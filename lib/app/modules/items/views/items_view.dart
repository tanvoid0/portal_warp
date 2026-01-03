import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/items_controller.dart';
import '../../../core/widgets/modern_app_bar.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../modules/main_navigation/main_navigation_controller.dart';
import '../../../routes/app_routes.dart';
import '../../inventory/wardrobe/views/wardrobe_view.dart';
import '../../shopping/views/shopping_view.dart';

class ItemsView extends GetView<ItemsController> {
  const ItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Update navigation index if MainNavigationController exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MainNavigationController>()) {
        Get.find<MainNavigationController>().updateCurrentIndex(Routes.items);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        centerTitle: true,
        leading: null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Obx(() => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    label: 'Inventory',
                    icon: Icons.inventory_2,
                    isSelected: controller.selectedTab.value == 0,
                    onTap: () => controller.selectTab(0),
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    label: 'Shopping',
                    icon: Icons.shopping_cart,
                    isSelected: controller.selectedTab.value == 1,
                    onTap: () => controller.selectTab(1),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: Obx(() => IndexedStack(
        index: controller.selectedTab.value,
        children: const [
          WardrobeView(),
          ShoppingView(),
        ],
      )),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: DesignTokens.spacingM,
          horizontal: DesignTokens.spacingL,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: DesignTokens.spacingS),
            Text(
              label,
              style: DesignTokens.bodyStyle.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

