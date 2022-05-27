import 'package:get/get.dart';

import '../controllers/purchased_item_controller.dart';

class PurchasedItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchasedItemController>(
      () => PurchasedItemController(),
    );
  }
}
