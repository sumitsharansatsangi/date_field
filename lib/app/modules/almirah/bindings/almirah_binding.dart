import 'package:get/get.dart';

import '../controllers/almirah_controller.dart';

class AlmirahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlmirahController>(
      () => AlmirahController(),
    );
  }
}
