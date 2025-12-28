import 'package:get/get.dart';
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

  Future<void> _loadShoppingItems() async {
    isLoading.value = true;
    try {
      shoppingItems.value = await _shoppingRepo.getShoppingItems();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addShoppingItem(ShoppingItem item) async {
    await _shoppingService.addShoppingItem(item);
    await _loadShoppingItems();
  }

  Future<void> markPurchased(String id) async {
    await _shoppingService.markPurchased(id);
    await _loadShoppingItems();
  }

  Future<void> updateShoppingItem(ShoppingItem item) async {
    await _shoppingRepo.updateShoppingItem(item);
    await _loadShoppingItems();
  }

  Future<void> deleteShoppingItem(String id) async {
    await _shoppingRepo.deleteShoppingItem(id);
    await _loadShoppingItems();
  }

  List<ShoppingItem> get filteredItems {
    var items = shoppingItems;
    
    if (showOnlyPending.value) {
      items = items.where((item) => item.status.name == 'pending').toList().obs;
    }
    
    if (searchQuery.value.isNotEmpty) {
      items = items.where((item) {
        return item.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            item.category.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList().obs;
    }
    
    return items;
  }

  /// Import starter shopping essentials from cheatsheet
  Future<void> importStarterEssentials() async {
    // Clear existing shopping items first
    await DataClearer.clearShoppingItems();
    // Load fresh data from cheatsheet
    final cheatsheetService = CheatsheetService();
    final starterItems = await cheatsheetService.getStarterShoppingEssentials();
    for (final item in starterItems) {
      await _shoppingRepo.addShoppingItem(item);
    }
    await _loadShoppingItems();
  }

  /// Import wardrobe buy order from cheatsheet
  Future<void> importWardrobeBuyOrder() async {
    // Clear existing shopping items first
    await DataClearer.clearShoppingItems();
    // Load fresh data from cheatsheet
    final cheatsheetService = CheatsheetService();
    final buyOrder = await cheatsheetService.getWardrobeBuyOrder();
    for (final item in buyOrder) {
      await _shoppingRepo.addShoppingItem(item);
    }
    await _loadShoppingItems();
  }
}
