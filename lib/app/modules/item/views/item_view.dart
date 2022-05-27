import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/item_controller.dart';

class ItemView extends GetView<ItemController> {
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
                          style: TextStyle(fontSize: 13.sp)),
                      subtitle: suggestion.alternateName != null
                          ? Wrap(
                              children: [
                                for (final name in suggestion.alternateName!)
                                  AutoSizeText(name,
                                      stepGranularity: 1.sp,
                                      minFontSize: 8.sp,
                                      style: TextStyle(fontSize: 13.sp))
                              ],
                              spacing: 2.w,
                            )
                          : SizedBox(),
                      trailing: AutoSizeText(
                        suggestion.company.target!.name ?? "",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: TextStyle(fontSize: 12.sp),
                      ));
                },
                noItemText: "no_item_found".tr,
                onSuggestionSelected: (Item suggestion) {
                  c.searchController.clear();
                  c.addSearchedItem(suggestion);
                  c.openBottomSheet(suggestion);
                },
                suggestionsCallback: (pattern) {
                  return c.searchItems(pattern);
                },
              ),
            ],
          ),
        )),
      ),
      body: Obx(() => c.searchedItemList.isEmpty
          ? SearchWidget(text: 'start_searching_item'.tr)
          : ListView.builder(
              itemCount: c.searchedItemList.length,
              itemBuilder: (_, index) {
                final DateTime dateTime = c.searchedItemList[index].datetime;
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
                    title: Row(
                      children: [
                        AutoSizeText(
                            c.searchedItemList[index].searchedItem.target!
                                .name!,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 13.sp)),
                        SizedBox(width: 10.w),
                        AutoSizeText(c.searchedItemList[index].searchedItem
                            .target!.company.target!.name!),
                      ],
                    ),
                    subtitle: Text(formattedDate,
                        style:
                            TextStyle(color: Colors.black54, fontSize: 11.sp)),
                    trailing: DeleteButton(
                      onDelete: () {
                        c.deleteSearchedItem(c.searchedItemList[index].id!);
                        c.fetchSearchedItem();
                      },
                    ),
                    onTap: () => c.openBottomSheet(
                        c.searchedItemList[index].searchedItem.target!),
                    onLongPress: () {
                      Get.toNamed(Routes.CREATE_ITEM, arguments: [
                        true,
                        c.searchedItemList[index].searchedItem.target!
                      ]);
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
                await Get.toNamed(Routes.LIST_ITEM);
                c.fetchSearchedItem();
              },
              text: "view_item_n".tr,
              icon: Icons.menu),
          SizedBox(height: 20),
          FloatingButton(
              heroTag: 'add',
              onPressed: () {
                Get.toNamed(Routes.CREATE_ITEM, arguments: [false]);
              },
              text: "add_item_n".tr,
              icon: Icons.add),
        ],
      ),
    );
  }
}
