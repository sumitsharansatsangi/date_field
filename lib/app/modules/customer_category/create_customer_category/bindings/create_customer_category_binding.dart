import 'package:get/get.dart';

import '../controllers/create_customer_category_controller.dart';

class CreateCustomerCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateCustomerCategoryController>(
      () => CreateCustomerCategoryController(),
    );
  }
}
