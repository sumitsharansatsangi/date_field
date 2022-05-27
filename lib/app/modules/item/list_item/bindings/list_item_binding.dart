import 'package:get/get.dart';

import '../controllers/list_item_controller.dart';

class ListItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListItemController>(
      () => ListItemController(),
    );
  }
}
