import 'package:app/app/data/model.dart';
import 'package:app/app/modules/unit/controllers/unit_controller.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ListUnitController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final isLoading = false.obs;
  final unitList = <Unit>[].obs;
  final searchedUnitList = <Unit>[].obs;
  final selectedIndex = 0.obs;
  final unitController = Get.find<UnitController>();

  @override
  void onReady() {
    super.onReady();
    unitList.value = objectBoxController.unitBox.getAll();
  }
}
