import 'package:app/app/data/model.dart';
import 'package:app/app/modules/purchased_item/controllers/purchased_item_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ListPurchasedItemController extends GetxController {
  final searchController = TextEditingController();
  final purchasedItemController = Get.find<PurchasedItemController>();
  final isLoading = false.obs;
  final purchasedItemList = <PurchasedItem>[].obs;

  @override
  void onReady() {
    super.onReady();
    purchasedItemList.value =
        purchasedItemController.objectBoxController.purchasedItemBox.getAll();
  }
}
