import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/alphabets_scroll.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speed_up_get/speed_up_get.dart';

import '../controllers/list_purchase_order_controller.dart';

class ListPurchaseOrderView extends GetView<ListPurchaseOrderController> {
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
                  noItemText: "no_company_found".tr,
                  onSuggestionSelected: (PurchaseOrder purchaseOrder) async {
                    c.searchController.clear();
                    c.purchaseOrderController.addSearchedOrders(purchaseOrder);
                    c.purchaseOrderController.openBottomSheet(purchaseOrder);
                  },
                  suggestionsCallback: (pattern) {
                    return c.purchaseOrderController
                        .searchPurchaseOrder(pattern);
                  },
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.purchaseOrderList.isEmpty
              ? NoItemWidget(
                  noText: "no_purchase_order".tr,
                  addText: "add_no_purchase_order".tr,
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_PURCHASE_ORDER,
                        arguments: [false]);
                    c.purchaseOrderList.value = c.purchaseOrderController
                        .objectBoxController.purchaseOrderBox
                        .getAll();
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: AlphabetScrollView(
                        list: c.purchaseOrderList
                            .map((e) =>
                                AlphaModel(e, e.supplier.target!.name ?? " "))
                            .toList(),
                        itemBuilder: (_, k, e) {
                          return ListContainer(
                            child: ListTile(
                                onTap: () => c.purchaseOrderController
                                    .openBottomSheet(e.item),
                                onLongPress: () async {
                                  await Get.toNamed(Routes.CREATE_COMPANY,
                                      arguments: [true, e.item]);
                                  c.purchaseOrderList.value = c
                                      .purchaseOrderController
                                      .objectBoxController
                                      .purchaseOrderBox
                                      .getAll();
                                },
                                title: AutoSizeText(e.name,
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: Get.textTheme.titleLarge),
                                trailing: DeleteButton(
                                  onDelete: () {
                                    c.purchaseOrderController
                                        .deletePurchaseOrder(e.item.id!);
                                    c.purchaseOrderList.value = c
                                        .purchaseOrderController
                                        .objectBoxController
                                        .purchaseOrderBox
                                        .getAll();
                                  },
                                )),
                          );
                        },
                      ),
                    )
                  ],
                ),
        ));
  }
}
