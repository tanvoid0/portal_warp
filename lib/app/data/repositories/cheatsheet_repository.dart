import 'dart:convert';
import 'package:flutter/services.dart';
import '../local/json_storage.dart';
import '../models/drawer_item.dart';
import '../models/shopping_item.dart';
import '../models/plan_item.dart';
import '../models/item_unit.dart';

/// Repository for cheatsheet data using JSON file storage
/// This will be replaced with a backend service in the future
class CheatsheetRepository {
  static const String _assetPath = 'assets/cheatsheet_data.json';
  static const String _filename = 'cheatsheet_data.json';

  /// Load cheatsheet data from asset (fallback) or local JSON file
  Future<Map<String, dynamic>> _loadCheatsheetData() async {
    try {
      // Try to load from local JSON file first (user may have customized it)
      final localData = await JsonStorage.readObject(_filename);
      if (localData != null) {
        return localData;
      }
    } catch (e) {
      // If local file doesn't exist, load from asset
    }

    // Load from asset as fallback
    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      // Save to local storage for future use
      await JsonStorage.writeObject(_filename, data);
      return data;
    } catch (e) {
      // Return empty data if asset loading fails
      return {};
    }
  }

  ItemUnit _parseUnit(Map<String, dynamic>? unitData) {
    if (unitData == null) return const ItemUnit();
    final typeStr = unitData['type'] as String? ?? 'count';
    final customUnit = unitData['customUnit'] as String? ?? '';
    
    UnitType type;
    try {
      type = UnitType.values.firstWhere((e) => e.name == typeStr);
    } catch (e) {
      type = UnitType.count;
    }
    
    return ItemUnit(
      type: type,
      customUnit: customUnit,
    );
  }

  /// Get starter wardrobe items as drawer items
  Future<List<DrawerItem>> getStarterWardrobeItems() async {
    final data = await _loadCheatsheetData();
    final wardrobeList = data['starterWardrobe'] as List? ?? [];

    return wardrobeList.map((item) {
      return DrawerItem(
        id: 'starter_wardrobe_${item['name']}',
        category: item['category'] as String? ?? '',
        name: item['name'] as String? ?? '',
        location: item['location'] as String? ?? '',
        status: DrawerStatus.unorganized,
        notes: item['notes'] as String?,
        currentQuantity: (item['currentQuantity'] as num?)?.toInt() ?? 0,
        targetQuantity: (item['targetQuantity'] as num?)?.toInt() ?? 0,
        unit: _parseUnit(item['unit'] as Map<String, dynamic>?),
      );
    }).toList();
  }

  /// Get drawer organization categories
  Future<List<String>> getDrawerCategories() async {
    final data = await _loadCheatsheetData();
    final categories = data['drawerCategories'] as List? ?? [];
    return categories.map((e) => e.toString()).toList();
  }

  /// Get starter shopping list essentials
  Future<List<ShoppingItem>> getStarterShoppingEssentials() async {
    final data = await _loadCheatsheetData();
    final essentialsList = data['shoppingEssentials'] as List? ?? [];

    return essentialsList.map((item) {
      return ShoppingItem(
        id: 'starter_shopping_${item['name']}',
        name: item['name'] as String? ?? '',
        category: item['category'] as String? ?? '',
        quantity: (item['quantity'] as num?)?.toInt() ?? 1,
        priority: (item['priority'] as num?)?.toInt() ?? 1,
        status: ShoppingStatus.pending,
        unit: _parseUnit(item['unit'] as Map<String, dynamic>?),
      );
    }).toList();
  }

  /// Get priority buy order for wardrobe
  Future<List<ShoppingItem>> getWardrobeBuyOrder() async {
    final data = await _loadCheatsheetData();
    final buyOrderList = data['wardrobeBuyOrder'] as List? ?? [];

    return buyOrderList.map((item) {
      return ShoppingItem(
        id: 'wardrobe_buy_${item['name']}',
        name: item['name'] as String? ?? '',
        category: item['category'] as String? ?? '',
        quantity: (item['quantity'] as num?)?.toInt() ?? 1,
        priority: (item['priority'] as num?)?.toInt() ?? 1,
        status: ShoppingStatus.pending,
        unit: _parseUnit(item['unit'] as Map<String, dynamic>?),
      );
    }).toList();
  }

  /// Get daily checklist items as plan items
  Future<List<PlanItem>> getDailyChecklistItems(DateTime date) async {
    final data = await _loadCheatsheetData();
    final dailyChecklist = data['dailyChecklist'] as Map? ?? {};
    final morning = dailyChecklist['morning'] as List? ?? [];
    final night = dailyChecklist['night'] as List? ?? [];

    final items = <PlanItem>[];

    // Add morning items
    for (final task in morning) {
      if (task is Map) {
        items.add(PlanItem(
          id: 'daily_morning_${task['title']}',
          title: task['title'] as String? ?? task.toString(),
          date: date,
          category: 'Morning Routine',
          status: PlanStatus.pending,
          quantity: (task['quantity'] as num?)?.toInt() ?? 1,
          unit: _parseUnit(task['unit'] as Map<String, dynamic>?),
        ));
      } else {
        items.add(PlanItem(
          id: 'daily_morning_${task}',
          title: task.toString(),
          date: date,
          category: 'Morning Routine',
          status: PlanStatus.pending,
        ));
      }
    }

    // Add night items
    for (final task in night) {
      if (task is Map) {
        items.add(PlanItem(
          id: 'daily_night_${task['title']}',
          title: task['title'] as String? ?? task.toString(),
          date: date,
          category: task['category'] as String? ?? 'Night Routine',
          status: PlanStatus.pending,
          quantity: (task['quantity'] as num?)?.toInt() ?? 1,
          unit: _parseUnit(task['unit'] as Map<String, dynamic>?),
        ));
      } else {
        items.add(PlanItem(
          id: 'daily_night_${task}',
          title: task.toString(),
          date: date,
          category: 'Night Routine',
          status: PlanStatus.pending,
        ));
      }
    }

    return items;
  }

  /// Update cheatsheet data (for future customization)
  Future<void> updateCheatsheetData(Map<String, dynamic> data) async {
    await JsonStorage.writeObject(_filename, data);
  }
}

