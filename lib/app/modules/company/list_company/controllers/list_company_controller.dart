import 'package:app/app/data/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/company_controller.dart';

class ListCompanyController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final companyController = Get.find<CompanyController>();
  final companyList = <Company>[].obs;

  @override
  void onReady() {
    super.onReady();
    companyList.value =
        companyController.objectBoxController.companyBox.getAll();
  }
}
