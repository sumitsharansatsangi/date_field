import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAlmirahController extends GetxController {
  final appBarText = 'add_almirah'.tr.obs;
  final isUpdating = false.obs;
  Almirah? updatingAlmirah;
  final nameController = TextEditingController();
  final rowController = TextEditingController();
  final columnController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final isLoading = false.obs;
  final isAddMore = false.obs;
  final currentGodown = Godown().obs;
  final godowns = <Godown>[].obs;
  final currentStoreRoom = StoreRoom().obs;
  final storeRooms = <StoreRoom>[].obs;

  @override
  void onReady() {
    super.onReady();
    isUpdating.value = Get.arguments[0];
    godowns.value = objectBoxController.godownBox.getAll();
    if (godowns.isNotEmpty) {
      currentGodown.value = godowns.first;
    }
    if (isUpdating.value) {
      appBarText.value = 'update_almirah'.tr;
      updatingAlmirah = Get.arguments[1];
      if (updatingAlmirah!.name != null) {
        nameController.text = updatingAlmirah!.name ?? " ";
      }
    }
  }

  fetchStoreRoom(int id) {
    storeRooms.value = objectBoxController.storeRoomBox
        .query(StoreRoom_.godown.equals(id))
        .build()
        .find();
    currentStoreRoom.value = storeRooms.first;
  }

  addAlmirah() {
    try {
      isLoading.value = true;
      final almirah = Almirah()
        ..name = nameController.text.trim().capitalizeFirst
        ..row = int.parse(rowController.text)
        ..column = int.parse(columnController.text)
        ..room.targetId = currentStoreRoom.value.id;
      if (isUpdating.value) {
        almirah.id = updatingAlmirah!.id!;
      }
      int id = objectBoxController.almirahBox.put(almirah);
      if (id != -1) {
        isLoading.value = false;
        if (!isAddMore.value) {
          Get.back();
          if (isUpdating.value) {
            successSnackBar("almirah_updated_success_msg".tr);
          } else {
            successSnackBar("almirah_success_msg".tr);
          }
        } else {
          nameController.clear();
          successSnackBar("almirah_success_msg".tr);
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
