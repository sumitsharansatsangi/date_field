import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GodownController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final searchedGodownList = <SearchedGodown>[].obs;
  final godownList = <Godown>[].obs;
  final objectBoxController = Get.find<ObjectBoxController>();

  List<Godown> searchGodowns(pattern) {
    final queryBuilder = objectBoxController.godownBox.query(Godown_.name
        .startsWith(pattern, caseSensitive: false)
        .or(Godown_.name.contains(pattern, caseSensitive: false)));
    queryBuilder.order(Godown_.name);
    godownList.value = queryBuilder.build().find();
    return godownList;
  }

  void addSearchedGodown(Godown godown) {
    objectBoxController.searchedGodownBox
        .put(SearchedGodown()..searchedGodown.target = godown);
  }

  void deleteGodown(int id) {
    final query = objectBoxController.searchedGodownBox.query();
    query.link(SearchedGodown_.searchedGodown, Godown_.id.equals(id));
    query.build().remove();
    objectBoxController.godownBox.remove(id);
  }

  void deleteSearchedGodown(int id) {
    objectBoxController.searchedGodownBox.remove(id);
  }

  @override
  void onReady() async {
    super.onReady();
    fetchSearchedGodown();
  }

  fetchSearchedGodown() {
    final searchedGodownBuilder = objectBoxController.searchedGodownBox.query()
      ..order(SearchedGodown_.datetime, flags: Order.descending);
    searchedGodownList.bindStream(searchedGodownBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void openBottomSheet(Godown godown) {
    Get.bottomSheet(
        ListView(children: [
          SizedBox(height: 20.h),
          BottomSheetRow(
            onDelete: () {
              deleteGodown(godown.id!);
              Get.back();
              fetchSearchedGodown();
            },
          ),
          SizedBox(height: 10.h),
          Center(
            child: Padding(
              padding: EdgeInsets.all(3.r),
              child: Table(
                border: TableBorder.all(color: Colors.deepPurple.shade200),
                children: [
                  TableRow(children: [
                    Heading("name".tr),
                    Content(godown.name ?? " "),
                  ]),
                  TableRow(children: [
                    Heading("number_of_store_room".tr),
                    Content(godown.storeRooms.length.toString()),
                  ]),
                  TableRow(children: [
                    Heading("number_of_almirah".tr),
                    Content(godown.almirahs.length.toString()),
                  ]),
                  TableRow(children: [
                    Heading("number_of_searches".tr),
                    Content(godown.searches.length.toString()),
                  ])
                ],
              ),
            ),
          ),
        ]),
        backgroundColor: Color.fromARGB(255, 234, 232, 238),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        ignoreSafeArea: false);
  }
}
