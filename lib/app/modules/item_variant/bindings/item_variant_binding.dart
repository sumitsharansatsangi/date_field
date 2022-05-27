import 'package:get/get.dart';

import '../controllers/item_variant_controller.dart';

class ItemVariantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemVariantController>(
      () => ItemVariantController(),
    );
  }
}
