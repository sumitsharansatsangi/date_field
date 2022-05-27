import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UnitController extends GetxController {
  final objectBoxController = Get.find<ObjectBoxController>();
  TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final searchedUnitList = <SearchedUnit>[].obs;
  final conversionTextList = <String>[].obs;
  final unitList = <Unit>[].obs;

  List<Unit> searchUnits(pattern) {
    final queryBuilder = objectBoxController.unitBox.query(Unit_.fullName
        .startsWith(pattern, caseSensitive: false)
        .or(Unit_.fullName.contains(pattern, caseSensitive: false)));
    queryBuilder.order(Unit_.fullName);
    unitList.value = queryBuilder.build().find();
    return unitList;
  }

  void addSearchedUnit(Unit unit) {
    objectBoxController.searchedUnitBox
        .put(SearchedUnit()..searchedUnit.target = unit);
  }

  void fetchUnitDetails(int id) {
    final query = objectBoxController.unitRelationBox.query();
    query.link(UnitRelation_.unitFrom, Unit_.id.equals(id));
    conversionTextList.assignAll([
      for (final e in query.build().find())
        "1 ${e.unitFrom.target!.fullName} = ${e.value} ${e.unitTo.target!.fullName}"
    ]);
  }

  deleteUnit(int id) {
    final query = objectBoxController.searchedUnitBox.query();
    query.link(SearchedUnit_.searchedUnit, Unit_.id.equals(id));
    query.build().remove();
    objectBoxController.unitBox.remove(id);
  }

  deleteSearchedUnit(int id) {
    objectBoxController.searchedUnitBox.remove(id);
  }

  @override
  void onReady() {
    super.onReady();
    fetchSearchedUnit();
  }

  fetchSearchedUnit() {
    final searchedUnitBuilder = objectBoxController.searchedUnitBox.query()
      ..order(SearchedUnit_.datetime, flags: Order.descending);
    searchedUnitList.bindStream(searchedUnitBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void openBottomSheet(Unit unit) {
    Get.bottomSheet(
        ListView(children: [
          SizedBox(height: 20.h),
          BottomSheetRow(
            onDelete: () {
              deleteUnit(unit.id!);
              Get.back();
              fetchSearchedUnit();
            },
          ),
          SizedBox(height: 25.h),
          Center(
            child: Padding(
              padding: EdgeInsets.all(3.r),
              child: Table(
                border: TableBorder.all(color: Colors.deepPurple.shade200),
                children: [
                  TableRow(children: [
                    Heading("fullname".tr),
                    Content(unit.fullName ?? " "),
                  ]),
                  TableRow(children: [
                    Heading("shortname".tr),
                    Content(unit.shortName ?? " "),
                  ]),
                  TableRow(children: [
                    Heading("number_of_searches".tr),
                    Content(unit.searches.length.toString())
                  ])
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Column(
            children: [
              for (final hint in conversionTextList)
                Center(
                  child: AutoSizeText(hint, style: TextStyle(fontSize: 14.sp)),
                )
            ],
          )
        ]),
        backgroundColor: Color.fromARGB(255, 234, 232, 238),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        ignoreSafeArea: false);
  }
}
