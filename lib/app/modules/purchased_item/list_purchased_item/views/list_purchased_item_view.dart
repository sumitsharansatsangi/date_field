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
                          return Container(
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.only(bottom: 5.h),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade50,
                              borderRadius: BorderRadius.circular(
                                  30), //border corner radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple
                                      .withOpacity(0.5), //color of shadow
                                  spreadRadius: 5.sp, //spread radius
                                  blurRadius: 7.sp, // blur radius
                                  offset: const Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ListTile(
                                onLongPress: () {
                                  Get.toNamed(Routes.CREATE_PURCHASED_ITEM,
                                      arguments: [true, e.item]);
                                },
                                onTap: () => c.purchasedItemController
                                    .openBottomSheet(e.item),
                                title: Column(
                                  children: [
                                    AutoSizeText(
                                      e.name,
                                      stepGranularity: 1.sp,
                                      minFontSize: 8.sp,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    SizedBox(height: 5.h)
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        AutoSizeText(
                                          'CQ'.tr,
                                          stepGranularity: 1.sp,
                                          minFontSize: 8.sp,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp),
                                        ),
                                        AutoSizeText(
                                            e.item.currentQuantity.toString(),
                                            stepGranularity: 1.sp,
                                            minFontSize: 8.sp,
                                            style: TextStyle(fontSize: 11.sp)),
                                        AutoSizeText(
                                            e.item.currentQuantityUnit.target
                                                    .shortName ??
                                                " ",
                                            stepGranularity: 1.sp,
                                            minFontSize: 8.sp,
                                            style: TextStyle(fontSize: 11.sp)),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        AutoSizeText(
                                          'PP'.tr,
                                          stepGranularity: 1.sp,
                                          minFontSize: 8.sp,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp),
                                        ),
                                        AutoSizeText(
                                            e.item.purchasingPrice.toString(),
                                            stepGranularity: 1.sp,
                                            minFontSize: 8.sp,
                                            style: TextStyle(fontSize: 11.sp)),
                                        AutoSizeText(
                                            e.item.purchasingPriceUnit.target
                                                    .shortName ??
                                                " ",
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
                                          e.item.sellingPrice.toString(),
                                          stepGranularity: 1.sp,
                                          minFontSize: 8.sp,
                                          style: TextStyle(fontSize: 11.sp),
                                        ),
                                        AutoSizeText(
                                          e.item.sellingPriceUnit.target
                                                  .shortName ??
                                              " ",
                                          stepGranularity: 1.sp,
                                          minFontSize: 8.sp,
                                          style: TextStyle(fontSize: 11.sp),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                leading: ProfilePicture(
                                  name: e.name,
                                  radius: 20.r,
                                  fontsize: 20.sp,
                                ),
                                trailing: DeleteButton(
                                  onDelete: () {
                                    c.purchasedItemController
                                        .deletePurchasedItem(e.item.id!);
                                    c.purchasedItemList.value = c
                                        .purchasedItemController
                                        .objectBoxController
                                        .purchasedItemBox
                                        .getAll();
                                  },
                                )),
                          );
                        },
                      ),
                    ))
                  ],
                ),
        ));
  }
}
