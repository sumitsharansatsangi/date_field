import 'package:app/app/data/model.dart';
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
  final purchasedDate = Rx<DateTime?>(null);
  final expiryDate = Rx<DateTime?>(null);
  final selectedStoreRooms = <StoredAtStoreRoom>{}.obs;
  final selectedGodowns = <StoredAtGodown>{}.obs;
  final selectedAlmirahs = <StoredAtAlmirah>{}.obs;
  final fullUnitController = TextEditingController();
  final shortUnitController = TextEditingController();
  final purchasingPriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final purchasedQuantityController = TextEditingController();
  final rowController = TextEditingController();
  final columnController = TextEditingController();
  final itemSearchController = TextEditingController();
  final supplierSearchController = TextEditingController();
  final purchasingPriceUnit = Rx<Unit?>(null);
  final sellingPriceUnit = Rx<Unit?>(null);
  final purchasedQuantityUnit = Rx<Unit?>(null);
  final currentSupplier = Rx<Supplier?>(null);
  final currentItem = Rx<ItemVariant?>(null);
  final godowns = <Godown>[].obs;
  final storeRooms = <StoreRoom>[].obs;
  final almirahs = <Almirah>[].obs;
  final suppliers = <Supplier>[].obs;
  final items = <ItemVariant>[].obs;
  final units = <Unit>[].obs;
  final isLoading = false.obs;
  final isAddMore = false.obs;
  final objectBoxController = Get.find<ObjectBoxController>();
  final networkController = Get.find<NetworkController>();

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
      expiryDate.value = updatingPurchasedItem!.dateOfExpiry;
      purchasedDate.value = updatingPurchasedItem!.purchasedDate;
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
      if (updatingPurchasedItem!.purchasedItem.target != null) {
        currentItem.value = updatingPurchasedItem!.purchasedItem.target;
      }
      if (updatingPurchasedItem!.storedAtGodown.isNotEmpty) {
        selectedGodowns.addAll(updatingPurchasedItem!.storedAtGodown);
      } else if (updatingPurchasedItem!.storedAtStoreRoom.isNotEmpty) {
        for (final storeRoom in updatingPurchasedItem!.storedAtStoreRoom) {
          selectedGodowns.add(StoredAtGodown()
            ..godown.target = storeRoom.storeRoom.target!.godown.target!);
        }
        selectedStoreRooms.addAll(updatingPurchasedItem!.storedAtStoreRoom);
      } else if (updatingPurchasedItem!.storedAtAlmirah.isNotEmpty) {
        for (final almirah in updatingPurchasedItem!.storedAtAlmirah) {
          if (almirah.almirah.target!.godown.target != null) {
            selectedGodowns.add(StoredAtGodown()
              ..godown.target = almirah.almirah.target!.godown.target);
          } else {
            selectedGodowns.add(StoredAtGodown()
              ..godown.target =
                  almirah.almirah.target!.room.target!.godown.target);
          }
          selectedStoreRooms.add(StoredAtStoreRoom()
            ..storeRoom.target = almirah.almirah.target!.room.target);
        }
        selectedAlmirahs.addAll(updatingPurchasedItem!.storedAtAlmirah);
      }
      if (updatingPurchasedItem!.suppliedBy.target != null) {
        currentSupplier.value = updatingPurchasedItem!.suppliedBy.target;
      }
    }
  }

  void addPurchasedItem() {
    try {
      final purchasedItem = PurchasedItem()
        ..purchasedDate = purchasedDate.value ?? DateTime.now()
        ..purchasedItem.targetId = currentItem.value!.id
        ..purchasingPrice = double.parse(purchasingPriceController.text)
        ..purchasingPriceUnit.targetId = purchasingPriceUnit.value!.id
        ..purchasedQuantity = double.parse(purchasedQuantityController.text)
        ..purchasedQuantityUnit.targetId = purchasedQuantityUnit.value!.id
        ..currentQuantity = double.parse(purchasedQuantityController.text)
        ..currentQuantityUnit.targetId = purchasedQuantityUnit.value!.id
        ..suppliedBy.targetId = currentSupplier.value!.id
        ..dateOfExpiry = expiryDate.value
        ..sellingPrice = double.parse(sellingPriceController.text)
        ..sellingPriceUnit.targetId = sellingPriceUnit.value!.id;
      if (selectedAlmirahs.isNotEmpty) {
        purchasedItem.storedAtAlmirah.addAll(selectedAlmirahs);
      } else if (selectedStoreRooms.isNotEmpty) {
        purchasedItem.storedAtStoreRoom.addAll(selectedStoreRooms);
      } else if (selectedGodowns.isNotEmpty) {
        purchasedItem.storedAtGodown.addAll(selectedGodowns);
      }
      if (isUpdating.value) {
        purchasedItem.dateOfUpdation = DateTime.now();
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
    } on Exception catch (e) {
      print(e);
      isLoading.value = false;
      errorSnackBar();
      print(e);
    }
  }

  fetchStoreRoom(List<int> ids) {
    for (final id in ids) {
      storeRooms.addAll(objectBoxController.storeRoomBox
          .query(StoreRoom_.godown.equals(id))
          .build()
          .find());
    }
  }

  fetchAlmirah(List<int> ids) {
    for (final id in ids) {
      almirahs.addAll(objectBoxController.almirahBox
          .query(Almirah_.room.equals(id))
          .build()
          .find());
    }
  }
}
