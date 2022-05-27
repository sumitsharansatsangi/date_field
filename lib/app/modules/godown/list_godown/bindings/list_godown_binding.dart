import 'package:get/get.dart';

import '../controllers/list_godown_controller.dart';

class ListGodownBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListGodownController>(
      () => ListGodownController(),
    );
  }
}
