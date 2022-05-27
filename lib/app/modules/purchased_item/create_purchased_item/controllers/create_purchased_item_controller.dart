import 'package:app/app/data/model.dart';
import 'package:app/app/modules/item_variant/controllers/item_variant_controller.dart';
import 'package:app/app/modules/supplier/controllers/supplier_controller.dart';
import 'package:app/app/modules/unit/controllers/unit_controller.dart';
import 'package:app/app/modules/unit/create_unit/controllers/create_unit_controller.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePurchasedItemController extends GetxController {
  final appBarText = "add_purchased_item".tr.obs;
  final isUpdating = false.obs;
  late PurchasedItem? updatingPurchasedItem;
  DateTime? purchasedDate;
  DateTime? expiryDate;
  List<StoreRoom> selectedStoreRooms = <StoreRoom>[];
  List<Godown> selectedGodowns = <Godown>[];
  List<Almirah> selectedAlmirahs = <Almirah>[].obs;
  final fullUnitController = TextEditingController();
  final shortUnitController = TextEditingController();
  final purchasingPriceController = TextEditingController();
  final purchasingPriceUnitController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final sellingPriceUnitController = TextEditingController();
  final purchasedQuantityController = TextEditingController();
  final purchasedQuantityUnitController = TextEditingController();
  final rowController = TextEditingController();
  final columnController = TextEditingController();
  final itemSearchController = TextEditingController();
  final supplierSearchController = TextEditingController();
  final purchasingPriceUnit = Unit().obs;
  final sellingPriceUnit = Unit().obs;
  final purchasedQuantityUnit = Unit().obs;
  final currentSupplier = Supplier().obs;
  final currentItem = ItemVariant().obs;
  final godowns = <Godown>[].obs;
  final storeRooms = <StoreRoom>[].obs;
  final almirahs = <Almirah>[].obs;
  final suppliers = <Supplier>[].obs;
  final items = <ItemVariant>[].obs;
  final units = <Unit>[].obs;
  final isLoading = false.obs;
  final isAddMore = false.obs;
  final objectBoxController = Get.find<ObjectBoxController>();
  final unitController = Get.put(UnitController());
  final itemController = Get.put(ItemVariantController());
  final supplierController = Get.put(SupplierController());
  final networkController = Get.find<NetworkController>();
  final createUnitController = Get.put(CreateUnitController());

  @override
  void onReady() {
    super.onReady();
    isUpdating.value = Get.arguments[0];
    items.value = objectBoxController.itemVariantBox.getAll();
    godowns.value = objectBoxController.godownBox.getAll();
    units.value = objectBoxController.unitBox.getAll();
    suppliers.value = objectBoxController.supplierBox.getAll();
    if (isUpdating.value) {
      appBarText.value = "update_purchased_item".tr;
      updatingPurchasedItem = Get.arguments[1];
      if (updatingPurchasedItem!.purchasingPriceUnit.target != null) {
        purchasingPriceUnit.value =
            updatingPurchasedItem!.purchasingPriceUnit.target!;
      }
      if (updatingPurchasedItem!.sellingPriceUnit.target != null) {
        sellingPriceUnit.value =
            updatingPurchasedItem!.sellingPriceUnit.target!;
      }
      if (updatingPurchasedItem!.purchasedQuantityUnit.target != null) {
        purchasedQuantityUnit.value =
            updatingPurchasedItem!.purchasedQuantityUnit.target!;
      }
      expiryDate = updatingPurchasedItem!.dateOfExpiry;
      purchasedDate = updatingPurchasedItem!.purchasedDate;

      if (updatingPurchasedItem!.purchasingPrice != null) {
        purchasingPriceController.text =
            updatingPurchasedItem!.purchasingPrice!.toString();
      }
      if (updatingPurchasedItem!.sellingPrice != null) {
        sellingPriceController.text =
            updatingPurchasedItem!.sellingPrice!.toString();
      }
      if (updatingPurchasedItem!.purchasedQuantity != null) {
        purchasedQuantityController.text =
            updatingPurchasedItem!.purchasedQuantity!.toString();
      }
    }
  }

  void addPurchasedItem() {
    try {
      final purchasedItem = PurchasedItem()
        ..purchasedDate = purchasedDate
        ..purchasedItem.targetId = currentItem.value.id
        ..purchasingPrice = double.parse(purchasingPriceController.text)
        ..purchasingPriceUnit.targetId = purchasingPriceUnit.value.id
        ..purchasedQuantity = double.parse(purchasedQuantityController.text)
        ..purchasedQuantityUnit.targetId = purchasedQuantityUnit.value.id
        ..currentQuantity = double.parse(purchasedQuantityController.text)
        ..currentQuantityUnit.targetId = purchasedQuantityUnit.value.id
        ..suppliedBy.targetId = currentSupplier.value.id
        ..almirah.addAll(selectedAlmirahs)
        ..dateOfExpiry = expiryDate
        ..sellingPrice = double.parse(sellingPriceController.text)
        ..sellingPriceUnit.targetId = sellingPriceUnit.value.id
        ..row = int.parse(rowController.text)
        ..column = int.parse(columnController.text)
        ..almirah.addAll(selectedAlmirahs);
      if (isUpdating.value) {
        purchasedItem.id = updatingPurchasedItem!.id!;
      }
      int id = objectBoxController.purchasedItemBox.put(purchasedItem);
      if (id != -1) {
        isLoading.value = false;
        if (!isAddMore.value) {
          Get.back();
          if (isUpdating.value) {
            successSnackBar("purchased_item_updated_success_msg".tr);
          } else {
            successSnackBar("purchased_item_success_msg".tr);
          }
        } else {
          purchasingPriceController.clear();
          purchasedQuantityController.clear();
          sellingPriceController.clear();
          successSnackBar("purchased_item_success_msg".tr);
        }
      } else {
        isLoading.value = false;
        errorSnackBar();
      }
    } on Exception {
      isLoading.value = false;
      errorSnackBar();
    }
  }

  fetchStoreRoom(int id) {
    storeRooms.value = objectBoxController.storeRoomBox
        .query(StoreRoom_.godown.equals(id))
        .build()
        .find();
  }

  fetchAlmirah(int id) {
    almirahs.value = objectBoxController.almirahBox
        .query(Almirah_.room.equals(id))
        .build()
        .find();
  }
}
