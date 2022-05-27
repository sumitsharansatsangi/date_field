import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/alphabets_scroll.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_up_get/speed_up_get.dart';

import '../controllers/list_item_category_controller.dart';

class ListItemCategoryView extends GetView<ListItemCategoryController> {
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
                  hint: "search_item_category_here".tr,
                  isDeviceConnected: networkController.connectionStatus.value,
                  itemBuilder: (context, ItemCategory suggestion) {
                    return ListTile(
                      title: Text(suggestion.name ?? "",
                          style: TextStyle(fontSize: 13.sp)),
                    );
                  },
                  noItemText: "no_item_category_found".tr,
                  onSuggestionSelected: (ItemCategory suggestion) {
                    c.searchController.clear();
                    c.itemCategoryController.addSearchedCategory(suggestion);
                    c.itemCategoryController.openBottomSheet(suggestion);
                  },
                  suggestionsCallback: (pattern) {
                    return c.itemCategoryController.searchCategories(pattern);
                  },
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.categoryList.isEmpty
              ? NoItemWidget(
                  noText: "no_item_category".tr,
                  addText: "add_no_item_category".tr,
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_ITEM_CATEGORY,
                        arguments: [false]);
                    c.categoryList.value = c.itemCategoryController
                        .objectBoxController.itemCategoryBox
                        .getAll();
                  },
                )
              : Column(
                  children: [
                    Expanded(
                        child: Obx(
                      () => AlphabetScrollView(
                        list: c.categoryList
                            .map((e) => AlphaModel(e, e.name ?? " "))
                            .toList(),
                        itemBuilder: (_, k, e) {
                          return Container(
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.symmetric(vertical: 3.h),
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
                              onLongPress: () async {
                                await Get.toNamed(Routes.CREATE_ITEM_CATEGORY,
                                    arguments: [true, e.item]);
                                c.categoryList.value = c.itemCategoryController
                                    .objectBoxController.itemCategoryBox
                                    .getAll();
                              },
                              onTap: () {
                                c.itemCategoryController
                                    .openBottomSheet(e.item);
                              },
                              trailing: DeleteButton(
                                onDelete: () {
                                  c.itemCategoryController
                                      .deleteItemCategory(e.item.id!);
                                  c.categoryList.value = c
                                      .itemCategoryController
                                      .objectBoxController
                                      .itemCategoryBox
                                      .getAll();
                                },
                              ),
                              title: AutoSizeText(e.name,
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                  )),
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
