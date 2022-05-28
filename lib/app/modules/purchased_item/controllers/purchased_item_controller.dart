import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PurchasedItemController extends GetxController {
  final objectBoxController = Get.find<ObjectBoxController>();
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final searchedPurchasedItemList = <SearchedPurchasedItem>[].obs;

  List<PurchasedItem> searchPurchasedItems(pattern) {
    final queryBuilder = objectBoxController.purchasedItemBox.query();
    queryBuilder
        .link(
          PurchasedItem_.purchasedItem,
        )
        .link(ItemVariant_.item,
            Item_.name.startsWith(pattern, caseSensitive: false));
    final query = queryBuilder.build();
    List<PurchasedItem> purchasedItems = query.find();
    purchasedItems.sort((a, b) => a.purchasedItem.target!.item.target!.name!
        .compareTo(b.purchasedItem.target!.item.target!.name!));
    return purchasedItems;
  }

  void addSearchedPurchasedItem(PurchasedItem item) {
    objectBoxController.searchedPurchasedItemBox
        .put(SearchedPurchasedItem()..searchedPurchasedItem.target = item);
  }

  void deletePurchasedItem(int id) {
    final query = objectBoxController.searchedPurchasedItemBox.query();
    query.link(SearchedPurchasedItem_.searchedPurchasedItem,
        PurchasedItem_.id.equals(id));
    query.build().remove();
    objectBoxController.purchasedItemBox.remove(id);
  }

  void deleteSearchedPurchasedItem(int id) {
    objectBoxController.searchedPurchasedItemBox.remove(id);
  }

  @override
  void onReady() {
    super.onReady();
    fetchSearchedPurchasedItem();
  }

  fetchSearchedPurchasedItem() {
    final searchedItemBuilder = objectBoxController.searchedPurchasedItemBox
        .query()
      ..order(SearchedPurchasedItem_.datetime, flags: Order.descending);
    searchedPurchasedItemList.bindStream(searchedItemBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void openBottomSheet(PurchasedItem purchasedItem) {
    final DateTime dateTime = purchasedItem.purchasedDate!;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(dateTime);
    Get.bottomSheet(
        ListView(
          children: [
            SizedBox(height: 20.h),
            BottomSheetRow(
              onDelete: () {
                deletePurchasedItem(purchasedItem.id!);
                Get.back();
                fetchSearchedPurchasedItem();
              },
            ),
            SizedBox(height: 10.h),
            Center(
              child: AutoSizeText(
                purchasedItem.purchasedItem.target!.item.target!.name ?? " ",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15.h),
            Center(
              child: Padding(
                padding: EdgeInsets.all(3.r),
                child: Table(
                  border: TableBorder.all(color: Colors.deepPurple.shade200),
                  children: [
                    TableRow(children: [
                      Heading("purchasing_date".tr),
                      Content(formattedDate),
                    ]),
                    TableRow(children: [
                      Heading("supplier_name".tr),
                      Content(purchasedItem.suppliedBy.target!.name ?? " "),
                    ]),
                    TableRow(children: [
                      Heading("purchased_quantity".tr),
                      Content(
                          "${purchasedItem.purchasedQuantity} ${purchasedItem.purchasedQuantityUnit.target!.fullName ?? " "}"),
                    ]),
                    TableRow(children: [
                      Heading("current_quantity".tr),
                      Content(
                          "${purchasedItem.currentQuantity} ${purchasedItem.currentQuantityUnit.target!.fullName ?? " "}"),
                    ]),
                    TableRow(children: [
                      Heading("purchasing_price".tr),
                      Content(
                          "${purchasedItem.purchasingPrice} / ${purchasedItem.purchasingPriceUnit.target!.fullName ?? " "}"),
                    ]),
                    TableRow(children: [
                      Heading("selling_price".tr),
                      Content(
                          "${purchasedItem.sellingPrice} / ${purchasedItem.sellingPriceUnit.target!.fullName ?? " "}")
                    ])
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 234, 232, 238),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        ignoreSafeArea: false);
  }
}
