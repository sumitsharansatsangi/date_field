import 'package:get/get.dart';

import '../controllers/list_customer_controller.dart';

class ListCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListCustomerController>(
      () => ListCustomerController(),
    );
  }
}
