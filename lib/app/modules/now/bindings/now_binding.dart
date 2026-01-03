import 'package:get/get.dart';
import '../controllers/now_controller.dart';

class NowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NowController>(() => NowController());
  }
}


