import '../../data/repositories/drawer_repository.dart';
import '../../data/models/drawer_item.dart';

class DrawerService {
  final DrawerRepository _drawerRepo;

  DrawerService(this._drawerRepo);

  Future<Map<String, dynamic>> getDrawerStatus() async {
    return await _drawerRepo.getDrawerStatus();
  }

  Future<List<DrawerItem>> getDrawerItems() async {
    return await _drawerRepo.getDrawerItems();
  }

  Future<void> addDrawerItem(DrawerItem item) async {
    await _drawerRepo.addDrawerItem(item);
  }

  Future<void> markOrganized(String id) async {
    final items = await _drawerRepo.getDrawerItems();
    final item = items.firstWhere((i) => i.id == id);
    await _drawerRepo.updateDrawerItem(
      item.copyWith(
        status: DrawerStatus.organized,
        lastOrganized: DateTime.now(),
      ),
    );
  }

  // Suggest organization quests based on drawer state
  Future<bool> shouldSuggestOrganizationQuest() async {
    final status = await getDrawerStatus();
    final percentage = (status['percentage'] as num?)?.toDouble() ?? 1.0;
    return percentage < 0.5; // Less than 50% organized
  }
}

