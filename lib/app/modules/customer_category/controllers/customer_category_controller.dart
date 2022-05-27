import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/model.dart';

class CustomerCategoryController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final searchedCategoryList = <SearchedCustomerCategory>[].obs;
  final categoryList = <CustomerCategory>[].obs;
  final objectBoxController = Get.find<ObjectBoxController>();

  List<CustomerCategory> searchCategories(pattern) {
    final queryBuilder = objectBoxController.customerCategoryBox.query(
        CustomerCategory_.name.startsWith(pattern, caseSensitive: false).or(
            CustomerCategory_.name.contains(pattern, caseSensitive: false)));
    queryBuilder.order(CustomerCategory_.name);
    categoryList.bindStream(queryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
    return categoryList;
  }

  void addSearchedCategory(CustomerCategory category) {
    objectBoxController.searchedCustomerCategoryBox
        .put(SearchedCustomerCategory()..searchedCategory.target = category);
  }

  void deleteCustomerCategory(int id) {
    final query = objectBoxController.searchedCustomerCategoryBox.query();
    query.link(SearchedCustomerCategory_.searchedCategory,
        CustomerCategory_.id.equals(id));
    query.build().remove();
    objectBoxController.customerCategoryBox.remove(id);
  }

  void deleteSearchedCustomerCategory(int id) {
    objectBoxController.searchedCustomerCategoryBox.remove(id);
  }

  @override
  void onReady() {
    super.onReady();
    fetchSearchedCustomerCategory();
  }

  fetchSearchedCustomerCategory() {
    final searchedCategoryBuilder =
        objectBoxController.searchedCustomerCategoryBox.query()
          ..order(SearchedCustomerCategory_.datetime, flags: Order.descending);
    searchedCategoryList.bindStream(searchedCategoryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void openBottomSheet(CustomerCategory category) {
    Get.bottomSheet(
        ListView(children: [
          SizedBox(height: 20.h),
          BottomSheetRow(
            onDelete: () {
              deleteCustomerCategory(category.id!);
              Get.back();
              fetchSearchedCustomerCategory();
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
