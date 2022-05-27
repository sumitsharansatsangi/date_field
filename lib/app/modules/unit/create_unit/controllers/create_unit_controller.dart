import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CreateUnitController extends GetxController {
  final chosenUnitValue = "".obs;
  final chosenUnit = Unit().obs;
  final appBarText = 'add_unit'.tr.obs;
  final isUpdating = false.obs;
  Unit? updatingUnit;
  final isAddMore = false.obs;
  final fullUnitController = TextEditingController();
  final shortUnitController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final isLoading = false.obs;
  final conversionList = <UnitRelation>[].obs;
  final conversionTextList = <TextEditingController>[].obs;
  final conversionHintList = <RxString>[].obs;
  final unitList = <Unit>[].obs;
  final currentConversionUnit = Unit().obs;
  final isConversion = false.obs;
  final fullname = "".obs;

  addUnit() {
    try {
      isLoading.value = true;
      final unit = Unit()
        ..fullName = fullUnitController.text.trim().capitalizeFirst
        ..shortName = shortUnitController.text.trim();
      if (isUpdating.value) {
        unit.id = updatingUnit!.id!;
      }
      int id = objectBoxController.unitBox.put(unit);
      if (isConversion.value && unitList.isNotEmpty) {
        for (int i = 0; i < conversionTextList.length; i++) {
          conversionList.add(UnitRelation()
            ..value = double.parse(conversionTextList[i].text)
            ..unitFrom.targetId = id
            ..unitTo.targetId = currentConversionUnit.value.id);
        }
        objectBoxController.unitRelationBox.putMany(conversionList);
      }
      if (id != -1) {
        isLoading.value = false;
        if (!isAddMore.value) {
          fullUnitController.clear();
          shortUnitController.clear();
          Get.back(result: true);
          if (isUpdating.value) {
            successSnackBar("unit_updated_success_msg".tr);
          } else {
            successSnackBar("unit_success_msg".tr);
          }
        } else {
          fullUnitController.clear();
          shortUnitController.clear();
          successSnackBar("unit_success_msg".tr);
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

  @override
  void onInit() {
    super.onInit();
    isUpdating.value = Get.arguments[0];
    fullUnitController.addListener(() {
      fullname.value = fullUnitController.text;
    });
  }

  @override
  void onReady() {
    super.onReady();
    if (isUpdating.value) {
      appBarText.value = 'update_unit'.tr;
      updatingUnit = Get.arguments[1];
      fullUnitController.text = updatingUnit!.fullName!;
      shortUnitController.text = updatingUnit!.shortName!;
      final query = objectBoxController.unitRelationBox.query();
      query.link(UnitRelation_.unitFrom, Unit_.id.equals(updatingUnit!.id!));
      conversionList.assignAll(query.build().find());
      if (conversionList.isNotEmpty) {
        isConversion.value = true;
      }
      for (var i = 0; i < conversionList.length; i++) {
        conversionTextList.add(
            TextEditingController()..text = conversionList[i].value.toString());
      }
      for (final unitRelation in conversionList) {
        conversionHintList.add(
            "1 ${unitRelation.unitFrom.target!.fullName} = ${unitRelation.value} ${unitRelation.unitTo.target!.fullName}"
                .obs);
      }
    }
    unitList.value = objectBoxController.unitBox.getAll();
    if (unitList.isNotEmpty) {
      currentConversionUnit.value = unitList[0];
    }
  }
}
