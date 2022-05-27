import 'package:app/app/data/model.dart';
import 'package:app/app/modules/item/controllers/item_controller.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ListItemController extends GetxController {
  final searchController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final itemController = Get.find<ItemController>();
  final isLoading = false.obs;
  final itemList = <Item>[].obs;

  @override
  void onReady() {
    super.onReady();
    itemList.value = objectBoxController.itemBox.getAll();
  }
}
