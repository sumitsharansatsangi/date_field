import 'package:get/get.dart';

import '../controllers/list_store_room_controller.dart';

class ListStoreRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListStoreRoomController>(
      () => ListStoreRoomController(),
    );
  }
}
