import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/planning_controller.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/plan_card.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../data/models/plan_item.dart';
import '../../../modules/main_navigation/main_navigation_controller.dart';
import '../../../routes/app_routes.dart';

class PlanningView extends GetView<PlanningController> {
  const PlanningView({super.key});

  @override
  Widget build(BuildContext context) {
    // Update navigation index if MainNavigationController exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MainNavigationController>()) {
        Get.find<MainNavigationController>().updateCurrentIndex(Routes.planning);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'import_daily') {
                await controller.importDailyChecklist();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Daily checklist imported!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import_daily',
                child: Row(
                  children: [
                    Icon(Icons.checklist, size: 20),
                    SizedBox(width: 8),
                    Text('Import Daily Checklist'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPlanItemDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final selectedDate = controller.selectedDate.value;
        final plansForDate = controller.getPlansForDate(selectedDate);

        return Column(
          children: [
            // Date Picker
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      controller.selectedDate.value =
                          selectedDate.subtract(const Duration(days: 1));
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        controller.selectedDate.value = picked;
                      }
                    },
                    child: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: DesignTokens.titleStyle,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      controller.selectedDate.value =
                          selectedDate.add(const Duration(days: 1));
                    },
                  ),
                ],
              ),
            ),

            // Plans List
            Expanded(
              child: plansForDate.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(DesignTokens.spacingXL),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: DesignTokens.spacingL),
                            Text(
                              'No plans for this date',
                              style: DesignTokens.titleStyle.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacingM),
                            // Daily Checklist Card
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: DesignTokens.spacingL),
                              padding: const EdgeInsets.all(DesignTokens.spacingL),
                              decoration: BoxDecoration(
                                gradient: DesignTokens.planningGradient,
                                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                                boxShadow: DesignTokens.softShadow,
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.checklist,
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
                                    'Import daily checklist (morning & night routines) from the cheatsheet',
                                    style: DesignTokens.bodyStyle.copyWith(
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: DesignTokens.spacingL),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await controller.importDailyChecklist();
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Daily checklist imported!'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.download),
                                    label: const Text('Import Daily Checklist'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFFFFB36B),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: DesignTokens.spacingL,
                                        vertical: DesignTokens.spacingM,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacingM),
                            Text(
                              'Or tap + to add plans manually',
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
                      itemCount: plansForDate.length,
                      itemBuilder: (context, index) {
                        final item = plansForDate[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
                          child: PlanCard(
                            title: item.title,
                            time: item.time,
                            category: item.category,
                            isCompleted: item.status.name == 'completed',
                            index: index,
                            onTap: () {
                              if (item.status.name == 'pending') {
                                controller.markCompleted(item.id);
                              } else {
                                _showEditPlanItemDialog(context, item);
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

  void _showAddPlanItemDialog(BuildContext context) {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    final categoryController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Plan Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Gym workout',
              ),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Time (optional)',
                hintText: 'e.g., 10:00 AM',
              ),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category (optional)',
                hintText: 'e.g., Fitness',
              ),
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
              if (titleController.text.isNotEmpty) {
                final selectedDate = controller.selectedDate.value;
                final item = PlanItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  date: selectedDate,
                  time: timeController.text.isEmpty ? null : timeController.text,
                  category: categoryController.text,
                );
                controller.addPlanItem(item);
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditPlanItemDialog(BuildContext context, PlanItem item) {
    final titleController = TextEditingController(text: item.title);
    final timeController = TextEditingController(text: item.time ?? '');
    final categoryController = TextEditingController(text: item.category);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Plan Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
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
                title: titleController.text,
                time: timeController.text.isEmpty ? null : timeController.text,
                category: categoryController.text,
              );
              controller.updatePlanItem(updated);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
