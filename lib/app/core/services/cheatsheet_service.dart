import '../../data/models/drawer_item.dart';
import '../../data/models/shopping_item.dart';
import '../../data/models/plan_item.dart';
import '../../data/repositories/cheatsheet_repository.dart';

/// Service that provides starter checklists from the cheatsheet
/// Uses CheatsheetRepository to load data from JSON (will be replaced with backend)
class CheatsheetService {
  final CheatsheetRepository _repository = CheatsheetRepository();

  /// Get starter wardrobe items as drawer items
  Future<List<DrawerItem>> getStarterWardrobeItems() async {
    return await _repository.getStarterWardrobeItems();
  }

  /// Get gym essentials items as drawer items
  Future<List<DrawerItem>> getGymEssentialsItems() async {
    return await _repository.getGymEssentialsItems();
  }

  /// Get grooming essentials items as drawer items
  Future<List<DrawerItem>> getGroomingEssentialsItems() async {
    return await _repository.getGroomingEssentialsItems();
  }

  /// Get sleepwear essentials items as drawer items
  Future<List<DrawerItem>> getSleepwearEssentialsItems() async {
    return await _repository.getSleepwearEssentialsItems();
  }

  /// Get drawer organization categories from cheatsheet
  Future<List<String>> getDrawerCategories() async {
    return await _repository.getDrawerCategories();
  }

  /// Get starter shopping list essentials
  Future<List<ShoppingItem>> getStarterShoppingEssentials() async {
    return await _repository.getStarterShoppingEssentials();
  }

  /// Get priority buy order for wardrobe
  Future<List<ShoppingItem>> getWardrobeBuyOrder() async {
    return await _repository.getWardrobeBuyOrder();
  }

  /// Get daily checklist items as plan items
  Future<List<PlanItem>> getDailyChecklistItems(DateTime date) async {
    return await _repository.getDailyChecklistItems(date);
  }
}
