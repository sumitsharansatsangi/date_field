import 'package:app/app/data/model.dart';
import 'package:app/app/modules/supplier/controllers/supplier_controller.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ListSupplierController extends GetxController {
  final objectBoxController = Get.find<ObjectBoxController>();
  TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final supplierList = <Supplier>[].obs;
  final searchedSupplierList = <SearchedSupplier>[].obs;
  final supplierController = Get.find<SupplierController>();

  @override
  void onReady() {
    super.onReady();
    supplierList.value = objectBoxController.supplierBox.getAll();
  }
}
