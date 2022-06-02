import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';

import '../controllers/purchased_item_controller.dart';

class PurchasedItemView extends GetView<PurchasedItemController> {
  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize * 1.5,
        child: SafeArea(
            child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomBack(),
              SearchField(
                controller: c.searchController,
                hint: "search_purchased_item_here".tr,
                isDeviceConnected: networkController.connectionStatus.value,
                itemBuilder: (context, PurchasedItem suggestion) {
                  return ListTile(
                      title: AutoSizeText(
                          suggestion.purchasedItem.target!.item.target!.name ??
                              "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 13.sp)),
                      subtitle: suggestion.purchasedItem.target!.item.target!
                                  .alternateName !=
                              null
                          ? Wrap(
                              children: [
                                for (final name in suggestion.purchasedItem
                                    .target!.item.target!.alternateName!)
                                  AutoSizeText(name,
                                      stepGranularity: 1.sp,
                                      minFontSize: 8.sp,
                                      style: TextStyle(fontSize: 10.sp))
                              ],
                              spacing: 2.w,
                            )
                          : SizedBox(),
                      leading: AutoSizeText(
                          suggestion.purchasedItem.target!.item.target!.company
                                  .target!.name ??
                              "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 12.sp)));
                },
                noItemText: "no_purchased_item_found".tr,
                onSuggestionSelected: (PurchasedItem suggestion) {
                  c.searchController.clear();
                  c.addSearchedPurchasedItem(suggestion);
                  c.openBottomSheet(suggestion);
                },
                suggestionsCallback: (pattern) {
                  return c.searchPurchasedItems(pattern);
                },
              ),
            ],
          ),
        )),
      ),
      body: Obx(() => c.searchedPurchasedItemList.isEmpty
          ? SearchWidget(text: 'start_searching_purchased_item'.tr)
          : ListView.builder(
              itemCount: c.searchedPurchasedItemList.length,
              itemBuilder: (_, index) {
                final DateTime searchedDateTime =
                    c.searchedPurchasedItemList[index].datetime;
                final DateTime purchasedDateTime = c
                    .searchedPurchasedItemList[index]
                    .searchedPurchasedItem
                    .target!
                    .purchasedDate!;
                final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                final String formattedSearchedDate =
                    formatter.format(searchedDateTime);
                final String formattedPurchasedDate =
                    formatter.format(purchasedDateTime);
                return ListContainer(
                  child: ListTile(
                    title: Column(children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${c.searchedPurchasedItemList[index].searchedPurchasedItem.target!.purchasedItem.target!.item.target!.company.target!.name} ${c.searchedPurchasedItemList[index].searchedPurchasedItem.target!.purchasedItem.target!.item.target!.name}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'color'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp),
                              ),
                              Text(
                                  c
                                          .searchedPurchasedItemList[index]
                                          .searchedPurchasedItem
                                          .target!
                                          .purchasedItem
                                          .target!
                                          .color ??
                                      "",
                                  style: TextStyle(fontSize: 11.sp)),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'size'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                    c
                                            .searchedPurchasedItemList[index]
                                            .searchedPurchasedItem
                                            .target!
                                            .purchasedItem
                                            .target!
                                            .size ??
                                        "",
                                    style: TextStyle(fontSize: 11.sp)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'model'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  c
                                          .searchedPurchasedItemList[index]
                                          .searchedPurchasedItem
                                          .target!
                                          .purchasedItem
                                          .target!
                                          .model ??
                                      "",
                                  style: TextStyle(fontSize: 11.sp),
                                ),
                              ),
                            ],
                          ),
                          DeleteButton(
                            onDelete: () {
                              c.deleteSearchedPurchasedItem(
                                  c.searchedPurchasedItemList[index].id!);
                              c.fetchSearchedPurchasedItem();
                            },
                          ),
                        ],
                      ),
                    ]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'TQ'.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp),
                                ),
                                Text(
                                    "${c.searchedPurchasedItemList[index].searchedPurchasedItem.target!.purchasedQuantity.toString()} ${c.searchedPurchasedItemList[index].searchedPurchasedItem.target!.purchasedQuantityUnit.target!.shortName ?? " "}",
                                    style: TextStyle(fontSize: 11.sp)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'CQ'.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp),
                                ),
                                Text(
                                    "${c.searchedPurchasedItemList[index].searchedPurchasedItem.target!.currentQuantity.toString()} ${c.searchedPurchasedItemList[index].searchedPurchasedItem.target!.currentQuantityUnit.target!.shortName ?? " "}",
                                    style: TextStyle(fontSize: 11.sp)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'PP'.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp),
                                ),
                                AutoSizeText(
                                    "${c.searchedPurchasedItemList[index].searchedPurchasedItem.target!.purchasingPrice.toString()} / ${c.searchedPurchasedItemList[index].searchedPurchasedItem.target!.purchasingPriceUnit.target!.shortName ?? " "}",
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: TextStyle(fontSize: 11.sp)),
                              ],
                            ),
                            Column(
                              children: [
                                AutoSizeText(
                                  'SP'.tr,
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp),
                                ),
                                AutoSizeText(
                                  "${c.searchedPurchasedItemList[index].searchedPurchasedItem.target!.sellingPrice.toString()} / ${c.searchedPurchasedItemList[index].searchedPurchasedItem.target!.sellingPriceUnit.target!.shortName ?? " "} ",
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: TextStyle(fontSize: 11.sp),
                                ),
                              ],
                            )
                          ],
                        ),
                        Text(formattedSearchedDate,
                            style: Get.textTheme.titleSmall)
                      ],
                    ),
                    onTap: () {
                      c.openBottomSheet(c.searchedPurchasedItemList[index]
                          .searchedPurchasedItem.target!);
                    },
                    onLongPress: () async {
                      await Get.toNamed(Routes.CREATE_PURCHASED_ITEM,
                          arguments: [
                            true,
                            c.searchedPurchasedItemList[index]
                                .searchedPurchasedItem.target!
                          ]);
                      c.fetchSearchedPurchasedItem();
                    },
                  ),
                );
              })),
      floatingActionButton: Column(
        children: [
          Spacer(),
          FloatingButton(
              heroTag: 'list',
              onPressed: () async {
                await Get.toNamed(Routes.LIST_PURCHASED_ITEM);
                c.fetchSearchedPurchasedItem();
              },
              text: "view_purchased_item_n".tr,
              icon: Icons.menu),
          SizedBox(height: 20.h),
          FloatingButton(
              heroTag: 'add',
              onPressed: () {
                Get.toNamed(Routes.CREATE_PURCHASED_ITEM, arguments: [false]);
              },
              text: "add_purchased_item_n".tr,
              icon: Icons.add),
        ],
      ),
    );
  }
}
