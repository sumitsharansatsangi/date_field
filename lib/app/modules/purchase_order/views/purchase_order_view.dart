import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';

import '../controllers/purchase_order_controller.dart';

class PurchaseOrderView extends GetView<PurchaseOrderController> {
  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize * 1.5,
        child: SafeArea(
            child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomBack(),
              SearchField(
                controller: c.searchController,
                hint: "search_purchase_order_here".tr,
                isDeviceConnected: networkController.connectionStatus.value,
                itemBuilder: (context, PurchaseOrder purchaseOrder) {
                  return ListTile(
                    title: AutoSizeText(
                        purchaseOrder.supplier.target!.name ?? " ",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleLarge),
                  );
                },
                noItemText: "no_purchase_order_found".tr,
                onSuggestionSelected: (PurchaseOrder purchaseOrder) async {
                  c.searchController.clear();
                  c.addSearchedOrders(purchaseOrder);
                  c.openBottomSheet(purchaseOrder);
                },
                suggestionsCallback: (pattern) {
                  return c.searchPurchaseOrder(pattern);
                },
              ),
            ],
          ),
        )),
      ),
      body: Obx(() => c.searchedOrderList.isEmpty
          ? SearchWidget(
              text: 'start_searching_purchase_order'.tr,
            )
          : ListView.builder(
              itemCount: c.searchedOrderList.length,
              itemBuilder: (_, index) {
                final DateTime dateTime = c.searchedOrderList[index].datetime;
                final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                final String formattedDate = formatter.format(dateTime);
                return ListContainer(
                  child: ListTile(
                    title: AutoSizeText(
                      c.searchedOrderList[index].searchedOrder.target!.supplier
                              .target!.name ??
                          "",
                      stepGranularity: 1.sp,
                      minFontSize: 8.sp,
                      style: Get.textTheme.titleLarge,
                    ),
                    subtitle: AutoSizeText(formattedDate,
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleSmall),
                    trailing: DeleteButton(
                      onDelete: () {
                        c.deleteSearchedPurchaseOrder(
                            c.searchedOrderList[index].id!);
                        c.fetchSearchedPurchaseOrder();
                      },
                    ),
                    onLongPress: () async {
                      await Get.toNamed(Routes.CREATE_PURCHASE_ORDER,
                          arguments: [
                            true,
                            c.searchedOrderList[index].searchedOrder.target!
                          ]);
                      c.fetchSearchedPurchaseOrder();
                    },
                    onTap: () => c.openBottomSheet(
                        c.searchedOrderList[index].searchedOrder.target!),
                  ),
                );
              })),
      floatingActionButton: Column(
        children: [
          Spacer(),
          FloatingButton(
              heroTag: 'list',
              onPressed: () async {
                await Get.toNamed(Routes.LIST_PURCHASE_ORDER);
                c.fetchSearchedPurchaseOrder();
              },
              text: "view_purchase_order_n".tr,
              icon: Icons.menu),
          SizedBox(height: 20.h),
          FloatingButton(
              heroTag: 'add',
              onPressed: () {
                Get.toNamed(Routes.CREATE_PURCHASE_ORDER, arguments: [false]);
              },
              text: "add_purchase_order_n".tr,
              icon: Icons.add),
        ],
      ),
    );
  }
}
