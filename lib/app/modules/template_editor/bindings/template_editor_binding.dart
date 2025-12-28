import 'package:get/get.dart';

import '../controllers/template_editor_controller.dart';

class TemplateEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TemplateEditorController>(
      () => TemplateEditorController(),
    );
  }
}
