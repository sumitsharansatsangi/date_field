import 'package:get/get.dart';

import '../controllers/create_supplier_controller.dart';

class CreateSupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateSupplierController>(
      () => CreateSupplierController(),
    );
  }
}
