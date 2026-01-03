import 'package:get/get.dart';
import '../controllers/items_controller.dart';
import '../../inventory/wardrobe/controllers/wardrobe_controller.dart';
import '../../shopping/controllers/shopping_controller.dart';

class ItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemsController>(
      () => ItemsController(),
    );
    // Initialize controllers for child views used in IndexedStack
    Get.lazyPut<WardrobeController>(
      () => WardrobeController(),
    );
    Get.lazyPut<ShoppingController>(
      () => ShoppingController(),
    );
  }
}

