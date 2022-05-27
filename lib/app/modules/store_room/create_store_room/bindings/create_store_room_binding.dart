import 'package:get/get.dart';

import '../controllers/create_store_room_controller.dart';

class CreateStoreRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateStoreRoomController>(
      () => CreateStoreRoomController(),
    );
  }
}
