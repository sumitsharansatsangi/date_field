import 'package:get/get.dart';

import '../controllers/create_diary_controller.dart';

class CreateDiaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateDiaryController>(
      () => CreateDiaryController(),
    );
  }
}
