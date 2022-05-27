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

import '../controllers/list_customer_category_controller.dart';

class ListCustomerCategoryView extends GetView<ListCustomerCategoryController> {
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
                  hint: "search_customer_category_here".tr,
                  isDeviceConnected: networkController.connectionStatus.value,
                  itemBuilder: (context, CustomerCategory suggestion) {
                    return ListTile(
                      title: AutoSizeText(suggestion.name ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 13.sp)),
                    );
                  },
                  noItemText: "no_customer_category_found".tr,
                  onSuggestionSelected: (CustomerCategory suggestion) {
                    c.searchController.clear();
                    c.addSearchedCategory(suggestion);
                    c.categoryController.openBottomSheet(suggestion);
                  },
                  suggestionsCallback: (pattern) {
                    return c.searchCategories(pattern);
                  },
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.categoryList.isEmpty
              ? NoItemWidget(
                  noText: "no_customer_category".tr,
                  addText: "add_no_customer_category".tr,
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_CUSTOMER_CATEGORY,
                        arguments: [false]);
                    c.categoryList.value =
                        c.objectBoxController.customerCategoryBox.getAll();
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
                          return ListContainer(
                            child: ListTile(
                              onLongPress: () async {
                                await Get.toNamed(
                                    Routes.CREATE_CUSTOMER_CATEGORY,
                                    arguments: [true, e.item]);
                                c.categoryList.value = c
                                    .objectBoxController.customerCategoryBox
                                    .getAll();
                              },
                              onTap: () {
                                c.categoryController.openBottomSheet(e.item);
                              },
                              trailing: DeleteButton(
                                onDelete: () {
                                  c.categoryController
                                      .deleteCustomerCategory(e.item.id!);
                                  c.categoryList.value = c
                                      .objectBoxController.customerCategoryBox
                                      .getAll();
                                },
                              ),
                              title: AutoSizeText(e.name,
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: Get.textTheme.titleLarge),
                              subtitle: AutoSizeText(
                                  "number_of_customer".tr +
                                      e.item.customers.length.toString(),
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: Get.textTheme.titleMedium),
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
