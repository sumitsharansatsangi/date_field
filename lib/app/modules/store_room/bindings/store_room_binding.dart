import 'package:get/get.dart';

import '../controllers/store_room_controller.dart';

class StoreRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreRoomController>(
      () => StoreRoomController(),
    );
  }
}
