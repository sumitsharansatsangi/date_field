import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/alphabets_scroll.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/list_item_controller.dart';

class ListItemView extends GetView<ListItemController> {
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
                  hint: "search_item_here".tr,
                  isDeviceConnected: networkController.connectionStatus.value,
                  itemBuilder: (context, Item suggestion) {
                    return ListTile(
                        title: AutoSizeText(suggestion.name ?? "",
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: Get.textTheme.titleLarge),
                        subtitle: suggestion.alternateName != null
                            ? Wrap(
                                children: [
                                  for (final name in suggestion.alternateName!)
                                    AutoSizeText(
                                      name,
                                      stepGranularity: 1.sp,
                                      minFontSize: 8.sp,
                                      style: Get.textTheme.titleSmall,
                                    )
                                ],
                                spacing: 2.w,
                              )
                            : SizedBox(),
                        trailing: Text(
                          suggestion.company.target!.name ?? "",
                          style: Get.textTheme.titleMedium,
                        ));
                  },
                  noItemText: "no_item_found".tr,
                  onSuggestionSelected: (Item suggestion) {
                    c.searchController.clear();
                    c.itemController.addSearchedItem(suggestion);
                    c.itemController.openBottomSheet(suggestion);
                  },
                  suggestionsCallback: (pattern) {
                    return c.itemController.searchItems(pattern);
                  },
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.itemList.isEmpty
              ? NoItemWidget(
                  noText: "no_item".tr,
                  addText: "add_no_item".tr,
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_ITEM, arguments: [false]);
                    c.itemList.value = c.objectBoxController.itemBox.getAll();
                  },
                )
              : Column(
                  children: [
                    Expanded(
                        child: Obx(
                      () => AlphabetScrollView(
                        list: [
                          for (final item in c.itemList)
                            AlphaModel(
                              item,
                              item.name ?? " ",
                            )
                        ],
                        itemBuilder: (_, k, e) {
                          return ListContainer(
                            child: ListTile(
                                isThreeLine: true,
                                onLongPress: () async {
                                  await Get.toNamed(Routes.CREATE_ITEM,
                                      arguments: [true, e.item]);
                                  c.itemList.value =
                                      c.objectBoxController.itemBox.getAll();
                                },
                                onTap: () =>
                                    c.itemController.openBottomSheet(e.item),
                                title: Text(
                                  e.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Company',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                        Text(e.item.company.target!.name ?? "",
                                            style: TextStyle(
                                              fontSize: 9.sp,
                                            )),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Category',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                        Text(e.item.category.target!.name ?? "",
                                            style: TextStyle(
                                              fontSize: 9.sp,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: DeleteButton(
                                  onDelete: () {
                                    c.itemController.deleteItem(e.item.id!);
                                    c.itemList.value =
                                        c.objectBoxController.itemBox.getAll();
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
