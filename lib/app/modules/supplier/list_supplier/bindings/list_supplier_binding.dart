import 'package:get/get.dart';

import '../controllers/list_supplier_controller.dart';

class ListSupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListSupplierController>(
      () => ListSupplierController(),
    );
  }
}
