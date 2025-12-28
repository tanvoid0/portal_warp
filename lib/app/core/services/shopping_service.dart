import '../../data/repositories/shopping_repository.dart';
import '../../data/models/shopping_item.dart';

class ShoppingService {
  final ShoppingRepository _shoppingRepo;

  ShoppingService(this._shoppingRepo);

  Future<List<ShoppingItem>> getPendingItems() async {
    return await _shoppingRepo.getPendingItems();
  }

  Future<List<ShoppingItem>> getAllItems() async {
    return await _shoppingRepo.getShoppingItems();
  }

  Future<void> addShoppingItem(ShoppingItem item) async {
    await _shoppingRepo.addShoppingItem(item);
  }

  Future<void> markPurchased(String id) async {
    await _shoppingRepo.markPurchased(id);
  }

  // Link items to cooking quests
  Future<void> linkToQuest(String itemId, String questId) async {
    final items = await _shoppingRepo.getShoppingItems();
    final item = items.firstWhere((i) => i.id == itemId);
    await _shoppingRepo.updateShoppingItem(
      item.copyWith(linkedQuestId: questId),
    );
  }
}

