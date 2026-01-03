import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/shopping_controller.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/shopping_card.dart';
import '../../../core/widgets/modern_app_bar.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/unsplash_service.dart';
import '../../../data/models/shopping_item.dart';
import '../../../modules/main_navigation/main_navigation_controller.dart';
import '../../../routes/app_routes.dart';
import 'shopping_item_detail_view.dart';

class ShoppingView extends GetView<ShoppingController> {
  const ShoppingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Update navigation index if MainNavigationController exists
    // Note: Shopping is now accessed via Items tab, so map to items route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MainNavigationController>()) {
        Get.find<MainNavigationController>().updateCurrentIndex(Routes.items);
      }
    });

    // Check if we're inside ItemsView (no app bar needed)
    final isInItemsView = Get.currentRoute == Routes.items;
    
    return Scaffold(
      appBar: isInItemsView ? null : ModernAppBar(
        title: 'Shopping List',
        leading: null,
        actions: [
          // Sort and Group Controls
          Obx(() => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sort Button
              IconButton(
                icon: Icon(
                  controller.sortAscending.value 
                      ? Icons.arrow_upward 
                      : Icons.arrow_downward,
                  size: 20,
                ),
                onPressed: () {
                  controller.sortAscending.value = !controller.sortAscending.value;
                },
                tooltip: 'Sort ${controller.sortAscending.value ? "Ascending" : "Descending"}',
              ),
              // Sort Options Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort, size: 20),
                tooltip: 'Sort by',
                onSelected: (value) {
                  controller.sortBy.value = value;
                },
                itemBuilder: (context) => controller.sortOptions.map((option) {
                  return PopupMenuItem(
                    value: option,
                    child: Row(
                      children: [
                        if (controller.sortBy.value == option)
                          Icon(
                            Icons.check,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        else
                          const SizedBox(width: 16),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(option[0].toUpperCase() + option.substring(1)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              // Group Toggle
              Obx(() => IconButton(
                icon: Icon(
                  controller.groupByCategory.value 
                      ? Icons.view_list 
                      : Icons.view_module,
                  size: 20,
                ),
                onPressed: () {
                  controller.groupByCategory.value = !controller.groupByCategory.value;
                },
                tooltip: controller.groupByCategory.value 
                    ? 'Ungroup' 
                    : 'Group by category',
              )),
            ],
          )),
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
                    SnackBar(
                      content: const Text('Shopping essentials imported!'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height - 120,
                        left: 16,
                        right: 16,
                      ),
                    ),
                  );
                }
              } else if (value == 'import_wardrobe') {
                await controller.importWardrobeBuyOrder();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Wardrobe buy order imported!'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height - 120,
                        left: 16,
                        right: 16,
                      ),
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'shopping_fab',
        onPressed: () => _showAddShoppingItemDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        return Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingL),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                  boxShadow: DesignTokens.softShadow(context),
                ),
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                              child: CachedNetworkImage(
                                imageUrl: UnsplashService.getEmptyStateImageUrlForScreen('shopping'),
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacingL),
                            Text(
                              'No shopping items yet',
                              style: DesignTokens.titleStyle.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacingM),
                            // Starter Essentials Card
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: DesignTokens.spacingL),
                              padding: const EdgeInsets.all(DesignTokens.spacingL),
                              decoration: BoxDecoration(
                          gradient: DesignTokens.shoppingGradient(context),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                          boxShadow: DesignTokens.softShadow(context),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.shopping_cart,
                                    color: Theme.of(context).colorScheme.app.textOnGradient,
                                    size: 32,
                                  ),
                                  const SizedBox(height: DesignTokens.spacingM),
                                  Text(
                                    'Get Started',
                                    style: DesignTokens.titleStyle.copyWith(
                                      color: Theme.of(context).colorScheme.app.textOnGradient,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: DesignTokens.spacingS),
                                  Text(
                                    'Import shopping essentials or wardrobe buy order from the cheatsheet',
                                    style: DesignTokens.bodyStyle.copyWith(
                                      color: Theme.of(context).colorScheme.app.textOnGradientSecondary,
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
                                              SnackBar(
                                                content: const Text('Shopping essentials imported!'),
                                                duration: const Duration(seconds: 2),
                                                behavior: SnackBarBehavior.floating,
                                                margin: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context).size.height - 120,
                                                  left: 16,
                                                  right: 16,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.shopping_bag),
                                        label: const Text('Import Essentials'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).colorScheme.app.textOnGradient,
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
                                              SnackBar(
                                                content: const Text('Wardrobe buy order imported!'),
                                                duration: const Duration(seconds: 2),
                                                behavior: SnackBarBehavior.floating,
                                                margin: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context).size.height - 120,
                                                  left: 16,
                                                  right: 16,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.checklist),
                                        label: const Text('Import Wardrobe Buy Order'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Theme.of(context).colorScheme.app.textOnGradient,
                                          side: BorderSide(color: Theme.of(context).colorScheme.app.textOnGradient),
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
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Obx(() {
                      if (controller.groupByCategory.value) {
                        // Grouped view
                        final grouped = controller.groupedItems;
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingL,
                          ),
                          itemCount: grouped.length,
                          itemBuilder: (context, index) {
                            final categories = grouped.keys.toList();
                            final category = categories[index];
                            final items = grouped[category]!;
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category Header
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: DesignTokens.spacingL,
                                    bottom: DesignTokens.spacingM,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        category,
                                        style: DesignTokens.titleStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(width: DesignTokens.spacingS),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: DesignTokens.spacingS,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(DesignTokens.spacingS),
                                        ),
                                        child: Text(
                                          '${items.length}',
                                          style: DesignTokens.captionStyle.copyWith(
                                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Items in category
                                ...items.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
                                  child: ShoppingCard(
                                    itemName: item.name,
                                    category: item.category,
                                    quantity: item.quantity,
                                    priority: item.priority,
                                    isPurchased: item.status.name == 'purchased',
                                    unit: item.unit,
                                    index: items.indexOf(item),
                                    onQuantityChanged: (newQuantity) {
                                      controller.updateShoppingItem(
                                        item.copyWith(quantity: newQuantity),
                                      );
                                    },
                                    onTap: () {
                                      Get.to(() => ShoppingItemDetailView(item: item));
                                    },
                                  ),
                                )),
                              ],
                            );
                          },
                        );
                      } else {
                        // Flat list view
                        return ListView.builder(
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
                                  Get.to(() => ShoppingItemDetailView(item: item));
                                },
                              ),
                            );
                          },
                        );
                      }
                    }),
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
