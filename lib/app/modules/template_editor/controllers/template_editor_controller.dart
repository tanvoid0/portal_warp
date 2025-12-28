import 'package:get/get.dart';
import '../../../data/models/quest_template.dart';
import '../../../data/models/focus_area.dart';
import '../../../data/repositories/templates_repository.dart';

class TemplateEditorController extends GetxController {
  final TemplatesRepository _templatesRepo = TemplatesRepository();

  final isEditing = false.obs;
  final template = QuestTemplate(
    id: '',
    focusAreaId: FocusArea.clothes,
    title: '',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is QuestTemplate) {
      isEditing.value = true;
      template.value = args;
    } else {
      template.value = template.value.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
    }
  }

  void updateTitle(String title) {
    template.value = template.value.copyWith(title: title);
  }

  void updateFocusArea(FocusArea area) {
    template.value = template.value.copyWith(focusAreaId: area);
  }

  void updateDurationBucket(int duration) {
    template.value = template.value.copyWith(durationBucket: duration);
  }

  void updateDifficulty(int difficulty) {
    template.value = template.value.copyWith(difficulty: difficulty.clamp(1, 5));
  }

  void updateCooldownDays(int days) {
    template.value = template.value.copyWith(cooldownDays: days);
  }

  void updateInstructions(String instructions) {
    template.value = template.value.copyWith(instructions: instructions);
  }

  Future<void> saveTemplate() async {
    if (template.value.title.isEmpty) {
      Get.snackbar('Error', 'Title is required');
      return;
    }

    if (isEditing.value) {
      await _templatesRepo.updateTemplate(template.value);
    } else {
      await _templatesRepo.addTemplate(template.value);
    }

    Get.back();
    Get.back(); // Go back to templates list
  }
}
