import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/shopping_item.dart';
import '../../../data/models/drawer_item.dart';
import '../../../data/repositories/shopping_repository.dart';
import '../../../data/repositories/drawer_repository.dart';

/// Tab for the stuff view
enum StuffTab {
  closet,    // Current wardrobe items
  shopping,  // Items to buy
  wishlist,  // Want later (low priority)
}

/// Controller for the unified "Stuff" view (Wardrobe + Shopping combined)
class StuffController extends GetxController with GetSingleTickerProviderStateMixin {
  final ShoppingRepository _shoppingRepo = ShoppingRepository();
  final DrawerRepository _drawerRepo = DrawerRepository();
  
  // Tab controller
  late TabController tabController;
  
  // Observables
  final isLoading = true.obs;
  final selectedTab = StuffTab.closet.obs;
  final searchQuery = ''.obs;
  
  // Wardrobe items
  final closetItems = <DrawerItem>[].obs;
  final closetCategories = <String>[].obs;
  
  // Shopping items
  final shoppingItems = <ShoppingItem>[].obs;
  final wishlistItems = <ShoppingItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_onTabChanged);
    _loadData();
  }

  @override
  void onClose() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
    super.onClose();
  }

  void _onTabChanged() {
    switch (tabController.index) {
      case 0:
        selectedTab.value = StuffTab.closet;
        break;
      case 1:
        selectedTab.value = StuffTab.shopping;
        break;
      case 2:
        selectedTab.value = StuffTab.wishlist;
        break;
    }
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _loadClosetItems(),
        _loadShoppingItems(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadClosetItems() async {
    try {
      final items = await _drawerRepo.getDrawerItems();
      closetItems.value = items;
      
      // Extract unique categories
      final categories = items.map((i) => i.category).toSet().toList()..sort();
      closetCategories.value = categories;
    } catch (e) {
      closetItems.value = [];
    }
  }

  Future<void> _loadShoppingItems() async {
    try {
      final items = await _shoppingRepo.getShoppingItems();
      
      // Split by priority - high priority = shopping, low = wishlist
      shoppingItems.value = items
          .where((i) => i.status != ShoppingStatus.purchased && i.priority >= 2)
          .toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));
      
      wishlistItems.value = items
          .where((i) => i.status != ShoppingStatus.purchased && i.priority < 2)
          .toList();
    } catch (e) {
      shoppingItems.value = [];
      wishlistItems.value = [];
    }
  }

  /// Filtered items based on search
  List<DrawerItem> get filteredClosetItems {
    if (searchQuery.isEmpty) return closetItems;
    final query = searchQuery.value.toLowerCase();
    return closetItems.where((item) =>
      item.name.toLowerCase().contains(query) ||
      item.category.toLowerCase().contains(query)
    ).toList();
  }

  List<ShoppingItem> get filteredShoppingItems {
    if (searchQuery.isEmpty) return shoppingItems;
    final query = searchQuery.value.toLowerCase();
    return shoppingItems.where((item) =>
      item.name.toLowerCase().contains(query) ||
      item.category.toLowerCase().contains(query)
    ).toList();
  }

  /// Quick add shopping item with smart categorization
  Future<void> quickAddShopping(String name, {String? category}) async {
    try {
      // Smart category detection
      final detectedCategory = category ?? _detectCategory(name);
      
      final item = ShoppingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        category: detectedCategory,
        quantity: 1,
        priority: 3, // Default to high priority (shopping)
      );
      
      await _shoppingRepo.addShoppingItem(item);
      shoppingItems.add(item);
      
      Get.snackbar(
        'Added',
        '$name added to shopping list',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Move shopping item to wishlist (lower priority)
  Future<void> moveToWishlist(ShoppingItem item) async {
    try {
      final updated = item.copyWith(priority: 1);
      await _shoppingRepo.updateShoppingItem(updated);
      
      shoppingItems.remove(item);
      wishlistItems.add(updated);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to move item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Move wishlist item to shopping (higher priority)
  Future<void> moveToShopping(ShoppingItem item) async {
    try {
      final updated = item.copyWith(priority: 3);
      await _shoppingRepo.updateShoppingItem(updated);
      
      wishlistItems.remove(item);
      shoppingItems.add(updated);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to move item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Mark shopping item as purchased
  Future<void> markPurchased(ShoppingItem item) async {
    try {
      final updated = item.copyWith(status: ShoppingStatus.purchased);
      await _shoppingRepo.updateShoppingItem(updated);
      
      shoppingItems.remove(item);
      wishlistItems.remove(item);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update item',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Smart category detection based on item name
  String _detectCategory(String name) {
    final lower = name.toLowerCase();
    
    // Food & Groceries
    if (_matchesAny(lower, ['milk', 'bread', 'egg', 'cheese', 'butter', 'yogurt', 
        'meat', 'chicken', 'fish', 'vegetable', 'fruit', 'apple', 'banana', 
        'rice', 'pasta', 'cereal', 'coffee', 'tea', 'juice', 'water'])) {
      return 'Groceries';
    }
    
    // Household
    if (_matchesAny(lower, ['soap', 'shampoo', 'detergent', 'tissue', 'towel',
        'cleaner', 'sponge', 'trash bag', 'toilet'])) {
      return 'Household';
    }
    
    // Clothing
    if (_matchesAny(lower, ['shirt', 'pants', 'jeans', 'dress', 'shoe', 'sock',
        'underwear', 'jacket', 'coat', 'sweater', 'hat', 'belt'])) {
      return 'Clothing';
    }
    
    // Electronics
    if (_matchesAny(lower, ['phone', 'charger', 'cable', 'battery', 'headphone',
        'laptop', 'tablet', 'usb'])) {
      return 'Electronics';
    }
    
    return 'Other';
  }

  bool _matchesAny(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }

  Future<void> refresh() async {
    await _loadData();
  }
}


