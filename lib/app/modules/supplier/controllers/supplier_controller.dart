import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SupplierController extends GetxController {
  final objectBoxController = Get.find<ObjectBoxController>();
  TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final searchedSupplierList = <SearchedSupplier>[].obs;

  List<Supplier> searchSuppliers(pattern) {
    final queryBuilder = objectBoxController.supplierBox.query(Supplier_.name
        .startsWith(pattern, caseSensitive: false)
        .or(Supplier_.name.contains(pattern, caseSensitive: false)));
    queryBuilder.order(Supplier_.name);
    return queryBuilder.build().find();
  }

  void addSearchedSupplier(Supplier supplier) {
    objectBoxController.searchedSupplierBox
        .put(SearchedSupplier()..searchedSupplier.target = supplier);
  }

  void deleteSupplier(int id) {
    final query = objectBoxController.searchedSupplierBox.query();
    query.link(SearchedSupplier_.searchedSupplier, Supplier_.id.equals(id));
    query.build().remove();
    objectBoxController.supplierBox.remove(id);
  }

  void deleteSearchedSupplier(int id) {
    objectBoxController.searchedSupplierBox.remove(id);
  }

  @override
  void onReady() {
    super.onReady();
    fetchSearchedSupplier();
  }

  fetchSearchedSupplier() {
    final searchedSupplierBuilder = objectBoxController.searchedSupplierBox
        .query()
      ..order(SearchedSupplier_.datetime, flags: Order.descending);
    searchedSupplierList.bindStream(searchedSupplierBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void openBottomSheet(Supplier supplier) {
    Get.bottomSheet(
        ListView(
          children: [
            SizedBox(height: 20.h),
            BottomSheetRow(
              onDelete: () {
                deleteSupplier(supplier.id!);
                Get.back();
                fetchSearchedSupplier();
              },
            ),
            SizedBox(height: 10.h),
            Center(
              child: AutoSizeText(
                supplier.name ?? " ",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15.h),
            Center(
              child: Padding(
                padding: EdgeInsets.all(3.r),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(1 / 3),
                    1: FlexColumnWidth(2 / 3)
                  },
                  border: TableBorder.all(color: Colors.deepPurple.shade200),
                  children: [
                    if (supplier.shopOrBusinessName != null)
                      TableRow(children: [
                        Heading("shop_or_business_name".tr),
                        Content(supplier.shopOrBusinessName ?? " "),
                      ]),
                    if (supplier.nickName != null)
                      TableRow(children: [
                        Heading("nickname".tr),
                        Content(supplier.nickName ?? " "),
                      ]),
                    if (supplier.phone != null)
                      TableRow(children: [
                        Heading("phone".tr),
                        Content(supplier.phone ?? " "),
                      ]),
                    if (supplier.otherPhone != null &&
                        supplier.otherPhone!.isNotEmpty)
                      TableRow(children: [
                        Heading("alternate_phone".tr),
                        Content(supplier.otherPhone!.map((e) => e).join(',')),
                      ]),
                    if (supplier.address != null)
                      TableRow(children: [
                        Heading("address".tr),
                        Content(supplier.address ?? " "),
                      ]),
                    if (supplier.account != null &&
                        supplier.account!.isNotEmpty)
                      TableRow(children: [
                        Heading("account_number".tr),
                        Content(supplier.account!.map((e) => e).join(','))
                      ])
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 234, 232, 238),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        ignoreSafeArea: false);
  }
}
