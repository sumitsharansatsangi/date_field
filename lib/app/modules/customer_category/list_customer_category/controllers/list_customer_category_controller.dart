import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/customer_category_controller.dart';

class ListCustomerCategoryController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final categoryController = Get.find<CustomerCategoryController>();
  final isLoading = false.obs;
  final categoryList = <CustomerCategory>[].obs;
  final searchedCategoryList = <CustomerCategory>[].obs;
  final selectedIndex = 0.obs;

  void addSearchedCategory(CustomerCategory category) {
    objectBoxController.searchedCustomerCategoryBox
        .put(SearchedCustomerCategory()..searchedCategory.target = category);
  }

  List<CustomerCategory> searchCategories(pattern) {
    final queryBuilder = objectBoxController.customerCategoryBox.query(
        CustomerCategory_.name.startsWith(pattern, caseSensitive: false));
    queryBuilder.order(CustomerCategory_.name);
    searchedCategoryList.value = queryBuilder.build().find();
    return categoryList;
  }

  @override
  void onReady() {
    super.onReady();
    categoryList.value = objectBoxController.customerCategoryBox.getAll();
  }
}
