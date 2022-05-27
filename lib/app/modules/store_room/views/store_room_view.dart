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

import '../controllers/store_room_controller.dart';

class StoreRoomView extends GetView<StoreRoomController> {
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
                hint: "search_store_room_here".tr,
                isDeviceConnected: networkController.connectionStatus.value,
                itemBuilder: (context, StoreRoom suggestion) {
                  return ListTile(
                    title: AutoSizeText(suggestion.name ?? " ",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleLarge),
                  );
                },
                noItemText: "no_store_room_found".tr,
                onSuggestionSelected: (StoreRoom suggestion) async {
                  c.searchController.clear();
                  c.addSearchedStoreRoom(suggestion);
                  c.openBottomSheet(suggestion);
                },
                suggestionsCallback: (pattern) {
                  return c.searchStoreRooms(pattern);
                },
              ),
            ],
          ),
        )),
      ),
      body: Obx(() => c.searchedStoreRoomList.isEmpty
          ? SearchWidget(text: 'start_searching_store_room'.tr)
          : ListView.builder(
              itemCount: c.searchedStoreRoomList.length,
              itemBuilder: (_, index) {
                final DateTime dateTime =
                    c.searchedStoreRoomList[index].datetime;
                final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                final String formattedDate = formatter.format(dateTime);
                return ListContainer(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                            c.searchedStoreRoomList[index].searchedStoreRoom
                                    .target!.name ??
                                "",
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: Get.textTheme.titleLarge),
                        AutoSizeText(
                            c.searchedStoreRoomList[index].searchedStoreRoom
                                    .target!.godown.target!.name ??
                                "",
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: Get.textTheme.titleMedium),
                      ],
                    ),
                    subtitle: AutoSizeText(formattedDate,
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleSmall),
                    trailing: DeleteButton(
                      onDelete: () {
                        c.deleteSearchedStoreRoom(
                            c.searchedStoreRoomList[index].id!);
                        c.fetchSearchedStoreRoom();
                      },
                    ),
                    onTap: () {
                      c.openBottomSheet(c.searchedStoreRoomList[index]
                          .searchedStoreRoom.target!);
                    },
                    onLongPress: () {
                      Get.toNamed(Routes.CREATE_STORE_ROOM, arguments: [
                        true,
                        c.searchedStoreRoomList[index].searchedStoreRoom.target!
                      ]);
                      c.fetchSearchedStoreRoom();
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
                await Get.toNamed(Routes.LIST_STORE_ROOM);
                c.fetchSearchedStoreRoom();
              },
              text: "view_store_room_n".tr,
              icon: Icons.menu),
          SizedBox(height: 20.h),
          FloatingButton(
              heroTag: 'add',
              onPressed: () {
                Get.toNamed(Routes.CREATE_STORE_ROOM, arguments: [false]);
              },
              text: "add_store_room_n".tr,
              icon: Icons.add),
        ],
      ),
    );
  }
}
