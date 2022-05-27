import 'package:app/app/data/model.dart';
import 'package:app/app/modules/godown/controllers/godown_controller.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListGodownController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final godownController = Get.put(GodownController());
  final isLoading = false.obs;
  final godownList = <Godown>[].obs;
  final selectedIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
    godownList.value = objectBoxController.godownBox.getAll();
  }
}
