import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ItemCategoryController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final searchedCategoryList = <SearchedItemCategory>[].obs;
  final categoryList = <ItemCategory>[].obs;
  final objectBoxController = Get.find<ObjectBoxController>();

  List<ItemCategory> searchCategories(pattern) {
    final queryBuilder = objectBoxController.itemCategoryBox.query(ItemCategory_
        .name
        .startsWith(pattern, caseSensitive: false)
        .or(ItemCategory_.name.contains(pattern, caseSensitive: false)));
    queryBuilder.order(ItemCategory_.name);
    categoryList.bindStream(queryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
    return categoryList;
  }

  void addSearchedCategory(ItemCategory category) {
    objectBoxController.searchedItemCategoryBox
        .put(SearchedItemCategory()..searchedCategory.target = category);
  }

  void deleteItemCategory(int id) {
    final query = objectBoxController.searchedItemCategoryBox.query();
    query.link(
        SearchedItemCategory_.searchedCategory, ItemCategory_.id.equals(id));
    query.build().remove();
    objectBoxController.itemCategoryBox.remove(id);
  }

  void deleteSearchedCategory(int id) {
    objectBoxController.searchedItemCategoryBox.remove(id);
  }

  @override
  void onReady() {
    super.onReady();
    fetchSearchedItemCategory();
  }

  fetchSearchedItemCategory() {
    final searchedCategoryBuilder = objectBoxController.searchedItemCategoryBox
        .query()
      ..order(SearchedItemCategory_.datetime, flags: Order.descending);
    searchedCategoryList.bindStream(searchedCategoryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void openBottomSheet(ItemCategory category) {
    Get.bottomSheet(
        ListView(children: [
          SizedBox(height: 20.h),
          BottomSheetRow(
            onDelete: () {
              deleteItemCategory(category.id!);
              Get.back();
              fetchSearchedItemCategory();
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
                    Content(category.name ?? " "),
                  ]),
                  TableRow(children: [
                    Heading("number_of_searches".tr),
                    Content(category.searches.length.toString()),
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
