import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/wardrobe_controller.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/drawer_card.dart';
import '../../../../core/widgets/unit_picker.dart';
import '../../../../core/widgets/quantity_counter.dart';
import '../../../../core/widgets/modern_search_bar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/modern_app_bar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/unsplash_service.dart';
import '../../../../data/models/drawer_item.dart';
import '../../../../data/models/item_unit.dart';
import '../../../../modules/main_navigation/main_navigation_controller.dart';
import '../../../../routes/app_routes.dart';
import 'wardrobe_item_detail_view.dart';

class WardrobeView extends GetView<WardrobeController> {
  const WardrobeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Update navigation index if MainNavigationController exists
    // Note: Wardrobe is now accessed via Items tab, so map to items route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MainNavigationController>()) {
        Get.find<MainNavigationController>().updateCurrentIndex(Routes.items);
      }
    });

    // Check if we're inside ItemsView (no back button needed)
    final isInItemsView = Get.currentRoute == Routes.items;
    
    return Scaffold(
      appBar: isInItemsView ? null : ModernAppBar(
        title: 'Wardrobe',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              String message;
              if (value == 'import_wardrobe') {
                await controller.importCheatsheetItems('wardrobe');
                message = 'Starter wardrobe items imported!';
              } else if (value == 'import_gym') {
                await controller.importCheatsheetItems('gym');
                message = 'Gym essentials imported!';
              } else if (value == 'import_grooming') {
                await controller.importCheatsheetItems('grooming');
                message = 'Grooming essentials imported!';
              } else if (value == 'import_sleepwear') {
                await controller.importCheatsheetItems('sleepwear');
                message = 'Sleepwear imported!';
              } else {
                return;
              }
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
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
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import_wardrobe',
                child: Row(
                  children: [
                    Icon(Icons.checkroom, size: 20),
                    SizedBox(width: 8),
                    Text('Import Starter Wardrobe'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'import_gym',
                child: Row(
                  children: [
                    Icon(Icons.fitness_center, size: 20),
                    SizedBox(width: 8),
                    Text('Import Gym Essentials'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'import_grooming',
                child: Row(
                  children: [
                    Icon(Icons.content_cut, size: 20),
                    SizedBox(width: 8),
                    Text('Import Grooming Essentials'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'import_sleepwear',
                child: Row(
                  children: [
                    Icon(Icons.bed, size: 20),
                    SizedBox(width: 8),
                    Text('Import Sleepwear'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'wardrobe_fab',
        onPressed: () => _showAddDrawerItemDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        final status = controller.drawerStatus;
        final percentage = (status['percentage'] ?? 0.0) as double;
        final organized = status['organized'] ?? 0;
        final total = status['total'] ?? 0;

        return CustomScrollView(
          slivers: [
            // Status Card - Collapsing Header
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              expandedHeight: 140,
              collapsedHeight: 0,
              toolbarHeight: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  margin: const EdgeInsets.all(DesignTokens.spacingM),
                  padding: const EdgeInsets.all(DesignTokens.spacingM),
                  decoration: BoxDecoration(
                    gradient: DesignTokens.drawerGradient(context),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                    boxShadow: DesignTokens.mediumShadow(context),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${(percentage * 100).toStringAsFixed(0)}% Organized',
                                  style: DesignTokens.titleStyle.copyWith(
                                    color: Theme.of(context).colorScheme.app.textOnGradient,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: DesignTokens.spacingXS),
                                Text(
                                  '$organized of $total items',
                                  style: DesignTokens.captionStyle.copyWith(
                                    color: Theme.of(context).colorScheme.app.textOnGradientSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.app.surfaceOverlay,
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    value: percentage,
                                    strokeWidth: 4,
                                    backgroundColor: Theme.of(context).colorScheme.app.surfaceOverlay,
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.app.textOnGradient),
                                  ),
                                ),
                                Center(
                                  child: Icon(
                                    percentage >= 0.5 ? Icons.check_circle : Icons.schedule,
                                    color: Theme.of(context).colorScheme.app.textOnGradient,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Search Bar and Filters - Collapsing Header
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              expandedHeight: 350,
              collapsedHeight: 0,
              toolbarHeight: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingL,
                    vertical: DesignTokens.spacingS,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      ModernSearchBar(
                        hintText: 'Search wardrobe items...',
                        onChanged: (value) => controller.searchQuery.value = value,
                      ),
                      const SizedBox(height: DesignTokens.spacingM),
                      // Status and Sort Row
                      Obx(() => Row(
                        children: [
                          // Status Filter
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.statusOptions.length,
                                itemBuilder: (context, index) {
                                  final status = controller.statusOptions[index];
                                  final isSelected = controller.selectedStatus.value == status;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: DesignTokens.spacingS),
                                    child: FilterChip(
                                      label: Text(status),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        controller.selectedStatus.value = status;
                                      },
                                      selectedColor: Theme.of(context).colorScheme.primaryContainer,
                                      checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
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
                            tooltip: 'Sort ${controller.sortAscending.value ? "Descending" : "Ascending"}',
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
                      const SizedBox(height: DesignTokens.spacingS),
                      // Style Filter Chips
                      Obx(() {
                        final availableStyles = WardrobeController.availableStyles;
                        // Access the observable directly - GetX will track changes
                        final _ = controller.selectedStyles.length; // Ensure GetX tracks this observable
                        if (availableStyles.isEmpty) return const SizedBox.shrink();
                        
                        return SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: availableStyles.length,
                            itemBuilder: (context, index) {
                              final style = availableStyles[index];
                              final isSelected = controller.selectedStyles.contains(style);
                              return Padding(
                                padding: const EdgeInsets.only(right: DesignTokens.spacingS),
                                child: FilterChip(
                                  label: Text(style),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    controller.toggleStyle(style);
                                  },
                                  selectedColor: Theme.of(context).colorScheme.secondaryContainer,
                                  checkmarkColor: Theme.of(context).colorScheme.onSecondaryContainer,
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: DesignTokens.spacingS),
                      // Category Filter Chips
                      Obx(() {
                        final categories = controller.categories;
                        final categoryCounts = controller.categoryCounts;
                        if (categories.length <= 1) return const SizedBox.shrink();
                        
                        return SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final isSelected = controller.selectedCategory.value == category;
                              final count = category == 'All' 
                                  ? controller.drawerItems.length 
                                  : categoryCounts[category] ?? 0;
                              return Padding(
                                padding: const EdgeInsets.only(right: DesignTokens.spacingS),
                                child: FilterChip(
                                  label: Text('$category ($count)'),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    controller.selectedCategory.value = category;
                                  },
                                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                                  checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Items List
            Obx(() {
              if (controller.filteredItems.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyStateWidget(
                    icon: Icons.checkroom,
                    title: 'No wardrobe items yet',
                    message: controller.searchQuery.value.isNotEmpty
                        ? 'No items match your search'
                        : 'Get started by organizing your wardrobe',
                    actionLabel: controller.searchQuery.value.isEmpty
                        ? 'Import Cheatsheet'
                        : null,
                    onAction: controller.searchQuery.value.isEmpty
                        ? () => _showImportMenu(context)
                        : null,
                  customIllustration: ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    child: CachedNetworkImage(
                      imageUrl: UnsplashService.getEmptyStateImageUrlForScreen('drawer'),
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
                        Icons.checkroom_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Obx(() {
                if (controller.groupByCategory.value) {
                  // Grouped view
                  final grouped = controller.groupedItems;
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingL,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final categories = grouped.keys.toList();
                          final category = categories[index];
                          final items = grouped[category]!;
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category Header with background
                              Container(
                                margin: EdgeInsets.only(
                                  top: index == 0 ? 0 : DesignTokens.spacingL,
                                  bottom: DesignTokens.spacingM,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: DesignTokens.spacingM,
                                  vertical: DesignTokens.spacingS,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      category,
                                      style: DesignTokens.titleStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: DesignTokens.spacingS),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: DesignTokens.spacingS,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(DesignTokens.spacingS),
                                      ),
                                      child: Text(
                                        '${items.length}',
                                        style: DesignTokens.captionStyle.copyWith(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Items in category
                              ...items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
                                child: DrawerCard(
                                  title: item.name,
                                  status: item.location.isNotEmpty
                                      ? '${item.category} • ${item.location}'
                                      : item.category,
                                  isOrganized: item.status.name == 'organized',
                                  currentQuantity: item.currentQuantity,
                                  targetQuantity: item.targetQuantity > 0 ? item.targetQuantity : null,
                                  unit: item.unit,
                                  styles: item.styles,
                                  onQuantityChanged: (newQuantity) {
                                    controller.updateDrawerItem(
                                      item.copyWith(currentQuantity: newQuantity),
                                    );
                                  },
                                  onTap: () => Get.to(() => WardrobeItemDetailView(item: item)),
                                  index: items.indexOf(item),
                                ),
                              )),
                            ],
                          );
                        },
                        childCount: grouped.length,
                      ),
                    ),
                  );
                } else {
                  // Flat list view
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingL,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = controller.filteredItems[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
                            child: DrawerCard(
                              title: item.name,
                              status: item.location.isNotEmpty
                                  ? '${item.category} • ${item.location}'
                                  : item.category,
                              isOrganized: item.status.name == 'organized',
                              currentQuantity: item.currentQuantity,
                              targetQuantity: item.targetQuantity > 0 ? item.targetQuantity : null,
                              unit: item.unit,
                              styles: item.styles,
                              onQuantityChanged: (newQuantity) {
                                controller.updateDrawerItem(
                                  item.copyWith(currentQuantity: newQuantity),
                                );
                              },
                              onTap: () => Get.to(() => WardrobeItemDetailView(item: item)),
                              index: index,
                            ),
                          );
                        },
                        childCount: controller.filteredItems.length,
                      ),
                    ),
                  );
                }
              });
            }
          }),
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
    var selectedStyles = <String>[].obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingXL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            gradient: DesignTokens.drawerGradient(context),
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
                      color: Theme.of(context).colorScheme.app.surfaceOverlay,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    ),
                    child: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).colorScheme.app.textOnGradient,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  Expanded(
                    child: Text(
                      'Add Wardrobe Item',
                      style: DesignTokens.titleStyle.copyWith(
                        color: Theme.of(context).colorScheme.app.textOnGradient,
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
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.app.textOnGradient.withOpacity(0.5)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.app.surfaceOverlay,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.app.textOnGradient.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.app.textOnGradient.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.app.textOnGradient, width: 2),
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
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.app.textOnGradient.withOpacity(0.5)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.app.surfaceOverlay,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.app.textOnGradient.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.app.textOnGradient.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.app.textOnGradient, width: 2),
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
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.app.textOnGradient.withOpacity(0.5)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.app.surfaceOverlay,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.app.textOnGradient.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.app.textOnGradient.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.app.textOnGradient, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXL),
              // Style/Occasion Selection
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingL),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.app.surfaceOverlayLight,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Style / Occasion',
                      style: DesignTokens.bodyStyle.copyWith(
                        color: Theme.of(context).colorScheme.app.textOnGradient,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingM),
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
                            backgroundColor: Theme.of(context).colorScheme.app.surfaceOverlay,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onSecondaryContainer
                                  : Theme.of(context).colorScheme.app.textOnGradient,
                            ),
                          );
                        });
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXL),
              // Quantity and Unit Section
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingL),
                decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.app.surfaceOverlayLight,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity & Unit',
                      style: DesignTokens.bodyStyle.copyWith(
                        color: Theme.of(context).colorScheme.app.textOnGradient,
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
                                  color: Theme.of(context).colorScheme.app.textOnGradientSecondary,
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
                                  color: Theme.of(context).colorScheme.app.textOnGradientSecondary,
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
                          styles: selectedStyles.toList(),
                        );
                        controller.addDrawerItem(item);
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
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
    ),
    );
  }

  void _showImportMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignTokens.radiusL),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(DesignTokens.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Import Cheatsheet Items',
              style: DesignTokens.titleStyle,
            ),
            const SizedBox(height: DesignTokens.spacingL),
            ListTile(
              leading: const Icon(Icons.checkroom),
              title: const Text('Starter Wardrobe'),
              subtitle: const Text('Import style essentials (replaces existing)'),
              onTap: () async {
                Navigator.pop(context);
                await controller.importCheatsheetItems('wardrobe');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Starter wardrobe items imported!'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Gym Essentials'),
              subtitle: const Text('Import gym items (adds to existing)'),
              onTap: () async {
                Navigator.pop(context);
                await controller.importCheatsheetItems('gym');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Gym essentials imported!'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.content_cut),
              title: const Text('Grooming Essentials'),
              subtitle: const Text('Import grooming items (adds to existing)'),
              onTap: () async {
                Navigator.pop(context);
                await controller.importCheatsheetItems('grooming');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Grooming essentials imported!'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.bed),
              title: const Text('Sleepwear'),
              subtitle: const Text('Import sleepwear items (adds to existing)'),
              onTap: () async {
                Navigator.pop(context);
                await controller.importCheatsheetItems('sleepwear');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Sleepwear imported!'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: DesignTokens.spacingM),
          ],
        ),
      ),
    );
  }
}

