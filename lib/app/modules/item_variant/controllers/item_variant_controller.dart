import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/outline_gradient_button.dart';
import 'package:app/objectbox.g.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/model.dart';

class ItemVariantController extends GetxController {
  final searchController = TextEditingController();
  final isViewingPurchase = false.obs;
  final searchedItemVariantList = <SearchedItemVariant>[].obs;
  final objectBoxController = Get.find<ObjectBoxController>();

  List<ItemVariant> searchItemVariants(pattern) {
    final queryBuilder = objectBoxController.itemVariantBox.query();
    queryBuilder.link(
        ItemVariant_.item,
        Item_.name
            .startsWith(pattern, caseSensitive: false)
            .or(Item_.name.contains(pattern, caseSensitive: false)));
    final query = queryBuilder.build();
    List<ItemVariant> itemVariants = query.find();
    itemVariants
        .sort((a, b) => a.item.target!.name!.compareTo(b.item.target!.name!));
    return itemVariants;
  }

  void addSearchedItemVariant(ItemVariant itemVariant) {
    objectBoxController.searchedItemVariantBox
        .put(SearchedItemVariant()..searchedItemVariant.target = itemVariant);
  }

  void deleteItemVariant(int id) {
    final query = objectBoxController.searchedItemVariantBox.query();
    query.link(
        SearchedItemVariant_.searchedItemVariant, ItemVariant_.id.equals(id));
    query.build().remove();
    objectBoxController.itemVariantBox.remove(id);
  }

  void deleteSearchedItemVariant(int id) {
    objectBoxController.searchedItemVariantBox.remove(id);
  }

  @override
  void onReady() {
    super.onReady();
    fetchSearchedItemVariant();
  }

  void fetchSearchedItemVariant() {
    final searchedItemVariantBuilder =
        objectBoxController.searchedItemVariantBox.query()
          ..order(SearchedItemVariant_.datetime, flags: Order.descending);
    searchedItemVariantList.bindStream(searchedItemVariantBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void fetchPurchasedRecord(Item item) {
    final queryBuilder = objectBoxController.purchasedItemBox.query();
    queryBuilder.link(PurchasedItem_.purchasedItem, Item_.id.equals(item.id!));
    final query = queryBuilder.build();
    query.find();
  }

  void openBottomSheet(ItemVariant itemVariant) {
    Get.bottomSheet(
        ListView(
          children: [
            SizedBox(height: 20.h),
            BottomSheetRow(
              onDelete: () {
                deleteItemVariant(itemVariant.id!);
                Get.back();
                fetchSearchedItemVariant();
              },
            ),
            SizedBox(height: 10.h),
            Center(
              child: AutoSizeText(
                itemVariant.item.target!.name ?? " ",
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
                      Heading("model".tr),
                      Content(itemVariant.model ?? " "),
                    ]),
                    TableRow(children: [
                      Heading("size".tr),
                      Content(itemVariant.size ?? " "),
                    ]),
                    TableRow(children: [
                      Heading("color".tr),
                      Content(itemVariant.color ?? " "),
                    ]),
                    TableRow(children: [
                      Heading("company".tr),
                      Content(
                          itemVariant.item.target!.company.target!.name ?? " "),
                    ]),
                    TableRow(children: [
                      Heading("item_category".tr),
                      Content(
                          itemVariant.item.target!.category.target!.name ?? " ")
                    ])
                  ],
                ),
              ),
            ),
            Center(
              child: OutlineGradientButton(
                onTap: () => isViewingPurchase.toggle(),
                child: Text("view_purchased_item_n".tr),
                gradient: LinearGradient(
                  stops: [0, 0.5, 0.5, 1],
                  colors: [
                    Color.fromARGB(255, 119, 76, 175),
                    Color.fromARGB(255, 135, 76, 175),
                    Color.fromARGB(255, 200, 54, 244),
                    Color.fromARGB(255, 190, 54, 244)
                  ],
                ),
                strokeWidth: 4,
                corners: Corners(
                    topLeft: Radius.elliptical(16, 14),
                    bottomRight: Radius.circular(6)),
              ),
            ),
            Obx(() => isViewingPurchase.value
                ? Center(
                    child: itemVariant.purchasedRecord.isNotEmpty
                        ? Column(
                            children: [
                              for (final record in itemVariant.purchasedRecord)
                                ListTile(
                                  title: AutoSizeText(
                                      DateFormat('yyyy-MM-dd kk:mm:a').format(
                                          record.purchasedDate ??
                                              DateTime.now())),
                                  subtitle: AutoSizeText(
                                      record.suppliedBy.target!.name ?? " "),
                                  trailing: Text(
                                      record.currentQuantity.toString() +
                                          record.currentQuantityUnit.target!
                                              .shortName!),
                                )
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child:
                                AutoSizeText("no_purchased_item_available".tr),
                          ))
                : SizedBox())
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
