import 'package:get/get.dart';

import '../controllers/create_almirah_controller.dart';

class CreateAlmirahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAlmirahController>(
      () => CreateAlmirahController(),
    );
  }
}
