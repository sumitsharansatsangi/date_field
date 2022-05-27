import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:get/get.dart';
import '../../../../data/model.dart';

class CreatePurchaseOrderController extends GetxController {
  final appBarText = 'add_purchase_order'.tr.obs;
  final isUpdating = false.obs;
  PurchaseOrder? updatingPurchaseOrder;
  final isAddMore = false.obs;
  final objectBoxController = Get.find<ObjectBoxController>();
  final isLoading = false.obs;
  final currentSupplier = Supplier().obs;
  final suppliers = <Supplier>[].obs;
  final units = <Unit>[].obs;
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
    suppliers.value = objectBoxController.supplierBox.getAll();
  }

  addPurchaseOrder() {
    try {
      isLoading.value = true;
      final purchaseOrder = PurchaseOrder()
        ..supplier.targetId = currentSupplier.value.id;
      if (isUpdating.value) {
        purchaseOrder.id = updatingPurchaseOrder!.id!;
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
