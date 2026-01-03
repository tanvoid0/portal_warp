import 'package:get/get.dart';

class ItemsController extends GetxController {
  final selectedTab = 0.obs; // 0 = Inventory, 1 = Shopping

  void selectTab(int index) {
    selectedTab.value = index;
  }
}

