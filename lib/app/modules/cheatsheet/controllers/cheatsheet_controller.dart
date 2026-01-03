import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/cheatsheet_service.dart';
import '../../../data/models/drawer_item.dart';
import '../../../data/models/shopping_item.dart';

class CheatsheetController extends GetxController {
  final CheatsheetService _cheatsheetService = CheatsheetService();
  
  final isLoading = false.obs;
  final selectedCategory = ''.obs;
  
  // Cache for loaded items
  final _drawerItemsCache = <String, List<DrawerItem>>{};
  final _shoppingItemsCache = <String, List<ShoppingItem>>{};

  // Cheatsheet categories
  final cheatsheetCategories = [
    CheatsheetCategory(
      id: 'wardrobe',
      title: 'Wardrobe',
      description: 'Starter wardrobe essentials',
      icon: Icons.checkroom,
      color: 0xFF6B6BFF,
      type: CheatsheetType.drawer,
    ),
    CheatsheetCategory(
      id: 'gym',
      title: 'Gym',
      description: 'Gym essentials and workout gear',
      icon: Icons.fitness_center,
      color: 0xFFFF6B6B,
      type: CheatsheetType.drawer,
    ),
    CheatsheetCategory(
      id: 'grooming',
      title: 'Grooming',
      description: 'Personal care and grooming products',
      icon: Icons.content_cut,
      color: 0xFF4ECDC4,
      type: CheatsheetType.drawer,
    ),
    CheatsheetCategory(
      id: 'sleepwear',
      title: 'Sleepwear',
      description: 'Comfortable sleep essentials',
      icon: Icons.bed,
      color: 0xFF95E1D3,
      type: CheatsheetType.drawer,
    ),
    CheatsheetCategory(
      id: 'cooking',
      title: 'Cooking',
      description: 'Kitchen essentials and groceries',
      icon: Icons.restaurant,
      color: 0xFFFFD93D,
      type: CheatsheetType.shopping,
    ),
  ];

  Future<List<DrawerItem>> getDrawerItems(String categoryId) async {
    // Return cached if available
    if (_drawerItemsCache.containsKey(categoryId)) {
      return _drawerItemsCache[categoryId]!;
    }
    
    isLoading.value = true;
    try {
      List<DrawerItem> items;
      switch (categoryId) {
        case 'wardrobe':
          items = await _cheatsheetService.getStarterWardrobeItems();
          break;
        case 'gym':
          items = await _cheatsheetService.getGymEssentialsItems();
          break;
        case 'grooming':
          items = await _cheatsheetService.getGroomingEssentialsItems();
          break;
        case 'sleepwear':
          items = await _cheatsheetService.getSleepwearEssentialsItems();
          break;
        default:
          items = [];
      }
      _drawerItemsCache[categoryId] = items;
      return items;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ShoppingItem>> getShoppingItems(String categoryId) async {
    // Return cached if available
    if (_shoppingItemsCache.containsKey(categoryId)) {
      return _shoppingItemsCache[categoryId]!;
    }
    
    isLoading.value = true;
    try {
      List<ShoppingItem> items;
      switch (categoryId) {
        case 'cooking':
          items = await _cheatsheetService.getStarterShoppingEssentials();
          break;
        default:
          items = [];
      }
      _shoppingItemsCache[categoryId] = items;
      return items;
    } finally {
      isLoading.value = false;
    }
  }
}

class CheatsheetCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int color;
  final CheatsheetType type;

  CheatsheetCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.type,
  });
}

enum CheatsheetType {
  drawer,
  shopping,
  plan,
}

