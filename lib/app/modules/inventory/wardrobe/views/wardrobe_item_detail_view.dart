import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wardrobe_controller.dart';
import '../../../../core/widgets/modern_app_bar.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../data/models/drawer_item.dart';
import '../../../../data/models/item_unit.dart' show ItemUnit, UnitType;

class WardrobeItemDetailView extends GetView<WardrobeController> {
  final DrawerItem item;

  const WardrobeItemDetailView({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: item.name);
    final categoryController = TextEditingController(text: item.category);
    final locationController = TextEditingController(text: item.location);
    final notesController = TextEditingController(text: item.notes ?? '');
    final currentQuantityController = TextEditingController(
      text: item.currentQuantity.toString(),
    );
    final targetQuantityController = TextEditingController(
      text: item.targetQuantity.toString(),
    );
    final unitController = TextEditingController(text: item.unit.displayName);
    final selectedStyles = item.styles.toList().obs;

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
                controller.deleteDrawerItem(item.id);
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
                          if (item.lastOrganized != null) ...[
                            const SizedBox(height: DesignTokens.spacingS),
                            Text(
                              'Last organized: ${item.lastOrganized!.day}/${item.lastOrganized!.month}/${item.lastOrganized!.year}',
                              style: DesignTokens.captionStyle.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Obx(() {
                      final currentItem = controller.drawerItems.firstWhereOrNull(
                        (i) => i.id == item.id,
                      ) ?? item;
                      return Switch(
                        value: currentItem.status == DrawerStatus.organized,
                        onChanged: (value) {
                          if (value) {
                            controller.markOrganized(item.id);
                          } else {
                            controller.markUnorganized(item.id);
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Name
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

            // Location
            Text(
              'Location',
              style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'e.g., Top drawer, Closet',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
              ),
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Quantity Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity Tracking',
                      style: DesignTokens.titleStyle,
                    ),
                    const SizedBox(height: DesignTokens.spacingL),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current',
                                style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
                              ),
                              const SizedBox(height: DesignTokens.spacingS),
                              TextField(
                                controller: currentQuantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '0',
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
                                'Target',
                                style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
                              ),
                              const SizedBox(height: DesignTokens.spacingS),
                              TextField(
                                controller: targetQuantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '0',
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
                    const SizedBox(height: DesignTokens.spacingM),
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
                        hintText: 'e.g., pieces, pairs',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Style/Occasion Selection
            Text(
              'Style / Occasion',
              style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Wrap(
              spacing: DesignTokens.spacingS,
              runSpacing: DesignTokens.spacingS,
              children: WardrobeController.availableStyles.map((style) {
                return Obx(() {
                  final isSelected = selectedStyles.contains(style);
                  return FilterChip(
                    label: Text(style),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        selectedStyles.add(style);
                      } else {
                        selectedStyles.remove(style);
                      }
                    },
                    selectedColor: Theme.of(context).colorScheme.secondaryContainer,
                    checkmarkColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  );
                });
              }).toList(),
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Notes
            Text(
              'Notes',
              style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            TextField(
              controller: notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add any additional notes...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
              ),
            ),

            const SizedBox(height: DesignTokens.spacingXL),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final updated = item.copyWith(
                    name: nameController.text,
                    category: categoryController.text,
                    location: locationController.text,
                    notes: notesController.text.isEmpty ? null : notesController.text,
                    currentQuantity: int.tryParse(currentQuantityController.text) ?? 0,
                    targetQuantity: int.tryParse(targetQuantityController.text) ?? 0,
                    unit: ItemUnit(
                      type: UnitType.custom,
                      customUnit: unitController.text,
                    ),
                    styles: selectedStyles.toList(),
                  );
                  controller.updateDrawerItem(updated);
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

