import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AlmirahController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final searchedAlmirahList = <SearchedAlmirah>[].obs;
  final almirahList = <Almirah>[].obs;
  final objectBoxController = Get.find<ObjectBoxController>();

  void addSearchedAlmirah(Almirah almirah) {
    objectBoxController.searchedAlmirahBox
        .put(SearchedAlmirah()..searchedAlmirah.target = almirah);
  }

  List<Almirah> searchAlmirahs(pattern) {
    final queryBuilder = objectBoxController.almirahBox.query(Almirah_.name
        .startsWith(pattern, caseSensitive: false)
        .or(Almirah_.name.contains(pattern, caseSensitive: false)));
    queryBuilder.order(Almirah_.name);
    almirahList.value = queryBuilder.build().find();
    return almirahList;
  }

  void deleteAlmirah(int id) {
    final query = objectBoxController.searchedAlmirahBox.query();
    query.link(SearchedAlmirah_.searchedAlmirah, Almirah_.id.equals(id));
    query.build().remove();
    objectBoxController.almirahBox.remove(id);
  }

  void deleteSearchedAlmirah(int id) {
    objectBoxController.searchedAlmirahBox.remove(id);
  }

  @override
  void onReady() async {
    super.onReady();
    fetchSearchedAlmirah();
  }

  fetchSearchedAlmirah() {
    final searchedAlmirahBuilder = objectBoxController.searchedAlmirahBox
        .query()
      ..order(SearchedAlmirah_.datetime, flags: Order.descending);
    searchedAlmirahList.bindStream(searchedAlmirahBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void openBottomSheet(Almirah almirah) {
    Get.bottomSheet(
        ListView(children: [
          SizedBox(height: 20.h),
          BottomSheetRow(
            onDelete: () {
              deleteAlmirah(almirah.id!);
              Get.back();
              fetchSearchedAlmirah();
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
                    Content(almirah.name ?? " "),
                  ]),
                  if (almirah.room.target != null)
                    TableRow(children: [
                      Heading("store_room".tr),
                      Content(almirah.room.target!.name ?? ""),
                    ]),
                  if (almirah.godown.target != null)
                    TableRow(children: [
                      Heading("godown".tr),
                      Content(almirah.godown.target!.name ?? ""),
                    ]),
                  if (almirah.row != null)
                    TableRow(children: [
                      Heading("number_of_row".tr),
                      Content(almirah.row.toString()),
                    ]),
                  if (almirah.column != null)
                    TableRow(children: [
                      Heading("number_of_column".tr),
                      Content(almirah.column.toString()),
                    ]),
                  TableRow(children: [
                    Heading("number_of_searches".tr),
                    Content(almirah.searches.length.toString()),
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
