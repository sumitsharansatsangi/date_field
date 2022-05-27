import 'package:get/get.dart';

import '../controllers/create_godown_controller.dart';

class CreateGodownBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateGodownController>(
      () => CreateGodownController(),
    );
  }
}
