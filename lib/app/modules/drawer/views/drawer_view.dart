import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/drawer_controller.dart' as drawer;
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/drawer_card.dart';
import '../../../core/widgets/unit_picker.dart';
import '../../../core/widgets/quantity_counter.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../data/models/drawer_item.dart';
import '../../../data/models/item_unit.dart';
import '../../../modules/main_navigation/main_navigation_controller.dart';
import '../../../routes/app_routes.dart';

class DrawerView extends GetView<drawer.DrawerController> {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    // Update navigation index if MainNavigationController exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MainNavigationController>()) {
        Get.find<MainNavigationController>().updateCurrentIndex(Routes.drawer);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawer Organization'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'import_starter') {
                await controller.importStarterWardrobe();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Starter wardrobe items imported!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import_starter',
                child: Row(
                  children: [
                    Icon(Icons.checklist, size: 20),
                    SizedBox(width: 8),
                    Text('Import Starter Wardrobe'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDrawerItemDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final status = controller.drawerStatus;
        final percentage = (status['percentage'] ?? 0.0) as double;
        final organized = status['organized'] ?? 0;
        final total = status['total'] ?? 0;

        return Column(
          children: [
            // Status Card
            Container(
              margin: const EdgeInsets.all(DesignTokens.spacingL),
              padding: const EdgeInsets.all(DesignTokens.spacingXL),
              decoration: BoxDecoration(
                gradient: DesignTokens.drawerGradient,
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                boxShadow: DesignTokens.mediumShadow,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(DesignTokens.spacingM),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                ),
                                child: const Icon(
                                  Icons.inventory_2,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: DesignTokens.spacingM),
                              Text(
                                'Drawer Status',
                                style: DesignTokens.captionStyle.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: DesignTokens.spacingL),
                          Text(
                            '${(percentage * 100).toStringAsFixed(0)}%',
                            style: DesignTokens.headlineStyle.copyWith(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Organized',
                            style: DesignTokens.titleStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                value: percentage,
                                strokeWidth: 8,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            Center(
                              child: Icon(
                                percentage >= 0.5 ? Icons.check_circle : Icons.schedule,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingL),
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingM),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.checklist,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(
                          '$organized of $total items organized',
                          style: DesignTokens.bodyStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 400.ms),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                  boxShadow: DesignTokens.softShadow,
                ),
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: InputDecoration(
                    hintText: 'Search drawer items...',
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

            const SizedBox(height: DesignTokens.spacingL),

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
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: DesignTokens.spacingL),
                            Text(
                              'No drawer items yet',
                              style: DesignTokens.titleStyle.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spacingM),
                            // Starter Wardrobe Card
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: DesignTokens.spacingL),
                              padding: const EdgeInsets.all(DesignTokens.spacingL),
                              decoration: BoxDecoration(
                                gradient: DesignTokens.drawerGradient,
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
                                    'Import starter wardrobe checklist from the cheatsheet',
                                    style: DesignTokens.bodyStyle.copyWith(
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: DesignTokens.spacingL),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await controller.importStarterWardrobe();
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Starter wardrobe items imported!'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.download),
                                    label: const Text('Import Starter Wardrobe'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF6B6BFF),
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
                          child: DrawerCard(
                            title: item.name,
                            status: item.location.isNotEmpty
                                ? '${item.category} • ${item.location}'
                                : item.category,
                            isOrganized: item.status.name == 'organized',
                            currentQuantity: item.currentQuantity,
                            targetQuantity: item.targetQuantity > 0 ? item.targetQuantity : null,
                            unit: item.unit,
                            onQuantityChanged: (newQuantity) {
                              controller.updateDrawerItem(
                                item.copyWith(currentQuantity: newQuantity),
                              );
                            },
                            onTap: () => _showEditDrawerItemDialog(context, item),
                            index: index,
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

  void _showAddDrawerItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final locationController = TextEditingController();
    var currentQuantity = 0.obs;
    var targetQuantity = 0.obs;
    var selectedUnit = const ItemUnit().obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingXL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            gradient: DesignTokens.drawerGradient,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingM),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    ),
                    child: const Icon(
                      Icons.add_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  Expanded(
        child: Text(
                      'Add Drawer Item',
                      style: DesignTokens.titleStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingXL),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintText: 'e.g., T-shirts',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.spacingL),
              TextField(
                controller: categoryController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintText: 'e.g., Tops',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.spacingL),
              TextField(
                controller: locationController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintText: 'e.g., Top drawer, left',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXL),
              // Quantity and Unit Section
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingL),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity & Unit',
                      style: DesignTokens.bodyStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingM),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current',
                                style: DesignTokens.captionStyle.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: DesignTokens.spacingS),
                              Obx(() => QuantityCounter(
                                value: currentQuantity.value,
                                target: targetQuantity.value > 0 ? targetQuantity.value : null,
                                unit: selectedUnit.value.displayName,
                                onChanged: (value) => currentQuantity.value = value,
                                min: 0,
                                max: 999,
                              )),
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
                                style: DesignTokens.captionStyle.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: DesignTokens.spacingS),
                              Obx(() => QuantityCounter(
                                value: targetQuantity.value,
                                unit: '',
                                onChanged: (value) => targetQuantity.value = value,
                                min: 0,
                                max: 999,
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacingL),
                    Obx(() => UnitPicker(
                      selectedUnit: selectedUnit.value,
                      onUnitChanged: (unit) => selectedUnit.value = unit,
                      availableUnits: UnitType.clothingUnits,
                      allowCustom: true,
                    )),
                  ],
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        final item = DrawerItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameController.text,
                          category: categoryController.text,
                          location: locationController.text,
                          currentQuantity: currentQuantity.value,
                          targetQuantity: targetQuantity.value,
                          unit: selectedUnit.value,
                        );
                        controller.addDrawerItem(item);
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6B6BFF),
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingXL,
                        vertical: DesignTokens.spacingM,
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDrawerItemDialog(BuildContext context, DrawerItem item) {
    final nameController = TextEditingController(text: item.name);
    final categoryController = TextEditingController(text: item.category);
    final locationController = TextEditingController(text: item.location);
    var currentQuantity = item.currentQuantity.obs;
    var targetQuantity = item.targetQuantity.obs;
    var selectedUnit = item.unit.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingXL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            gradient: DesignTokens.drawerGradient,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(DesignTokens.spacingM),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingM),
                    Expanded(
                      child: Text(
                        'Edit Drawer Item',
                        style: DesignTokens.titleStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingXL),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingL),
                TextField(
                  controller: categoryController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingL),
                TextField(
                  controller: locationController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Location',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXL),
                // Quantity and Unit Section
                Container(
                  padding: const EdgeInsets.all(DesignTokens.spacingL),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quantity & Unit',
                        style: DesignTokens.bodyStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingM),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current',
                                  style: DesignTokens.captionStyle.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: DesignTokens.spacingS),
                                Obx(() => QuantityCounter(
                                  value: currentQuantity.value,
                                  target: targetQuantity.value > 0 ? targetQuantity.value : null,
                                  unit: selectedUnit.value.displayName,
                                  onChanged: (value) => currentQuantity.value = value,
                                  min: 0,
                                  max: 999,
                                )),
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
                                  style: DesignTokens.captionStyle.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: DesignTokens.spacingS),
                                Obx(() => QuantityCounter(
                                  value: targetQuantity.value,
                                  unit: '',
                                  onChanged: (value) => targetQuantity.value = value,
                                  min: 0,
                                  max: 999,
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.spacingL),
                      Obx(() => UnitPicker(
                        selectedUnit: selectedUnit.value,
                        onUnitChanged: (unit) => selectedUnit.value = unit,
                        availableUnits: UnitType.clothingUnits,
                        allowCustom: true,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: DesignTokens.spacingM),
                    ElevatedButton(
                      onPressed: () {
                        final updated = item.copyWith(
                          name: nameController.text,
                          category: categoryController.text,
                          location: locationController.text,
                          currentQuantity: currentQuantity.value,
                          targetQuantity: targetQuantity.value,
                          unit: selectedUnit.value,
                        );
                        controller.updateDrawerItem(updated);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6B6BFF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingXL,
                          vertical: DesignTokens.spacingM,
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                    if (item.status.name != 'organized') ...[
                      const SizedBox(width: DesignTokens.spacingM),
                      ElevatedButton(
                        onPressed: () {
                          controller.markOrganized(item.id);
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Mark Organized'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
