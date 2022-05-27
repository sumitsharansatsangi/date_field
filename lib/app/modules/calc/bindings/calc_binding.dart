import 'package:get/get.dart';

import '../controllers/calc_controller.dart';

class CalcBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalcController>(
      () => CalcController(),
    );
  }
}
