import 'package:get/get.dart';

import '../controllers/create_purchase_order_controller.dart';

class CreatePurchaseOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePurchaseOrderController>(
      () => CreatePurchaseOrderController(),
    );
  }
}
