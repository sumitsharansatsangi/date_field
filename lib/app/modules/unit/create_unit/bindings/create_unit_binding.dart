import 'package:get/get.dart';

import '../controllers/create_unit_controller.dart';

class CreateUnitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateUnitController>(
      () => CreateUnitController(),
    );
  }
}
