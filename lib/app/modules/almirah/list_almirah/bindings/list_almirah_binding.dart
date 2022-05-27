import 'package:get/get.dart';

import '../controllers/list_almirah_controller.dart';

class ListAlmirahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListAlmirahController>(
      () => ListAlmirahController(),
    );
  }
}
