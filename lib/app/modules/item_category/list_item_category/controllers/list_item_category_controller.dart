import 'package:app/app/data/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/item_category_controller.dart';

class ListItemCategoryController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final itemCategoryController = Get.find<ItemCategoryController>();
  final isLoading = false.obs;
  final categoryList = <ItemCategory>[].obs;
  final selectedIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
    categoryList.value =
        itemCategoryController.objectBoxController.itemCategoryBox.getAll();
  }
}
