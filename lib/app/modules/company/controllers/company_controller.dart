import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/model.dart';

class CompanyController extends GetxController {
  final objectBoxController = Get.find<ObjectBoxController>();
  TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final searchedCompanyList = <SearchedCompany>[].obs;

  List<Company> searchCompanies(pattern) {
    final queryBuilder = objectBoxController.companyBox.query(Company_.name
        .startsWith(pattern, caseSensitive: false)
        .or(Company_.name.contains(pattern, caseSensitive: false)));
    queryBuilder.order(Company_.name);
    return queryBuilder.build().find();
  }

  void addSearchedCompany(Company company) {
    try {
      final searchedCompany = SearchedCompany()
        ..searchedCompany.target = company;
      objectBoxController.searchedCompanyBox.put(searchedCompany);
    } on Exception {
      errorSnackBar();
    }
  }

  deleteCompany(int id) {
    final query = objectBoxController.searchedCompanyBox.query();
    query.link(SearchedCompany_.searchedCompany, Company_.id.equals(id));
    query.build().remove();
    objectBoxController.companyBox.remove(id);
  }

  deleteSearchedCompany(int id) {
    objectBoxController.searchedCompanyBox.remove(id);
  }

  @override
  void onReady() {
    super.onReady();
    fetchSearchedCompany();
  }

  fetchSearchedCompany() {
    final searchedCompanyBuilder = objectBoxController.searchedCompanyBox
        .query()
      ..order(SearchedCompany_.datetime, flags: Order.descending);
    searchedCompanyList.bindStream(searchedCompanyBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void openBottomSheet(Company company) {
    Get.bottomSheet(
        ListView(children: [
          SizedBox(height: 20.h),
          BottomSheetRow(
            onDelete: () {
              deleteCompany(company.id!);
              Get.back();
              fetchSearchedCompany();
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
                    Content(company.name ?? " "),
                  ]),
                  TableRow(children: [
                    Heading("number_of_item".tr),
                    Content(company.items.length.toString()),
                  ]),
                  TableRow(children: [
                    Heading("number_of_searches".tr),
                    Content(company.searches.length.toString()),
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
