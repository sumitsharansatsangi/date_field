import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../data/model.dart';

class CreateCompanyController extends GetxController {
  final appBarText = 'add_company'.tr.obs;
  final isUpdating = false.obs;
  Company? updatingCompany;
  final isAddMore = false.obs;
  final companyNameController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isUpdating.value = Get.arguments[0];
  }

  @override
  void onReady() {
    super.onReady();
    if (isUpdating.value) {
      appBarText.value = 'update_company'.tr;
      updatingCompany = Get.arguments[1];
      if (updatingCompany!.name != null) {
        companyNameController.text = updatingCompany!.name ?? " ";
      }
    }
  }

  addCompany() {
    try {
      isLoading.value = true;
      final company = Company()
        ..name = companyNameController.text.trim().capitalizeFirst;
      if (isUpdating.value) {
        company.id = updatingCompany!.id!;
      }
      int id = objectBoxController.companyBox.put(company);
      if (id != -1) {
        isLoading.value = false;
        if (!isAddMore.value) {
          Get.back();
          if (isUpdating.value) {
            successSnackBar("company_updated_success_msg".tr);
          } else {
            successSnackBar("company_success_msg".tr);
          }
        } else {
          companyNameController.clear();
          successSnackBar("company_success_msg".tr);
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
