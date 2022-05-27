import 'package:app/app/data/model.dart';
import 'package:app/app/modules/purchase_order/controllers/purchase_order_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ListPurchaseOrderController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final purchaseOrderController = Get.find<PurchaseOrderController>();
  final purchaseOrderList = <PurchaseOrder>[].obs;

  @override
  void onReady() {
    super.onReady();
    purchaseOrderList.value =
        purchaseOrderController.objectBoxController.purchaseOrderBox.getAll();
  }
}
