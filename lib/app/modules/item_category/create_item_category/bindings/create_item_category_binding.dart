import 'package:get/get.dart';

import '../controllers/create_item_category_controller.dart';

class CreateItemCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateItemCategoryController>(
      () => CreateItemCategoryController(),
    );
  }
}
