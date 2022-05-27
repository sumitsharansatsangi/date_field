import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGodownController extends GetxController {
  final appBarText = 'add_godown'.tr.obs;
  final isUpdating = false.obs;
  Godown? updatingGodown;
  final nameController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final isLoading = false.obs;
  final isAddMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    isUpdating.value = Get.arguments[0];
  }

  @override
  void onReady() {
    super.onReady();
    if (isUpdating.value) {
      appBarText.value = 'update_godown'.tr;
      updatingGodown = Get.arguments[1];
      if (updatingGodown!.name != null) {
        nameController.text = updatingGodown!.name ?? " ";
      }
    }
  }

  addGodown() {
    try {
      isLoading.value = true;
      final godown = Godown()..name = nameController.text.trim().capitalize;
      print(godown.name);
      if (isUpdating.value) {
        godown.id = updatingGodown!.id;
      }
      int id = objectBoxController.godownBox.put(godown);
      if (id != -1) {
        isLoading.value = false;
        if (!isAddMore.value) {
          Get.back();
          if (isUpdating.value) {
            successSnackBar("godown_updated_success_msg".tr);
          } else {
            successSnackBar("godown_success_msg".tr);
          }
        } else {
          nameController.clear();
          successSnackBar("godown_success_msg".tr);
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
