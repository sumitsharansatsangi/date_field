import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../data/model.dart';
import '../../../item_category/controllers/item_category_controller.dart';
import '../../../company/controllers/company_controller.dart';
import '../../../unit/controllers/unit_controller.dart';

class CreateItemController extends GetxController {
  final appBarText = 'add_item'.tr.obs;
  final isDisplay = false.obs;
  final isUpdating = false.obs;
  Item? updatingItem;
  final itemNameController = TextEditingController();
  final alternateNameList =
      <TextEditingController>[TextEditingController()].obs;
  final descriptionController = TextEditingController();
  final companyNameController = TextEditingController();
  final categoryNameController = TextEditingController();
  final minimumStockController = TextEditingController();
  final minimumStockUnitController = TextEditingController();
  final minimumStockUnit = Unit().obs;
  final currentCompany = Company().obs;
  final currentCategory = ItemCategory().obs;
  final isLoading = false.obs;
  final isAddMore = false.obs;
  final companies = <Company>[].obs;
  final itemCategories = <ItemCategory>[].obs;
  final unitController = Get.put(UnitController());
  final categoryController = Get.put(ItemCategoryController());
  final companyController = Get.put(CompanyController());
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
      appBarText.value = 'update_item'.tr;
      updatingItem = Get.arguments[1];
      if (updatingItem!.category.target != null) {
        currentCategory.value = updatingItem!.category.target!;
      }
      if (updatingItem!.company.target != null) {
        currentCompany.value = updatingItem!.company.target!;
      }
      if (updatingItem!.name != null) {
        itemNameController.text = updatingItem!.name!;
      }
      if (updatingItem!.description != null) {
        descriptionController.text = updatingItem!.description!;
      }
    }
    itemCategories.value = objectBoxController.itemCategoryBox.getAll();
    companies.value = objectBoxController.companyBox.getAll();
  }

  addItem() {
    try {
      isLoading.value = true;
      final item = Item()
        ..name = itemNameController.text
        ..alternateName =
            alternateNameList.map((element) => element.text).toList()
        ..description = descriptionController.text.trim()
        ..category.targetId = currentCategory.value.id
        ..company.targetId = currentCompany.value.id;
      if (isUpdating.value) {
        item.id = updatingItem!.id;
      }
      int id = objectBoxController.itemBox.put(item);
      if (id != -1) {
        isLoading.value = false;
        if (!isAddMore.value) {
          Get.back();
          if (isUpdating.value) {
            successSnackBar("item_updated_success_msg".tr);
          } else {
            successSnackBar("item_success_msg".tr);
          }
        } else {
          itemNameController.clear();
          descriptionController.clear();
          companyNameController.clear();
          categoryNameController.clear();
          alternateNameList.value = [TextEditingController()];
          successSnackBar("item_success_msg".tr);
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
