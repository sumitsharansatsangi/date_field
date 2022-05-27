import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceiptController extends GetxController {
  final objectBoxController = Get.find<ObjectBoxController>();
  TextEditingController searchController = TextEditingController();
  final searchedReceiptList = <Receipt>[].obs;
  Future<int> addReceipt(Receipt receipt) async {
    int receiptId = -1;
    try {
      receiptId = objectBoxController.receiptBox.put(receipt);
      return receiptId;
    } catch (e) {
      return receiptId;
    }
  }

  List<Receipt> fetchReceipts() {
    List<Receipt> receipts = [];
    objectBoxController.receiptBox.getAll();
    return receipts;
  }

  List<Receipt> searchReceiptWithCustomerName(String pattern) {
    List<Receipt> receipts = <Receipt>[];
    final ordersQuery = objectBoxController.receiptBox.query();
    ordersQuery.link(
        Receipt_.customer,
        Customer_.name
            .startsWith(pattern, caseSensitive: false)
            .or(Customer_.name.contains(pattern, caseSensitive: false)));
    Query<Receipt> rsp = ordersQuery.build();
    receipts = rsp.find();
    return receipts;
  }

  List<Receipt> searchReceiptWithDate(DateTimeRange dateRange) {
    List<Receipt> receipts = [];
    final ordersQuery = objectBoxController.receiptBox.query();
    ordersQuery.link(
        Receipt_.receiptInfo,
        ReceiptInfo_.dateOfCreation.between(
            dateRange.start.millisecondsSinceEpoch,
            dateRange.end.millisecondsSinceEpoch));
    Query<Receipt> rsp = ordersQuery.build();
    receipts = rsp.find();
    return receipts;
  }

  void deleteReceipt(int id) {
    objectBoxController.receiptBox.remove(id);
  }

  int addSearchedReceipt(Receipt receipt) {
    int searchedReceiptId = -1;
    try {
      SearchedReceipt searchedReceipt = SearchedReceipt()
        ..searchedReceipt.target = receipt
        ..datetime = DateTime.now();
      objectBoxController.searchedReceiptBox.put(searchedReceipt);

      return searchedReceiptId;
    } catch (e) {
      return searchedReceiptId;
    }
  }

  List<SearchedReceipt> fetchSearchedReceipt() {
    List<SearchedReceipt> searchedReceipts =
        objectBoxController.searchedReceiptBox.getAll();
    return searchedReceipts;
  }

  void deleteSearchedReceipt(int id) {
    objectBoxController.searchedReceiptBox.remove(id);
  }
}
