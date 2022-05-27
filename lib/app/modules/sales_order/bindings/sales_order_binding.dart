import 'package:get/get.dart';

import '../controllers/sales_order_controller.dart';

class SalesOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesOrderController>(
      () => SalesOrderController(),
    );
  }
}
