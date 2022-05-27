import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/model.dart';
import '../../controllers/customer_controller.dart';

class ListCustomerController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final customerList = <Customer>[].obs;
  final customerController = Get.find<CustomerController>();

  @override
  void onReady() {
    super.onReady();
    customerList.value =
        customerController.objectBoxController.customerBox.getAll();
  }
}
