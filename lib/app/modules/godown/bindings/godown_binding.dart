import 'package:get/get.dart';

import '../controllers/godown_controller.dart';

class GodownBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GodownController>(
      () => GodownController(),
    );
  }
}
