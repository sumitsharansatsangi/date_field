import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/outline_gradient_button.dart';
import 'package:app/objectbox.g.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/model.dart';

class ItemController extends GetxController {
  final searchController = TextEditingController();
  final isViewingVariant = false.obs;
  final searchedItemList = <SearchedItem>[].obs;
  final objectBoxController = Get.find<ObjectBoxController>();

  List<Item> searchItems(pattern) {
    final queryBuilder = objectBoxController.itemBox.query(Item_.name
        .startsWith(pattern, caseSensitive: false)
        .or(Item_.name.contains(pattern, caseSensitive: false)));
    queryBuilder.order(Item_.name);
    final query = queryBuilder.build();
    return query.find();
  }

  void addSearchedItem(Item item) {
    objectBoxController.searchedItemBox
        .put(SearchedItem()..searchedItem.target = item);
  }

  void deleteItem(int id) {
    final query = objectBoxController.searchedItemBox.query();
    query.link(SearchedItem_.searchedItem, Item_.id.equals(id));
    query.build().remove();
    objectBoxController.itemBox.remove(id);
  }

  void deleteSearchedItem(int id) {
    objectBoxController.searchedItemBox.remove(id);
  }

  @override
  void onReady() {
    super.onReady();
    fetchSearchedItem();
  }

  void fetchSearchedItem() {
    final searchedItemBuilder = objectBoxController.searchedItemBox.query()
      ..order(SearchedItem_.datetime, flags: Order.descending);
    searchedItemList.bindStream(searchedItemBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void fetchPurchasedItem(Item item) {
    final queryBuilder = objectBoxController.purchasedItemBox.query();
    queryBuilder.link(PurchasedItem_.purchasedItem, Item_.id.equals(item.id!));
    final query = queryBuilder.build();
    query.find();
  }

  void openBottomSheet(Item item) {
    Get.bottomSheet(
        ListView(
          children: [
            SizedBox(height: 20.h),
            BottomSheetRow(
              onDelete: () {
                deleteItem(item.id!);
                Get.back();
                fetchSearchedItem();
              },
            ),
            SizedBox(height: 10.h),
            Center(
              child: AutoSizeText(
                item.name ?? " ",
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
                      Heading("company".tr),
                      Content(item.company.target!.name ?? " "),
                    ]),
                    TableRow(children: [
                      Heading("category".tr),
                      Content(item.category.target!.name ?? " ")
                    ])
                  ],
                ),
              ),
            ),
            Center(
              child: OutlineGradientButton(
                onTap: () => isViewingVariant.toggle(),
                child: Text("view_item_variant".tr),
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
            Obx(() => isViewingVariant.value
                ? Center(
                    child: item.variant.isNotEmpty
                        ? Column(
                            children: [
                              for (final record in item.variant)
                                ListTile(
                                  title: Row(
                                    children: [
                                      Column(
                                        children: [
                                          AutoSizeText("Model"),
                                          AutoSizeText(record.model ?? " "),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          AutoSizeText("Size"),
                                          AutoSizeText(record.size ?? " "),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          AutoSizeText("Color"),
                                          AutoSizeText(record.color ?? " "),
                                        ],
                                      ),
                                    ],
                                  ),
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
