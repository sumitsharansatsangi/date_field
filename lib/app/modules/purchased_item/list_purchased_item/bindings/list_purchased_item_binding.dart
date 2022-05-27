import 'package:get/get.dart';

import '../controllers/list_purchased_item_controller.dart';

class ListPurchasedItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListPurchasedItemController>(
      () => ListPurchasedItemController(),
    );
  }
}
