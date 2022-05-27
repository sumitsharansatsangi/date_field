import 'package:get/get.dart';

import '../controllers/create_purchased_item_controller.dart';

class CreatePurchasedItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePurchasedItemController>(
      () => CreatePurchasedItemController(),
    );
  }
}
