import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/modern_app_bar.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/category_card.dart';
import '../../../routes/app_routes.dart';
import '../../../core/theme/design_tokens.dart';
import '../controllers/inventory_controller.dart' as inventory;
class InventoryView extends GetView<inventory.InventoryController> {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModernAppBar(
        title: 'Inventory',
        leading: null,
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: ListView(
        padding: const EdgeInsets.all(DesignTokens.spacingL),
        children: [
          CategoryCard(
            title: 'Wardrobe',
            description: 'Manage your clothing items',
            icon: Icons.checkroom,
            route: '${Routes.inventory}/wardrobe',
            gradientColors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
            ],
          ),
          // Future: Add more inventory categories here
          // CategoryCard(
          //   title: 'Electronics',
          //   description: 'Manage your electronic devices',
          //   icon: Icons.devices,
          //   route: '${Routes.inventory}/electronics',
          // ),
        ],
      ),
    );
  }
}

