import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/alphabets_scroll.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speed_up_get/speed_up_get.dart';
import '../controllers/list_store_room_controller.dart';

class ListStoreRoomView extends GetView<ListStoreRoomController> {
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
                      title: AutoSizeText(suggestion.name ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleLarge),
                    );
                  },
                  noItemText: "no_store_room_found".tr,
                  onSuggestionSelected: (StoreRoom suggestion) {
                    c.searchController.clear();
                    c.storeController.addSearchedStoreRoom(suggestion);
                    c.storeController.openBottomSheet(suggestion);
                  },
                  suggestionsCallback: (pattern) {
                    return c.storeController.searchStoreRooms(pattern);
                  },
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.storeRoomList.isEmpty
              ? NoItemWidget(
                  noText: "no_store_room".tr,
                  addText: "add_no_store_room".tr,
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_COMPANY,
                        arguments: [false]);
                    c.storeRoomList.value =
                        c.objectBoxController.storeRoomBox.getAll();
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: AlphabetScrollView(
                        list: [
                          for (final store in c.storeRoomList)
                            AlphaModel(store, store.name ?? " ")
                        ],
                        itemBuilder: (_, k, e) {
                          return ListContainer(
                            child: ListTile(
                                onLongPress: () async {
                                  await Get.toNamed(Routes.CREATE_STORE_ROOM,
                                      arguments: [true, e.item]);
                                  c.storeRoomList.value = c
                                      .objectBoxController.storeRoomBox
                                      .getAll();
                                },
                                onTap: () {
                                  c.storeController.openBottomSheet(e.item);
                                },
                                title: AutoSizeText(e.name,
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: Get.textTheme.titleLarge),
                                subtitle: e.item.godown.target != null
                                    ? AutoSizeText(
                                        e.item.godown.target!.name ?? "",
                                        stepGranularity: 1.sp,
                                        minFontSize: 8.sp,
                                        style: Get.textTheme.titleSmall)
                                    : SizedBox(),
                                trailing: DeleteButton(
                                  onDelete: () {
                                    c.storeController
                                        .deleteStoreRoom(e.item.id!);
                                    c.storeRoomList.value = c
                                        .objectBoxController.storeRoomBox
                                        .getAll();
                                  },
                                )),
                          );
                        },
                      ),
                    )
                  ],
                ),
        ));
  }
}
