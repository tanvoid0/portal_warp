import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/shopping_item.dart';
import '../../../data/repositories/shopping_repository.dart';
import '../../../core/services/shopping_service.dart';
import '../../../core/services/cheatsheet_service.dart';
import '../../../data/local/data_clearer.dart';

class ShoppingController extends GetxController {
  final ShoppingRepository _shoppingRepo = ShoppingRepository();
  late final ShoppingService _shoppingService;

  @override
  void onInit() {
    super.onInit();
    _shoppingService = ShoppingService(_shoppingRepo);
    _loadShoppingItems();
  }

  final shoppingItems = <ShoppingItem>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final showOnlyPending = true.obs;
  final sortBy = 'priority'.obs; // priority, name, category
  final sortAscending = false.obs; // false = high priority first
  final groupByCategory = false.obs;

  Future<void> _loadShoppingItems() async {
    isLoading.value = true;
    try {
      shoppingItems.value = await _shoppingRepo.getShoppingItems();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load shopping items: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addShoppingItem(ShoppingItem item) async {
    try {
      await _shoppingService.addShoppingItem(item);
      await _loadShoppingItems();
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

  Future<void> markPurchased(String id) async {
    try {
      await _shoppingService.markPurchased(id);
      await _loadShoppingItems();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark as purchased: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> markPending(String id) async {
    try {
      final items = await _shoppingRepo.getShoppingItems();
      final item = items.firstWhere((i) => i.id == id);
      await _shoppingRepo.updateShoppingItem(
        item.copyWith(status: ShoppingStatus.pending),
      );
      await _loadShoppingItems();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark as pending: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateShoppingItem(ShoppingItem item) async {
    try {
      await _shoppingRepo.updateShoppingItem(item);
      await _loadShoppingItems();
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

  Future<void> deleteShoppingItem(String id) async {
    try {
      await _shoppingRepo.deleteShoppingItem(id);
      await _loadShoppingItems();
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

  List<ShoppingItem> get filteredItems {
    var items = List<ShoppingItem>.from(shoppingItems);
    
    if (showOnlyPending.value) {
      items = items.where((item) => item.status.name == 'pending').toList();
    }
    
    if (searchQuery.value.isNotEmpty) {
      items = items.where((item) {
        return item.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            item.category.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
    
    // Sort items
    items.sort((a, b) {
      int comparison = 0;
      switch (sortBy.value) {
        case 'priority':
          // Priority order: lower number = higher priority (1 is highest, 5 is lowest)
          comparison = a.priority.compareTo(b.priority);
          if (comparison == 0) {
            comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          }
          break;
        case 'name':
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case 'category':
          comparison = a.category.toLowerCase().compareTo(b.category.toLowerCase());
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
  Map<String, List<ShoppingItem>> get groupedItems {
    final items = filteredItems;
    final grouped = <String, List<ShoppingItem>>{};
    
    for (final item in items) {
      final category = item.category.isEmpty ? 'Uncategorized' : item.category;
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(item);
    }
    
    // Sort categories
    final sortedCategories = grouped.keys.toList()..sort();
    final sortedGrouped = <String, List<ShoppingItem>>{};
    for (final category in sortedCategories) {
      sortedGrouped[category] = grouped[category]!;
    }
    
    return sortedGrouped;
  }

  /// Get category counts
  Map<String, int> get categoryCounts {
    final counts = <String, int>{};
    for (final item in shoppingItems) {
      final category = item.category.isEmpty ? 'Uncategorized' : item.category;
      counts[category] = (counts[category] ?? 0) + 1;
    }
    return counts;
  }

  /// Get unique categories
  List<String> get categories {
    final cats = shoppingItems.map((item) => item.category).where((c) => c.isNotEmpty).toSet().toList();
    cats.sort();
    return cats;
  }

  /// Get sort options
  List<String> get sortOptions => ['priority', 'name', 'category'];

  /// Import starter shopping essentials from cheatsheet
  Future<void> importStarterEssentials() async {
    try {
      // Clear existing shopping items first
      await DataClearer.clearShoppingItems();
      // Load fresh data from cheatsheet
      final cheatsheetService = CheatsheetService();
      final starterItems = await cheatsheetService.getStarterShoppingEssentials();
      for (final item in starterItems) {
        await _shoppingRepo.addShoppingItem(item);
      }
      await _loadShoppingItems();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to import starter essentials: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  /// Import wardrobe buy order from cheatsheet
  Future<void> importWardrobeBuyOrder() async {
    try {
      // Clear existing shopping items first
      await DataClearer.clearShoppingItems();
      // Load fresh data from cheatsheet
      final cheatsheetService = CheatsheetService();
      final buyOrder = await cheatsheetService.getWardrobeBuyOrder();
      for (final item in buyOrder) {
        await _shoppingRepo.addShoppingItem(item);
      }
      await _loadShoppingItems();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to import wardrobe buy order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }
}
