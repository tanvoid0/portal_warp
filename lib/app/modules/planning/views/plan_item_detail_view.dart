import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/planning_controller.dart';
import '../../../core/widgets/modern_app_bar.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../data/models/plan_item.dart';
import '../../../data/models/item_unit.dart' show ItemUnit, UnitType;

class PlanItemDetailView extends GetView<PlanningController> {
  final PlanItem item;

  const PlanItemDetailView({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: item.title);
    final timeController = TextEditingController(text: item.time ?? '');
    final notesController = TextEditingController(text: item.notes ?? '');
    final quantityController = TextEditingController(
      text: item.quantity > 0 ? item.quantity.toString() : '',
    );
    final unitController = TextEditingController(text: item.unit.displayName);
    String? selectedCategory = item.category.isEmpty ? null : item.category;

    return Scaffold(
      appBar: ModernAppBar(
        title: 'Plan Details',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await ConfirmationDialog.show(
                title: 'Delete Plan',
                message: 'Are you sure you want to delete "${item.title}"?',
                confirmLabel: 'Delete',
                isDestructive: true,
              );
              if (confirmed) {
                controller.deletePlanItem(item.id);
                Get.back();
              }
            },
          ),
        ],
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
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
                      final currentItem = controller.planItems.firstWhereOrNull(
                        (i) => i.id == item.id,
                      ) ?? item;
                      return Switch(
                        value: currentItem.status == PlanStatus.completed,
                        onChanged: (value) {
                          if (value) {
                            controller.markCompleted(item.id);
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

            // Date Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: DesignTokens.captionStyle.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingS),
                    Text(
                      '${item.date.day}/${item.date.month}/${item.date.year}',
                      style: DesignTokens.titleStyle,
                    ),
                    const SizedBox(height: DesignTokens.spacingM),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: item.date,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          controller.updatePlanItem(
                            item.copyWith(date: picked),
                          );
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Change Date'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Title
            Text(
              'Title',
              style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter plan title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
              ),
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Time
            Text(
              'Time',
              style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                hintText: 'e.g., 10:00 AM',
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
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                hintText: 'Select a category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('None'),
                ),
                ...PlanningController.planCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
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
                          hintText: 'e.g., 10',
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
                          hintText: 'e.g., minutes, sets',
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
                    title: titleController.text,
                    time: timeController.text.isEmpty ? null : timeController.text,
                    category: selectedCategory ?? '',
                    notes: notesController.text.isEmpty ? null : notesController.text,
                    quantity: int.tryParse(quantityController.text) ?? 0,
                    unit: ItemUnit(
                      type: UnitType.custom,
                      customUnit: unitController.text,
                    ),
                  );
                  controller.updatePlanItem(updated);
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
          );
        },
      ),
    );
  }
}

