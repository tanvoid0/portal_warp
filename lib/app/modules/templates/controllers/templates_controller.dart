import 'package:get/get.dart';
import '../../../data/models/quest_template.dart';
import '../../../data/models/focus_area.dart';
import '../../../data/repositories/templates_repository.dart';

class TemplatesController extends GetxController {
  final TemplatesRepository _templatesRepo = TemplatesRepository();

  final templates = <QuestTemplate>[].obs;
  final isLoading = true.obs;
  final selectedFocusArea = FocusArea.clothes.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    isLoading.value = true;
    try {
      await _templatesRepo.seedTemplatesIfEmpty();
      templates.value = await _templatesRepo.getAllTemplates();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTemplate(QuestTemplate template) async {
    await _templatesRepo.addTemplate(template);
    await _loadTemplates();
  }

  Future<void> updateTemplate(QuestTemplate template) async {
    await _templatesRepo.updateTemplate(template);
    await _loadTemplates();
  }

  Future<void> deleteTemplate(String id) async {
    await _templatesRepo.deleteTemplate(id);
    await _loadTemplates();
  }

  List<QuestTemplate> get filteredTemplates {
    var filtered = templates.where((t) => t.focusAreaId == selectedFocusArea.value).toList();
    
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((t) {
        return t.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            t.instructions.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
    
    return filtered;
  }
}
