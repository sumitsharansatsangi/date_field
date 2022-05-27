import 'package:get/get.dart';

import '../controllers/list_customer_category_controller.dart';

class ListCustomerCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListCustomerCategoryController>(
      () => ListCustomerCategoryController(),
    );
  }
}
