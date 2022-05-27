import 'package:get/get.dart';

import '../controllers/list_item_category_controller.dart';

class ListItemCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListItemCategoryController>(
      () => ListItemCategoryController(),
    );
  }
}
