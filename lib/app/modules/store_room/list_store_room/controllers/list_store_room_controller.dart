import 'package:app/app/data/model.dart';
import 'package:app/app/modules/store_room/controllers/store_room_controller.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ListStoreRoomController extends GetxController {
  final searchController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final isLoading = false.obs;
  final storeRoomList = <StoreRoom>[].obs;
  final storeController = Get.put(StoreRoomController());
  final selectedIndex = 0.obs;
  @override
  void onReady() {
    super.onReady();
    storeRoomList.value = objectBoxController.storeRoomBox.getAll();
  }
}
