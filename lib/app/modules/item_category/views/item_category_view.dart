import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/item_category_controller.dart';

class ItemCategoryView extends GetView<ItemCategoryController> {
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
                    title: AutoSizeText(suggestion.name ?? " ",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: TextStyle(fontSize: 13.sp)),
                  );
                },
                noItemText: "no_item_category_found".tr,
                onSuggestionSelected: (ItemCategory suggestion) async {
                  c.searchController.clear();
                  c.addSearchedCategory(suggestion);
                  c.openBottomSheet(suggestion);
                },
                suggestionsCallback: (pattern) {
                  return c.searchCategories(pattern);
                },
              ),
            ],
          ),
        )),
      ),
      body: Obx(() => c.searchedCategoryList.isEmpty
          ? SearchWidget(text: 'start_searching_item_category'.tr)
          : ListView.builder(
              itemCount: c.searchedCategoryList.length,
              itemBuilder: (_, index) {
                final DateTime dateTime =
                    c.searchedCategoryList[index].datetime;
                final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                final String formattedDate = formatter.format(dateTime);
                return Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(bottom: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius:
                        BorderRadius.circular(30), //border corner radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple
                            .withOpacity(0.5), //color of shadow
                        spreadRadius: 5.sp, //spread radius
                        blurRadius: 7.sp, // blur radius
                        offset:
                            const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                      title: AutoSizeText(
                          c.searchedCategoryList[index].searchedCategory.target!
                                  .name ??
                              "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 13.sp)),
                      subtitle: AutoSizeText(formattedDate,
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(
                              color: Colors.black54, fontSize: 11.sp)),
                      trailing: DeleteButton(
                        onDelete: () {
                          c.deleteSearchedCategory(
                              c.searchedCategoryList[index].id!);
                        },
                      ),
                      onLongPress: () async {
                        await Get.toNamed(Routes.CREATE_ITEM_CATEGORY,
                            arguments: [
                              true,
                              c.searchedCategoryList[index].searchedCategory
                                  .target!,
                            ]);
                        c.fetchSearchedItemCategory();
                      },
                      onTap: () => c.openBottomSheet(
                            c.searchedCategoryList[index].searchedCategory
                                .target!,
                          )),
                );
              })),
      floatingActionButton: Column(
        children: [
          Spacer(),
          FloatingButton(
              heroTag: 'list',
              onPressed: () async {
                await Get.toNamed(Routes.LIST_ITEM_CATEGORY);
                c.fetchSearchedItemCategory();
              },
              text: "view_item_category_n".tr,
              icon: Icons.menu),
          SizedBox(height: 20),
          FloatingButton(
              heroTag: 'add',
              onPressed: () {
                Get.toNamed(Routes.CREATE_ITEM_CATEGORY, arguments: [false]);
              },
              text: "add_item_category_n".tr,
              icon: Icons.add),
        ],
      ),
    );
  }
}
