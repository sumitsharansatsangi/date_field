import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../data/model.dart';

class CreatePurchaseOrderController extends GetxController {
  final appBarText = 'add_purchase_order'.tr.obs;
  final isUpdating = false.obs;
  PurchaseOrder? updatingPurchaseOrder;
  final currentPurchaseOrder = Rx<PurchaseOrder?>(null);
  final isAddMore = false.obs;
  final objectBoxController = Get.find<ObjectBoxController>();
  final isLoading = false.obs;
  final currentSupplier = Supplier().obs;
  final suppliers = <Supplier>[].obs;
  final units = <Unit>[].obs;
  final items = <ItemVariant>[].obs;
  final purchasedOrderedItems = <PurchaseOrderItem>[PurchaseOrderItem()].obs;
  final controllerList = <TextEditingController>[TextEditingController()].obs;
  @override
  void onInit() {
    super.onInit();
    isUpdating.value = Get.arguments[0];
  }

  @override
  void onReady() {
    super.onReady();
    if (isUpdating.value) {
      appBarText.value = 'update_purchase_order'.tr;
      updatingPurchaseOrder = Get.arguments[1];
      if (updatingPurchaseOrder!.supplier.target != null) {
        currentSupplier.value = updatingPurchaseOrder!.supplier.target!;
      }
      if (updatingPurchaseOrder!.orderedItems.isNotEmpty) {
        purchasedOrderedItems.value = updatingPurchaseOrder!.orderedItems;
      }
    }
    items.value = objectBoxController.itemVariantBox.getAll();
    units.value = objectBoxController.unitBox.getAll();
    suppliers.value = objectBoxController.supplierBox.getAll();
  }

  addPurchaseOrder() {
    try {
      isLoading.value = true;
      final purchaseOrder = PurchaseOrder()
        ..orderedItems.addAll(purchasedOrderedItems)
        ..supplier.targetId = currentSupplier.value.id;
      if (isUpdating.value) {
        purchaseOrder.id = updatingPurchaseOrder!.id!;
        purchaseOrder.dateOfUpdation = DateTime.now();
      } else {
        purchaseOrder.dateOfCreation = DateTime.now();
      }
      int id = objectBoxController.purchaseOrderBox.put(purchaseOrder);
      if (id != -1) {
        isLoading.value = false;
        if (!isAddMore.value) {
          Get.back();
          if (isUpdating.value) {
            successSnackBar("purchase_order_updated_success_msg".tr);
          } else {
            successSnackBar("purchase_order_success_msg".tr);
          }
        } else {
          successSnackBar("purchase_order_success_msg".tr);
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
