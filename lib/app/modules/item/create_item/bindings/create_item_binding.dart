import 'package:get/get.dart';

import '../controllers/create_item_controller.dart';

class CreateItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateItemController>(
      () => CreateItemController(),
    );
  }
}
