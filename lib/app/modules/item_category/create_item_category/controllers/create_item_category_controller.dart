import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateItemCategoryController extends GetxController {
  final appBarText = "add_item_category".tr.obs;
  final isUpdating = false.obs;
  ItemCategory? updatingCategory;
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
      appBarText.value = 'update_item_category'.tr;
      updatingCategory = Get.arguments[1];
      if (updatingCategory!.name != null) {
        nameController.text = updatingCategory!.name ?? " ";
      }
    }
  }

  addCategory() {
    try {
      isLoading.value = true;
      final category = ItemCategory()..name = nameController.text;
      if (isUpdating.value) {
        category.id = updatingCategory!.id!;
      }
      int id = objectBoxController.itemCategoryBox.put(category);
      if (id != -1) {
        isLoading.value = false;
        if (!isAddMore.value) {
          Get.back();
          if (isUpdating.value) {
            successSnackBar("item_category_updated_success_msg".tr);
          } else {
            successSnackBar("item_category_success_msg".tr);
          }
        } else {
          nameController.clear();
          successSnackBar("item_category_success_msg".tr);
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
