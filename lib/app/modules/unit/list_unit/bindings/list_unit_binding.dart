import 'package:get/get.dart';

import '../controllers/list_unit_controller.dart';

class ListUnitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListUnitController>(
      () => ListUnitController(),
    );
  }
}
