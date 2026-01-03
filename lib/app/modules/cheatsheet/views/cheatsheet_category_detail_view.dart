import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portal_warp/app/routes/app_routes.dart';
import '../controllers/cheatsheet_controller.dart';
import '../../../core/widgets/modern_app_bar.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../data/models/drawer_item.dart';
import '../../../data/models/shopping_item.dart';
import '../../../modules/inventory/wardrobe/controllers/wardrobe_controller.dart' as wardrobe;
import '../../../modules/shopping/controllers/shopping_controller.dart' as shopping;

class CheatsheetCategoryDetailView extends StatefulWidget {
  final String categoryId;

  const CheatsheetCategoryDetailView({
    super.key,
    required this.categoryId,
  });

  @override
  State<CheatsheetCategoryDetailView> createState() => _CheatsheetCategoryDetailViewState();
}

class _CheatsheetCategoryDetailViewState extends State<CheatsheetCategoryDetailView> {
  late final CheatsheetController controller;
  late final Future<List<DrawerItem>>? drawerItemsFuture;
  late final Future<List<ShoppingItem>>? shoppingItemsFuture;
  CheatsheetCategory? category;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CheatsheetController>();
    
    // Find category
    try {
      category = controller.cheatsheetCategories.firstWhere(
        (cat) => cat.id == widget.categoryId,
      );
    } catch (e) {
      category = null;
    }
    
    // Initialize futures based on category type
    if (category != null) {
      if (category!.type == CheatsheetType.drawer) {
        drawerItemsFuture = controller.getDrawerItems(widget.categoryId);
      } else if (category!.type == CheatsheetType.shopping) {
        shoppingItemsFuture = controller.getShoppingItems(widget.categoryId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cat = category;
    if (cat == null) {
      return Scaffold(
        appBar: ModernAppBar(
          title: 'Category Not Found',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: Text(
            'Category not found',
            style: DesignTokens.bodyStyle,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: ModernAppBar(
        title: cat.title,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.all(DesignTokens.spacingM),
                child: const LoadingWidget.inline(size: 20, strokeWidth: 2),
              );
            }
            return IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Import to ${cat.type == CheatsheetType.drawer ? "Wardrobe" : "Shopping"}',
              onPressed: () => _importItems(context, cat),
            );
          }),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (cat.type == CheatsheetType.drawer && drawerItemsFuture != null) {
            return FutureBuilder<List<DrawerItem>>(
              future: drawerItemsFuture,
              builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget();
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No items found',
                    style: DesignTokens.bodyStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(DesignTokens.spacingL),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: DesignTokens.spacingM),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(DesignTokens.spacingM),
                      title: Text(
                        item.name,
                        style: DesignTokens.titleStyle,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.notes != null && item.notes!.isNotEmpty) ...[
                            const SizedBox(height: DesignTokens.spacingXS),
                            Text(
                              item.notes!,
                              style: DesignTokens.captionStyle.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                          const SizedBox(height: DesignTokens.spacingXS),
                          Row(
                            children: [
                              Text(
                                'Target: ${item.targetQuantity} ${item.unit.displayName}',
                                style: DesignTokens.captionStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.check_circle_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
              );
            },
          );
          } else if (cat.type == CheatsheetType.shopping && shoppingItemsFuture != null) {
            return FutureBuilder<List<ShoppingItem>>(
              future: shoppingItemsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget();
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No items found',
                    style: DesignTokens.bodyStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(DesignTokens.spacingL),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: DesignTokens.spacingM),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(DesignTokens.spacingM),
                      title: Text(
                        item.name,
                        style: DesignTokens.titleStyle,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: DesignTokens.spacingXS),
                          Row(
                            children: [
                              Text(
                                'Quantity: ${item.quantity} ${item.unit.displayName}',
                                style: DesignTokens.captionStyle,
                              ),
                              const SizedBox(width: DesignTokens.spacingM),
                              Text(
                                'Priority: ${item.priority}',
                                style: DesignTokens.captionStyle,
                              ),
                            ],
                          ),
                          if (item.category.isNotEmpty) ...[
                            const SizedBox(height: DesignTokens.spacingXS),
                            Text(
                              'Category: ${item.category}',
                              style: DesignTokens.captionStyle.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: Icon(
                        Icons.shopping_cart_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
              );
            },
          );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _importItems(BuildContext context, CheatsheetCategory cat) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Import ${cat.title}'),
        content: Text(
          'This will add all ${cat.title.toLowerCase()} items to your ${cat.type == CheatsheetType.drawer ? "drawer" : "shopping list"}. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Import'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      if (cat.type == CheatsheetType.drawer) {
        final items = await controller.getDrawerItems(widget.categoryId);
        if (Get.isRegistered<wardrobe.WardrobeController>()) {
          final wardrobeController = Get.find<wardrobe.WardrobeController>();
          // Import using the controller's method
          await wardrobeController.importCheatsheetItems(widget.categoryId);
        } else {
          // If wardrobe controller not registered, navigate to wardrobe first
          Get.toNamed(Routes.inventoryWardrobe);
          await Future.delayed(const Duration(milliseconds: 500));
          if (Get.isRegistered<wardrobe.WardrobeController>()) {
            final wardrobeController = Get.find<wardrobe.WardrobeController>();
            await wardrobeController.importCheatsheetItems(widget.categoryId);
          }
        }
      } else if (cat.type == CheatsheetType.shopping) {
        final items = await controller.getShoppingItems(widget.categoryId);
        if (Get.isRegistered<shopping.ShoppingController>()) {
          final shoppingController = Get.find<shopping.ShoppingController>();
          for (final item in items) {
            await shoppingController.addShoppingItem(item);
          }
        } else {
          // If shopping controller not registered, navigate to shopping first
          Get.toNamed('/shopping');
          await Future.delayed(const Duration(milliseconds: 500));
          if (Get.isRegistered<shopping.ShoppingController>()) {
            final shoppingController = Get.find<shopping.ShoppingController>();
            for (final item in items) {
              await shoppingController.addShoppingItem(item);
            }
          }
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${cat.title} items imported!'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing items: $e'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

