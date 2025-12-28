import 'package:get/get.dart';
import '../../../data/models/drawer_item.dart';
import '../../../data/repositories/drawer_repository.dart';
import '../../../core/services/drawer_service.dart';
import '../../../core/services/cheatsheet_service.dart';
import '../../../data/local/data_clearer.dart';

class DrawerController extends GetxController {
  final DrawerRepository _drawerRepo = DrawerRepository();
  final DrawerService _drawerService = DrawerService(DrawerRepository());

  final drawerItems = <DrawerItem>[].obs;
  final drawerStatus = <String, dynamic>{}.obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;

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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDrawerItem(DrawerItem item) async {
    await _drawerRepo.addDrawerItem(item);
    await _loadDrawerData();
  }

  Future<void> updateDrawerItem(DrawerItem item) async {
    await _drawerRepo.updateDrawerItem(item);
    await _loadDrawerData();
  }

  Future<void> markOrganized(String id) async {
    await _drawerService.markOrganized(id);
    await _loadDrawerData();
  }

  Future<void> deleteDrawerItem(String id) async {
    await _drawerRepo.deleteDrawerItem(id);
    await _loadDrawerData();
  }

  List<DrawerItem> get filteredItems {
    if (searchQuery.value.isEmpty) {
      return drawerItems;
    }
    return drawerItems.where((item) {
      return item.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          item.category.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  /// Import starter wardrobe items from cheatsheet
  Future<void> importStarterWardrobe() async {
    // Clear existing drawer items first
    await DataClearer.clearDrawerItems();
    // Load fresh data from cheatsheet
    final cheatsheetService = CheatsheetService();
    final starterItems = await cheatsheetService.getStarterWardrobeItems();
    for (final item in starterItems) {
      await _drawerRepo.addDrawerItem(item);
    }
    await _loadDrawerData();
  }
}
