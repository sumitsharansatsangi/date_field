import 'package:app/app/data/model.dart';
import 'package:app/app/modules/item_variant/controllers/item_variant_controller.dart';
import 'package:app/app/modules/supplier/controllers/supplier_controller.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PurchaseOrderController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final isLoading = false.obs;
  final searchedOrderList = <SearchedPurchaseOrder>[].obs;
  // final itemController = Get.find<ItemVariantController>();
  // final supplierController = Get.find<SupplierController>();

  List<PurchaseOrder> searchPurchaseOrder(pattern) {
    final queryBuilder = objectBoxController.purchaseOrderBox.query();
    queryBuilder.link(
        PurchaseOrder_.supplier,
        Supplier_.name
            .startsWith(pattern, caseSensitive: false)
            .or(Supplier_.name.contains(pattern, caseSensitive: false)));
    final query = queryBuilder.build();
    List<PurchaseOrder> purchaseOrders = query.find();
    purchaseOrders.sort(
        (a, b) => a.supplier.target!.name!.compareTo(b.supplier.target!.name!));
    return purchaseOrders;
  }

  void addSearchedOrders(PurchaseOrder purchaseOrder) {
    try {
      final searchedPurchaseOrder = SearchedPurchaseOrder()
        ..searchedOrder.target = purchaseOrder;
      objectBoxController.searchedPurchaseOrderBox.put(searchedPurchaseOrder);
    } on Exception {
      errorSnackBar();
    }
  }

  deletePurchaseOrder(int id) {
    final query = objectBoxController.searchedPurchaseOrderBox.query();
    query.link(
        SearchedPurchaseOrder_.searchedOrder, PurchaseOrder_.id.equals(id));
    query.build().remove();
    objectBoxController.purchaseOrderBox.remove(id);
  }

  deleteSearchedPurchaseOrder(int id) {
    objectBoxController.searchedPurchaseOrderBox.remove(id);
  }

  @override
  void onReady() {
    super.onReady();
    fetchSearchedPurchaseOrder();
  }

  fetchSearchedPurchaseOrder() {
    final searchedOrderBuilder = objectBoxController.searchedPurchaseOrderBox
        .query()
      ..order(SearchedPurchaseOrder_.datetime, flags: Order.descending);
    searchedOrderList.bindStream(searchedOrderBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find()));
  }

  void openBottomSheet(PurchaseOrder purchaseOrder) {
    Get.bottomSheet(
        ListView(children: [
          SizedBox(height: 20.h),
          BottomSheetRow(
            onDelete: () {
              deletePurchaseOrder(purchaseOrder.id!);
              Get.back();
              fetchSearchedPurchaseOrder();
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
                    Heading("Supplier".tr),
                    Content(purchaseOrder.supplier.target!.name ?? " "),
                  ]),
                  // TableRow(children: [
                  //   Heading("number_of_item".tr),
                  //   Content(company.items.length.toString()),
                  // ]),
                  // TableRow(children: [
                  //   Heading("number_of_searches".tr),
                  //   Content(company.searches.length.toString()),
                  // ])
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
