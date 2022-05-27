import 'package:get/get.dart';

import '../controllers/create_item_variant_controller.dart';

class CreateItemVariantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateItemVariantController>(
      () => CreateItemVariantController(),
    );
  }
}
