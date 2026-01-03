import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shopping_controller.dart';
import '../../../core/widgets/modern_app_bar.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../data/models/shopping_item.dart';
import '../../../data/models/item_unit.dart' show ItemUnit, UnitType;

class ShoppingItemDetailView extends GetView<ShoppingController> {
  final ShoppingItem item;

  const ShoppingItemDetailView({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: item.name);
    final categoryController = TextEditingController(text: item.category);
    final quantityController = TextEditingController(text: item.quantity.toString());
    final priorityController = TextEditingController(text: item.priority.toString());
    final unitController = TextEditingController(text: item.unit.displayName);
    final notesController = TextEditingController();

    return Scaffold(
      appBar: ModernAppBar(
        title: 'Item Details',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await ConfirmationDialog.show(
                title: 'Delete Item',
                message: 'Are you sure you want to delete "${item.name}"?',
                confirmLabel: 'Delete',
                isDestructive: true,
              );
              if (confirmed) {
                controller.deleteShoppingItem(item.id);
                Get.back();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingL),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style: DesignTokens.captionStyle.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacingS),
                          Text(
                            item.status.displayName,
                            style: DesignTokens.titleStyle,
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      final currentItem = controller.shoppingItems.firstWhereOrNull(
                        (i) => i.id == item.id,
                      ) ?? item;
                      return Switch(
                        value: currentItem.status == ShoppingStatus.purchased,
                        onChanged: (value) {
                          if (value) {
                            controller.markPurchased(item.id);
                          } else {
                            controller.markPending(item.id);
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Item Name
            Text(
              'Item Name',
              style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter item name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
              ),
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Category
            Text(
              'Category',
              style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                hintText: 'Enter category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
              ),
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Quantity and Unit Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quantity',
                        style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
                      ),
                      const SizedBox(height: DesignTokens.spacingS),
                      TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '1',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unit',
                        style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
                      ),
                      const SizedBox(height: DesignTokens.spacingS),
                      TextField(
                        controller: unitController,
                        decoration: InputDecoration(
                          hintText: 'e.g., kg, pieces',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Priority
            Text(
              'Priority',
              style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Obx(() {
              final currentItem = controller.shoppingItems.firstWhereOrNull(
                (i) => i.id == item.id,
              ) ?? item;
              return Slider(
                value: currentItem.priority.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: 'Priority: ${currentItem.priority}',
                onChanged: (value) {
                  controller.updateShoppingItem(
                    currentItem.copyWith(priority: value.toInt()),
                  );
                },
              );
            }),

            const SizedBox(height: DesignTokens.spacingXL),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final updated = item.copyWith(
                    name: nameController.text,
                    category: categoryController.text,
                    quantity: int.tryParse(quantityController.text) ?? 1,
                    unit: ItemUnit(
                      type: UnitType.custom,
                      customUnit: unitController.text,
                    ),
                  );
                  controller.updateShoppingItem(updated);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: DesignTokens.spacingM,
                  ),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

