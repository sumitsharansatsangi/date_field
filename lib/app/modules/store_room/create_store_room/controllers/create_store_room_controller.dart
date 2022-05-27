import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CreateStoreRoomController extends GetxController {
  final appBarText = 'add_store_room'.tr.obs;
  final isUpdating = false.obs;
  StoreRoom? updatingStoreRoom;
  final nameController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final currentGodown = Godown().obs;
  final godowns = <Godown>[].obs;
  final isLoading = false.obs;
  final isAddMore = false.obs;
  final addOpenSpace = false.obs;

  @override
  void onInit() {
    super.onInit();
    godowns.value = objectBoxController.godownBox.getAll();
    if (godowns.isNotEmpty) {
      currentGodown.value = godowns.first;
    }
    isUpdating.value = Get.arguments[0];
  }

  @override
  void onReady() {
    super.onReady();
    if (isUpdating.value) {
      appBarText.value = 'update_store_room'.tr;
      updatingStoreRoom = Get.arguments[1];
      nameController.text = updatingStoreRoom!.name!;
      if (updatingStoreRoom!.godown.target != null) {
        currentGodown.value = updatingStoreRoom!.godown.target!;
      }
    }
  }

  addStoreRoom() {
    try {
      isLoading.value = true;
      final storeRoom = StoreRoom()
        ..name = nameController.text.trim().capitalizeFirst
        ..godown.targetId = currentGodown.value.id;
      if (isUpdating.value) {
        storeRoom.id = updatingStoreRoom!.id!;
      }
      int id = objectBoxController.storeRoomBox.put(storeRoom);
      if (id != -1) {
        if (addOpenSpace.value) {
          objectBoxController.almirahBox.put(Almirah()
            ..name = "openspace".tr
            ..room.targetId = id);
        }
        isLoading.value = false;
        if (!isAddMore.value) {
          Get.back();
          if (isUpdating.value) {
            successSnackBar("store_room_updated_success_msg".tr);
          } else {
            successSnackBar("store_room_success_msg".tr);
          }
        } else {
          nameController.clear();
          successSnackBar("store_room_success_msg".tr);
        }
      } else {
        isLoading.value = false;
        errorSnackBar();
      }
    } on UniqueViolationException {
      isLoading.value = false;
      alertSnackBar();
    } on Exception {
      isLoading.value = false;
      errorSnackBar();
    }
  }
}
