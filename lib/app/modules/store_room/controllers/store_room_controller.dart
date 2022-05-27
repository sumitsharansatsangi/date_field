import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StoreRoomController extends GetxController {
  final objectBoxController = Get.find<ObjectBoxController>();
  TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final searchedStoreRoomList = <SearchedStoreRoom>[].obs;
  var storeRoomList = <StoreRoom>[].obs;

  List<StoreRoom> searchStoreRooms(pattern) {
    final queryBuilder = objectBoxController.storeRoomBox.query(StoreRoom_.name
        .startsWith(pattern, caseSensitive: false)
        .or(StoreRoom_.name.contains(pattern, caseSensitive: false)));
    queryBuilder.order(StoreRoom_.name);
    storeRoomList.bindStream(queryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
    return storeRoomList;
  }

  void addSearchedStoreRoom(StoreRoom storeRoom) {
    objectBoxController.searchedStoreRoomBox
        .put(SearchedStoreRoom()..searchedStoreRoom.target = storeRoom);
  }

  deleteStoreRoom(int id) {
    final query = objectBoxController.searchedStoreRoomBox.query();
    query.link(SearchedStoreRoom_.searchedStoreRoom, StoreRoom_.id.equals(id));
    query.build().remove();
    objectBoxController.storeRoomBox.remove(id);
  }

  deleteSearchedStoreRoom(int id) {
    objectBoxController.searchedStoreRoomBox.remove(id);
  }

  @override
  void onReady() {
    super.onReady();
    fetchSearchedStoreRoom();
  }

  fetchSearchedStoreRoom() {
    final searchedStoreRoomBuilder = objectBoxController.searchedStoreRoomBox
        .query()
      ..order(SearchedStoreRoom_.datetime, flags: Order.descending);
    searchedStoreRoomList.bindStream(searchedStoreRoomBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void openBottomSheet(StoreRoom storeRoom) {
    Get.bottomSheet(
        ListView(
          children: [
            SizedBox(height: 20.h),
            BottomSheetRow(
              onDelete: () {
                deleteStoreRoom(storeRoom.id!);
                Get.back();
                fetchSearchedStoreRoom();
              },
            ),
            SizedBox(height: 10.h),
            Center(
              child: Padding(
                padding: EdgeInsets.all(3.r),
                child: Table(
                  border: TableBorder.all(color: Colors.deepPurple.shade200),
                  columnWidths: {
                    0: FlexColumnWidth(1 / 3),
                    1: FlexColumnWidth(2 / 3)
                  },
                  children: [
                    TableRow(children: [
                      Heading("name".tr),
                      Content(storeRoom.name ?? " "),
                    ]),
                    if (storeRoom.godown.target != null)
                      TableRow(children: [
                        Heading("godown".tr),
                        Content(storeRoom.godown.target!.name ?? ""),
                      ]),
                    TableRow(children: [
                      Heading("number_of_almirah".tr),
                      Content(storeRoom.almirahs.length.toString()),
                    ]),
                    TableRow(children: [
                      Heading("number_of_searches".tr),
                      Content(storeRoom.searches.length.toString()),
                    ])
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 234, 232, 238),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        ignoreSafeArea: false);
  }
}
