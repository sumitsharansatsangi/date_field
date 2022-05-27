import 'package:get/get.dart';

import '../controllers/list_purchase_order_controller.dart';

class ListPurchaseOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListPurchaseOrderController>(
      () => ListPurchaseOrderController(),
    );
  }
}
