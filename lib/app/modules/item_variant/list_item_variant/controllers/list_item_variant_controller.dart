import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/item_variant_controller.dart';

class ListItemVariantController extends GetxController {
  final searchController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final itemController = Get.find<ItemVariantController>();
  final isLoading = false.obs;
  final itemList = <ItemVariant>[].obs;

  @override
  void onReady() {
    super.onReady();
    itemList.value = objectBoxController.itemVariantBox.getAll();
  }
}
