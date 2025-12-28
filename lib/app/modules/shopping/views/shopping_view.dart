import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/shopping_controller.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/shopping_card.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../data/models/shopping_item.dart';
import '../../../modules/main_navigation/main_navigation_controller.dart';
import '../../../routes/app_routes.dart';

class ShoppingView extends GetView<ShoppingController> {
  const ShoppingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Update navigation index if MainNavigationController exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MainNavigationController>()) {
        Get.find<MainNavigationController>().updateCurrentIndex(Routes.shopping);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        centerTitle: true,
        actions: [
          Obx(() => Switch(
                value: controller.showOnlyPending.value,
                onChanged: (value) => controller.showOnlyPending.value = value,
              )),
          const SizedBox(width: DesignTokens.spacingM),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'import_essentials') {
                await controller.importStarterEssentials();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Shopping essentials imported!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } else if (value == 'import_wardrobe') {
                await controller.importWardrobeBuyOrder();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wardrobe buy order imported!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import_essentials',
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart, size: 20),
                    SizedBox(width: 8),
                    Text('Import Shopping Essentials'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'import_wardrobe',
                child: Row(
                  children: [
                    Icon(Icons.checklist, size: 20),
                    SizedBox(width: 8),
                    Text('Import Wardrobe Buy Order'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddShoppingItemDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingL),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                  boxShadow: DesignTokens.softShadow,
                ),
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingL,
                      vertical: DesignTokens.spacingM,
                    ),
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: const Duration(milliseconds: 100))
                .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: const Duration(milliseconds: 100)),

            // Items List
            Expanded(
              child: controller.filteredItems.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(DesignTokens.spacingXL),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: DesignTokens.spacingL),
                            Text(
                              'No shopping items yet',
                              style: DesignTokens.titleStyle.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacingM),
                            // Starter Essentials Card
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: DesignTokens.spacingL),
                              padding: const EdgeInsets.all(DesignTokens.spacingL),
                              decoration: BoxDecoration(
                                gradient: DesignTokens.shoppingGradient,
                                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                                boxShadow: DesignTokens.softShadow,
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.shopping_cart,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  const SizedBox(height: DesignTokens.spacingM),
                                  Text(
                                    'Get Started',
                                    style: DesignTokens.titleStyle.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: DesignTokens.spacingS),
                                  Text(
                                    'Import shopping essentials or wardrobe buy order from the cheatsheet',
                                    style: DesignTokens.bodyStyle.copyWith(
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: DesignTokens.spacingL),
                                  Column(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          await controller.importStarterEssentials();
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Shopping essentials imported!'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.shopping_bag),
                                        label: const Text('Import Essentials'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color(0xFF6BFFB3),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: DesignTokens.spacingL,
                                            vertical: DesignTokens.spacingM,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: DesignTokens.spacingM),
                                      OutlinedButton.icon(
                                        onPressed: () async {
                                          await controller.importWardrobeBuyOrder();
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Wardrobe buy order imported!'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.checklist),
                                        label: const Text('Import Wardrobe Buy Order'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: const BorderSide(color: Colors.white),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: DesignTokens.spacingL,
                                            vertical: DesignTokens.spacingM,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacingM),
                            Text(
                              'Or tap + to add items manually',
                              style: DesignTokens.bodyStyle.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingL,
                      ),
                      itemCount: controller.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.filteredItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
                          child: ShoppingCard(
                            itemName: item.name,
                            category: item.category,
                            quantity: item.quantity,
                            priority: item.priority,
                            isPurchased: item.status.name == 'purchased',
                            unit: item.unit,
                            index: index,
                            onQuantityChanged: (newQuantity) {
                              controller.updateShoppingItem(
                                item.copyWith(quantity: newQuantity),
                              );
                            },
                            onTap: () {
                              if (item.status.name == 'pending') {
                                controller.markPurchased(item.id);
                              } else {
                                _showEditShoppingItemDialog(context, item);
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  void _showAddShoppingItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final quantityController = TextEditingController(text: '1');

    Get.dialog(
      AlertDialog(
        title: const Text('Add Shopping Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                hintText: 'e.g., Milk',
              ),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'e.g., Dairy',
              ),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final item = ShoppingItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  category: categoryController.text,
                  quantity: int.tryParse(quantityController.text) ?? 1,
                );
                controller.addShoppingItem(item);
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditShoppingItemDialog(BuildContext context, ShoppingItem item) {
    final nameController = TextEditingController(text: item.name);
    final categoryController = TextEditingController(text: item.category);
    final quantityController = TextEditingController(text: item.quantity.toString());

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Shopping Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updated = item.copyWith(
                name: nameController.text,
                category: categoryController.text,
                quantity: int.tryParse(quantityController.text) ?? 1,
              );
              controller.updateShoppingItem(updated);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
