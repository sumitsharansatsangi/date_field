import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          "${c.searchedPurchasedItemList[index].searchedPurchasedItem.target!.purchasedItem.target!.item.target!.company.target!.name} ${c.searchedPurchasedItemList[index].searchedPurchasedItem.target!.purchasedItem.target!.item.target!.name} ",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleMedium,
                        ),
                        SizedBox(
                          width: 10.sw,
                        ),
                        Row(
                          children: [
                            AutoSizeText("purchase_date".tr,
                                stepGranularity: 1.sp,
                                minFontSize: 8.sp,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp)),
                            AutoSizeText(formattedPurchasedDate,
                                stepGranularity: 1.sp,
                                minFontSize: 8.sp,
                                style: TextStyle(fontSize: 11.sp))
                          ],
                        ),
                        SizedBox()
                      ],
                    ),
                    subtitle: AutoSizeText(formattedSearchedDate,
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleSmall),
                    trailing: DeleteButton(
                      onDelete: () {
                        c.deleteSearchedPurchasedItem(
                            c.searchedPurchasedItemList[index].id!);
                      },
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
