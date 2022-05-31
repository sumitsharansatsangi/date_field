import 'package:app/app/data/model.dart';
import 'package:app/app/modules/customer/controllers/customer_controller.dart';
import 'package:app/app/modules/purchased_item/controllers/purchased_item_controller.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final isHindi = false.obs;
  final display = true.obs;
  final isCustomerEditing = true.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final quantityUnit = Rx<Unit?>(null);
  final receiptItemList = <ReceiptItem>[].obs;
  final productItemList = <PurchasedItem>[].obs;
  final quantityController = TextEditingController();
  final soldPriceController = TextEditingController();
  final currentCustomer = Rx<Customer?>(null);
  final currentItem = Rx<PurchasedItem?>(null);
  final receipt = Receipt().obs;
  final totalDiscount = 0.0.obs;
  final total = 0.0.obs;
  final translateController = TextEditingController();
  final textTranslateController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final itemList = <PurchasedItem>[].obs;
  final quantityList = <Unit>[].obs;
  final unitList = <Unit>[].obs;
  final customerList = <Customer>[].obs;
  final purchasedItemController = Get.put(PurchasedItemController());
  final customerController = Get.put(CustomerController());

  addToReceipt() {
    quantityList.add(quantityUnit.value!);
    receiptItemList.add(ReceiptItem()
      ..item.target = currentItem.value
      ..quantity = (num.tryParse(quantityController.text)?.toDouble())!
      ..unit.targetId = quantityUnit.value!.id
      ..soldPrice = double.parse(soldPriceController.text));
    receiptItemList.refresh();
    total.value += (num.tryParse(soldPriceController.text)?.toDouble())! *
        (num.tryParse(quantityController.text)?.toDouble())!;
  }

  @override
  void onReady() async {
    super.onReady();
    unitList.value = objectBoxController.unitBox.getAll();
    customerList.value = objectBoxController.customerBox.getAll();
    itemList.value = objectBoxController.purchasedItemBox.getAll();
    if (unitList.isNotEmpty) {
      quantityUnit.value = unitList.first;
    }
  }

  addReceipt() {
    try {
      isLoading.value = true;
      final receiptInfo = ReceiptInfo()
        ..description =
            "All items can be returned only with 10% price deduction. \n"
        ..due = 0.0
        ..dueDate = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 6)
        ..dateOfCreation = DateTime.now()
        ..totalDiscount = totalDiscount.value
        ..number = DateFormat("yyyyMMddHms").format(DateTime.now());
      final receipt = Receipt()
        ..customer.target = currentCustomer.value
        ..receiptItems.assignAll(receiptItemList)
        ..receiptInfo.target = receiptInfo;
      int id = objectBoxController.receiptBox.put(receipt);
      if (id != -1) {
        isLoading.value = false;
        receiptItemList.value = <ReceiptItem>[];
        currentCustomer.value = Customer();
        quantityController.clear();
        soldPriceController.clear();
        Get.snackbar("success".tr, "receipt_success_msg".tr,
            backgroundColor: Colors.green);
        return receipt;
      } else {
        isLoading.value = false;
        Get.snackbar("alert".tr, "already_exist_msg".tr,
            backgroundColor: Color.fromARGB(255, 12, 15, 209),
            colorText: Colors.white);
        return receipt;
      }
    } on Exception {
      Get.snackbar('error'.tr, 'error_msg'.tr, backgroundColor: Colors.red);
    }
  }

  updateItems() {
    objectBoxController.purchasedItemBox.putMany(receiptItemList.map((element) {
      PurchasedItem item = element.item.target!;
      item.currentQuantity = item.currentQuantity! - 100;
      return item;
    }).toList());
  }
}
