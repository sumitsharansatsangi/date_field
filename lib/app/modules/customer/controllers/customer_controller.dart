import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final searchedCustomerList = <SearchedCustomer>[].obs;
  final objectBoxController = Get.find<ObjectBoxController>();

  List<Customer> searchCustomers(pattern) {
    final queryBuilder = objectBoxController.customerBox.query(Customer_.name
        .startsWith(pattern, caseSensitive: false)
        .or(Customer_.name.contains(pattern, caseSensitive: false)));
    queryBuilder.order(Customer_.name);
    return queryBuilder.build().find();
  }

  void addSearchedCustomer(Customer customer) {
    objectBoxController.searchedCustomerBox
        .put(SearchedCustomer()..searchedCustomer.target = customer);
  }

  void deleteCustomer(int id) {
    final query = objectBoxController.searchedCustomerBox.query();
    query.link(SearchedCustomer_.searchedCustomer, Customer_.id.equals(id));
    query.build().remove();
    objectBoxController.customerBox.remove(id);
  }

  void deleteSearchedCustomer(int id) {
    objectBoxController.searchedCustomerBox.remove(id);
  }

  @override
  void onReady() async {
    super.onReady();
    fetchSearchedCustomer();
  }

  fetchSearchedCustomer() {
    final searchedCustomerBuilder = objectBoxController.searchedCustomerBox
        .query()
      ..order(SearchedCustomer_.datetime, flags: Order.descending);
    searchedCustomerList.bindStream(searchedCustomerBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void openBottomSheet(Customer customer) {
    Get.bottomSheet(
        ListView(
          children: [
            SizedBox(height: 20.h),
            BottomSheetRow(
              onDelete: () {
                deleteSearchedCustomer(customer.id!);
                Get.back();
                fetchSearchedCustomer();
              },
            ),
            SizedBox(height: 10.h),
            Center(
              child: AutoSizeText(
                customer.name ?? " ",
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
                    if (customer.nickName != null)
                      TableRow(children: [
                        Heading("nickname".tr),
                        Content(customer.nickName ?? " "),
                      ]),
                    if (customer.phone != null)
                      TableRow(children: [
                        Heading("phone".tr),
                        Content(customer.phone ?? " "),
                      ]),
                    if (customer.otherPhone != null &&
                        customer.otherPhone!.isNotEmpty)
                      TableRow(children: [
                        Heading("alternate_phone".tr),
                        Content(customer.otherPhone!.map((e) => e).join(',')),
                      ]),
                    if (customer.address != null)
                      TableRow(children: [
                        Heading("address".tr),
                        Content(customer.address ?? " "),
                      ]),
                    if (customer.account != null &&
                        customer.account!.isNotEmpty)
                      TableRow(children: [
                        Heading("account_number".tr),
                        Content(customer.account!.map((e) => e).join(','))
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
