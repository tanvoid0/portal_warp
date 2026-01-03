import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/planning_controller.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/plan_card.dart';
import '../../../core/widgets/modern_app_bar.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/unsplash_service.dart';
import '../../../data/models/plan_item.dart';
import '../../../modules/main_navigation/main_navigation_controller.dart';
import '../../../routes/app_routes.dart';
import 'plan_item_detail_view.dart';

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
      appBar: ModernAppBar(
        title: 'Planning',
        leading: null,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'import_daily') {
                await controller.importDailyChecklist();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Daily checklist imported!'),
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
          return const LoadingWidget();
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                              child: CachedNetworkImage(
                                imageUrl: UnsplashService.getEmptyStateImageUrlForScreen('planning'),
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
                                  Icons.calendar_today_outlined,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacingL),
                            Text(
                              'No plans for this date',
                              style: DesignTokens.titleStyle.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacingM),
                            // Daily Checklist Card
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: DesignTokens.spacingL),
                              padding: const EdgeInsets.all(DesignTokens.spacingL),
                              decoration: BoxDecoration(
                          gradient: DesignTokens.planningGradient(context),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                          boxShadow: DesignTokens.softShadow(context),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.checklist,
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
                                    'Import daily checklist (morning & night routines) from the cheatsheet',
                                    style: DesignTokens.bodyStyle.copyWith(
                                      color: Theme.of(context).colorScheme.app.textOnGradientSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: DesignTokens.spacingL),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await controller.importDailyChecklist();
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Daily checklist imported!'),
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
                                    icon: const Icon(Icons.download),
                                    label: const Text('Import Daily Checklist'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.app.textOnGradient,
                                      foregroundColor: Theme.of(context).colorScheme.app.planningPrimary,
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
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _buildGroupedPlansList(context, selectedDate),
            ),
          ],
        );
      }),
    );
  }

  void _showAddPlanItemDialog(BuildContext context) {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    String? selectedCategory;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Plan Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'e.g., Brush teeth',
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingM),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Time (optional)',
                    hintText: 'e.g., 9:00 AM or Morning',
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingM),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category (optional)',
                    hintText: 'Select a category',
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
                      category: selectedCategory ?? '',
                    );
                    controller.addPlanItem(item);
                    Get.back();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditPlanItemDialog(BuildContext context, PlanItem item) {
    final titleController = TextEditingController(text: item.title);
    final timeController = TextEditingController(text: item.time ?? '');
    String? selectedCategory = item.category.isEmpty ? null : item.category;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
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
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    hintText: 'e.g., 9:00 AM or Morning',
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingM),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'Select a category',
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
                    category: selectedCategory ?? '',
                  );
                  controller.updatePlanItem(updated);
                  Get.back();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGroupedPlansList(BuildContext context, DateTime selectedDate) {
    final groupedPlans = controller.getPlansGroupedByTime(selectedDate);
    final sessionOrder = controller.getSessionOrder();
    
    // Get all session keys, prioritizing ordered sessions, then others
    final orderedSessions = <String>[];
    final otherSessions = <String>[];
    
    for (final session in sessionOrder) {
      if (groupedPlans.containsKey(session)) {
        orderedSessions.add(session);
      }
    }
    
    for (final session in groupedPlans.keys) {
      if (!sessionOrder.contains(session)) {
        otherSessions.add(session);
      }
    }
    
    final allSessions = [...orderedSessions, ...otherSessions];
    
    if (allSessions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: DesignTokens.spacingM,
      ),
      itemCount: allSessions.length,
      itemBuilder: (context, sessionIndex) {
        final session = allSessions[sessionIndex];
        final items = groupedPlans[session]!;
        
        return Padding(
          padding: EdgeInsets.only(
            top: sessionIndex > 0 ? DesignTokens.spacingL : 0,
            bottom: DesignTokens.spacingM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Session Header
              Padding(
                padding: const EdgeInsets.only(
                  bottom: DesignTokens.spacingM,
                  left: DesignTokens.spacingS,
                ),
                child: Row(
                  children: [
                    Icon(
                      _getSessionIcon(session),
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: DesignTokens.spacingS),
                    Text(
                      session,
                      style: DesignTokens.titleStyle.copyWith(
                        fontSize: 18,
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
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      ),
                      child: Text(
                        '${items.length}',
                        style: DesignTokens.captionStyle.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Grouped Cards Container
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(DesignTokens.spacingM),
                child: Column(
                  children: items.asMap().entries.map((entry) {
                    final itemIndex = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: itemIndex < items.length - 1 ? DesignTokens.spacingM : 0,
                      ),
                      child: PlanCard(
                        title: item.title,
                        time: item.time,
                        category: item.category,
                        isCompleted: item.status.name == 'completed',
                        index: sessionIndex * 100 + itemIndex, // Unique index for animations
                        onTap: () {
                          Get.to(() => PlanItemDetailView(item: item));
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getSessionIcon(String session) {
    switch (session.toLowerCase()) {
      case 'morning':
        return Icons.wb_sunny;
      case 'afternoon':
        return Icons.wb_twilight;
      case 'evening':
        return Icons.nightlight;
      case 'night':
      case 'late night':
        return Icons.bedtime;
      case 'unscheduled':
        return Icons.schedule;
      default:
        return Icons.access_time;
    }
  }
}
