import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/drawer_item.dart';
import '../../../../data/repositories/drawer_repository.dart';
import '../../../../core/services/drawer_service.dart';
import '../../../../core/services/cheatsheet_service.dart';
import '../../../../data/local/data_clearer.dart';

class WardrobeController extends GetxController {
  final DrawerRepository _drawerRepo = DrawerRepository();
  final DrawerService _drawerService = DrawerService(DrawerRepository());

  final drawerItems = <DrawerItem>[].obs;
  final drawerStatus = <String, dynamic>{}.obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;
  final selectedStatus = 'All'.obs; // All, Organized, Unorganized
  final selectedStyles = <String>[].obs; // Selected style filters (can be multiple)
  final sortBy = 'name'.obs; // name, category, status, quantity
  final sortAscending = true.obs;
  final groupByCategory = true.obs; // Default to grouped view

  /// Predefined style/occasion options
  static const List<String> availableStyles = [
    'Casual',
    'Formal',
    'Home',
    'Work',
    'Sport',
    'Party',
    'Outdoor',
    'Travel',
    'Beach',
    'Winter',
    'Summer',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadDrawerData();
  }

  Future<void> _loadDrawerData() async {
    isLoading.value = true;
    try {
      drawerItems.value = await _drawerRepo.getDrawerItems();
      drawerStatus.value = await _drawerService.getDrawerStatus();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load drawer data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDrawerItem(DrawerItem item) async {
    try {
      await _drawerRepo.addDrawerItem(item);
      await _loadDrawerData();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateDrawerItem(DrawerItem item) async {
    try {
      await _drawerRepo.updateDrawerItem(item);
      await _loadDrawerData();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update item: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> markOrganized(String id) async {
    try {
      await _drawerService.markOrganized(id);
      await _loadDrawerData();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark as organized: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> markUnorganized(String id) async {
    try {
      final items = await _drawerRepo.getDrawerItems();
      final item = items.firstWhere((i) => i.id == id);
      await _drawerRepo.updateDrawerItem(
        item.copyWith(
          status: DrawerStatus.unorganized,
        ),
      );
      await _loadDrawerData();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark as unorganized: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteDrawerItem(String id) async {
    try {
      await _drawerRepo.deleteDrawerItem(id);
      await _loadDrawerData();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete item: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  List<DrawerItem> get filteredItems {
    var items = drawerItems.toList();
    
    // Filter by category
    if (selectedCategory.value != 'All') {
      items = items.where((item) {
        // Handle category matching - check if category contains the selected category
        return item.category.toLowerCase().contains(selectedCategory.value.toLowerCase()) ||
               selectedCategory.value.toLowerCase().contains(item.category.toLowerCase());
      }).toList();
    }
    
    // Filter by status
    if (selectedStatus.value != 'All') {
      items = items.where((item) {
        if (selectedStatus.value == 'Organized') {
          return item.status == DrawerStatus.organized;
        } else if (selectedStatus.value == 'Unorganized') {
          return item.status == DrawerStatus.unorganized;
        }
        return true;
      }).toList();
    }
    
    // Filter by styles (if any styles are selected)
    if (selectedStyles.isNotEmpty) {
      items = items.where((item) {
        // Item must have at least one of the selected styles
        return selectedStyles.any((selectedStyle) => 
          item.styles.any((itemStyle) => 
            itemStyle.toLowerCase() == selectedStyle.toLowerCase()
          )
        );
      }).toList();
    }
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      items = items.where((item) {
        return item.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            item.category.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            item.location.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
    
    // Sort items
    items.sort((a, b) {
      int comparison = 0;
      switch (sortBy.value) {
        case 'name':
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case 'category':
          comparison = a.category.toLowerCase().compareTo(b.category.toLowerCase());
          if (comparison == 0) {
            comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          }
          break;
        case 'status':
          comparison = a.status.name.compareTo(b.status.name);
          if (comparison == 0) {
            comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          }
          break;
        case 'quantity':
          comparison = a.currentQuantity.compareTo(b.currentQuantity);
          if (comparison == 0) {
            comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          }
          break;
      }
      return sortAscending.value ? comparison : -comparison;
    });
    
    return items;
  }

  /// Get items grouped by category
  Map<String, List<DrawerItem>> get groupedItems {
    final items = filteredItems;
    final grouped = <String, List<DrawerItem>>{};
    
    for (final item in items) {
      final category = item.category.isEmpty ? 'Uncategorized' : item.category;
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(item);
    }
    
    // Sort categories
    final sortedCategories = grouped.keys.toList()..sort();
    final sortedGrouped = <String, List<DrawerItem>>{};
    for (final category in sortedCategories) {
      sortedGrouped[category] = grouped[category]!;
    }
    
    return sortedGrouped;
  }

  /// Get unique categories from drawer items with counts
  List<String> get categories {
    final cats = drawerItems.map((item) => item.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  /// Get category counts
  Map<String, int> get categoryCounts {
    final counts = <String, int>{};
    for (final item in drawerItems) {
      final category = item.category.isEmpty ? 'Uncategorized' : item.category;
      counts[category] = (counts[category] ?? 0) + 1;
    }
    return counts;
  }

  /// Get status options
  List<String> get statusOptions => ['All', 'Organized', 'Unorganized'];

  /// Get sort options
  List<String> get sortOptions => ['name', 'category', 'status', 'quantity'];

  /// Get all unique styles used in items
  List<String> get usedStyles {
    final styles = <String>{};
    for (final item in drawerItems) {
      styles.addAll(item.styles);
    }
    return styles.toList()..sort();
  }

  /// Toggle a style filter
  void toggleStyle(String style) {
    if (selectedStyles.contains(style)) {
      selectedStyles.remove(style);
    } else {
      selectedStyles.add(style);
    }
  }

  /// Import cheatsheet items by type
  Future<void> importCheatsheetItems(String type) async {
    final cheatsheetService = CheatsheetService();
    List<DrawerItem> items;
    
    switch (type) {
      case 'wardrobe':
        items = await cheatsheetService.getStarterWardrobeItems();
        // Clear existing items when importing wardrobe
        await DataClearer.clearDrawerItems();
        break;
      case 'gym':
        items = await cheatsheetService.getGymEssentialsItems();
        // Don't clear existing items for gym, just add
        break;
      case 'grooming':
        items = await cheatsheetService.getGroomingEssentialsItems();
        // Don't clear existing items for grooming, just add
        break;
      case 'sleepwear':
        items = await cheatsheetService.getSleepwearEssentialsItems();
        // Don't clear existing items for sleepwear, just add
        break;
      default:
        return;
    }
    
    for (final item in items) {
      await _drawerRepo.addDrawerItem(item);
    }
    await _loadDrawerData();
  }
}

