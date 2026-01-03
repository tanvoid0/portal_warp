import 'package:get/get.dart';
import '../controllers/stuff_controller.dart';

class StuffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StuffController>(() => StuffController());
  }
}


