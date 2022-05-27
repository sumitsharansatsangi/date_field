import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../data/model.dart';
import '../../../item/controllers/item_controller.dart';
import '../../../unit/controllers/unit_controller.dart';

class CreateItemVariantController extends GetxController {
  final appBarText = 'add_item_variant'.tr.obs;
  final isDisplay = false.obs;
  final isUpdating = false.obs;
  ItemVariant? updatingItem;
  final itemNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final colorController = TextEditingController();
  final sizeController = TextEditingController();
  final modelController = TextEditingController();
  final minimumStockController = TextEditingController();
  final minimumStockUnitController = TextEditingController();
  final minimumStockUnit = Unit().obs;
  final units = <Unit>[].obs;
  final items = <Item>[].obs;
  final currentItem = Item().obs;
  final isLoading = false.obs;
  final isAddMore = false.obs;
  final itemController = Get.put(ItemController());
  final unitController = Get.put(UnitController());
  final objectBoxController = Get.find<ObjectBoxController>();

  @override
  void onInit() {
    super.onInit();
    isUpdating.value = Get.arguments[0];
  }

  @override
  void onReady() {
    super.onReady();
    if (isUpdating.value) {
      appBarText.value = 'update_item_variant'.tr;
      updatingItem = Get.arguments[1];
      if (updatingItem!.description != null) {
        descriptionController.text = updatingItem!.description!;
      }
      if (updatingItem!.size != null) {
        sizeController.text = updatingItem!.size!;
      }
      if (updatingItem!.model != null) {
        modelController.text = updatingItem!.model!;
      }
      if (updatingItem!.color != null) {
        colorController.text = updatingItem!.color!;
      }
      if (updatingItem!.minimumStock != null) {
        minimumStockController.text = updatingItem!.minimumStock!.toString();
      }
      if (updatingItem!.minimumStockUnit.target != null) {
        minimumStockUnit.value = updatingItem!.minimumStockUnit.target!;
      }
    }
    units.value = objectBoxController.unitBox.getAll();
    items.value = objectBoxController.itemBox.getAll();
  }

  addItem() {
    try {
      isLoading.value = true;
      final item = ItemVariant()
        ..description = descriptionController.text.trim()
        ..color = colorController.text.trim()
        ..model = modelController.text.trim()
        ..size = sizeController.text.trim()
        ..item.targetId = currentItem.value.id
        ..minimumStock = double.parse(minimumStockController.text)
        ..minimumStockUnit.targetId = minimumStockUnit.value.id;
      if (isUpdating.value) {
        item.id = updatingItem!.id;
      }
      int id = objectBoxController.itemVariantBox.put(item);
      if (id != -1) {
        isLoading.value = false;

        if (!isAddMore.value) {
          Get.back();
          if (isUpdating.value) {
            successSnackBar("item_variant_updated_success_msg".tr);
          } else {
            successSnackBar("item_variant_success_msg".tr);
          }
        } else {
          itemNameController.clear();
          descriptionController.clear();
          colorController.clear();
          sizeController.clear();
          modelController.clear();
          successSnackBar("item_variant_success_msg".tr);
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
