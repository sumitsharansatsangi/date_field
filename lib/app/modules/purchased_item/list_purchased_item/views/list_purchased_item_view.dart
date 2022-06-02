import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/alphabets_scroll.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:text_icon/text_icon.dart';
import 'package:get/get.dart';
import 'package:speed_up_get/speed_up_get.dart';
import '../../../../data/model.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/list_purchased_item_controller.dart';

class ListPurchasedItemView extends GetView<ListPurchasedItemController> {
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
                    final DateTime dateTime = suggestion.purchasedDate!;
                    final DateFormat formatter =
                        DateFormat('yyyy-MM-dd kk:mm:a');
                    final String formattedDate = formatter.format(dateTime);
                    return ListTile(
                        title: AutoSizeText(
                            suggestion
                                    .purchasedItem.target!.item.target!.name ??
                                " ",
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: TextStyle(fontSize: 13.sp)),
                        subtitle: AutoSizeText(
                            suggestion.suppliedBy.target!.name ?? " ",
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: TextStyle(fontSize: 11.sp)),
                        trailing: AutoSizeText(formattedDate,
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: TextStyle(fontSize: 12.sp)));
                  },
                  noItemText: "no_purchased_item_found".tr,
                  onSuggestionSelected: (PurchasedItem suggestion) {
                    c.searchController.clear();
                    c.purchasedItemController
                        .addSearchedPurchasedItem(suggestion);
                    c.purchasedItemController.openBottomSheet(suggestion);
                  },
                  suggestionsCallback: (pattern) {
                    return c.purchasedItemController
                        .searchPurchasedItems(pattern);
                  },
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.purchasedItemList.isEmpty
              ? NoItemWidget(
                  noText: "no_item".tr,
                  addText: "add_no_purchased_item".tr,
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_PURCHASED_ITEM,
                        arguments: [false]);
                    c.purchasedItemList.value = c.purchasedItemController
                        .objectBoxController.purchasedItemBox
                        .getAll();
                  },
                )
              : Column(
                  children: [
                    Expanded(
                        child: Obx(
                      () => AlphabetScrollView(
                        list: c.purchasedItemList
                            .map((e) => AlphaModel<PurchasedItem>(
                                  e,
                                  e.purchasedItem.target!.item.target!.name ??
                                      " ",
                                ))
                            .toList(),
                        itemBuilder: (_, k, e) {
                          PurchasedItem purchasedItem = e.item;
                          return ListContainer(
                            child: ListTile(
                              onLongPress: () {
                                Get.toNamed(Routes.CREATE_PURCHASED_ITEM,
                                    arguments: [true, e.item]);
                              },
                              onTap: () => c.purchasedItemController
                                  .openBottomSheet(e.item),
                              title: Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "${purchasedItem.purchasedItem.target!.item.target!.company.target!.name} ${e.name}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ProfilePicture(
                                        name: e.name,
                                        radius: 20.r,
                                        fontsize: 20.sp,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'color'.tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp),
                                          ),
                                          Text(
                                              purchasedItem.purchasedItem
                                                      .target!.color ??
                                                  "",
                                              style:
                                                  TextStyle(fontSize: 11.sp)),
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
                                                purchasedItem.purchasedItem
                                                        .target!.size ??
                                                    "",
                                                style:
                                                    TextStyle(fontSize: 11.sp)),
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
                                              purchasedItem.purchasedItem
                                                      .target!.model ??
                                                  "",
                                              style: TextStyle(fontSize: 11.sp),
                                            ),
                                          ),
                                        ],
                                      ),
                                      DeleteButton(
                                        onDelete: () {
                                          c.purchasedItemController
                                              .deletePurchasedItem(e.item.id!);
                                          c.purchasedItemList.value = c
                                              .purchasedItemController
                                              .objectBoxController
                                              .purchasedItemBox
                                              .getAll();
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          "${purchasedItem.purchasedQuantity.toString()} ${purchasedItem.purchasedQuantityUnit.target!.shortName ?? " "}",
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
                                          "${purchasedItem.currentQuantity.toString()} ${purchasedItem.currentQuantityUnit.target!.shortName ?? " "}",
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
                                          "${purchasedItem.purchasingPrice.toString()} / ${purchasedItem.purchasingPriceUnit.target!.shortName ?? " "}",
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
                                        "${purchasedItem.sellingPrice.toString()} / ${purchasedItem.sellingPriceUnit.target!.shortName ?? " "} ",
                                        stepGranularity: 1.sp,
                                        minFontSize: 8.sp,
                                        style: TextStyle(fontSize: 11.sp),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ))
                  ],
                ),
        ));
  }
}
