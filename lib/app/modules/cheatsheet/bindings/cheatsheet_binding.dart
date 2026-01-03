import 'package:get/get.dart';
import '../controllers/cheatsheet_controller.dart';

class CheatsheetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheatsheetController());
  }
}

