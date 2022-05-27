import 'package:get/get.dart';

import '../controllers/list_item_variant_controller.dart';

class ListItemVariantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListItemVariantController>(
      () => ListItemVariantController(),
    );
  }
}
