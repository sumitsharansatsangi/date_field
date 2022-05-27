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
import 'package:text_icon/text_icon.dart';

import '../controllers/list_supplier_controller.dart';

class ListSupplierView extends GetView<ListSupplierController> {
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
                  hint: "search_supplier_here".tr,
                  isDeviceConnected: networkController.connectionStatus.value,
                  itemBuilder: (context, Supplier suggestion) {
                    return ListTile(
                      title: AutoSizeText(
                        suggestion.name ?? "",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleLarge,
                      ),
                      trailing: AutoSizeText(
                        suggestion.phone ?? "",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleMedium,
                      ),
                      subtitle: AutoSizeText(suggestion.nickName ?? " ",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleSmall),
                    );
                  },
                  noItemText: "no_supplier_found".tr,
                  onSuggestionSelected: (Supplier suggestion) {
                    c.searchController.clear();
                    c.supplierController.addSearchedSupplier(suggestion);
                    c.supplierController.openBottomSheet(suggestion);
                  },
                  suggestionsCallback: (pattern) {
                    return c.supplierController.searchSuppliers(pattern);
                  },
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.supplierList.isEmpty
              ? NoItemWidget(
                  noText: "no_supplier".tr,
                  addText: "add_no_supplier".tr,
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_SUPPLIER,
                        arguments: [false]);
                    c.supplierList.value =
                        c.objectBoxController.supplierBox.getAll();
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: AlphabetScrollView(
                        list: [
                          for (final supplier in c.supplierList)
                            AlphaModel(supplier, supplier.name ?? " ")
                        ],
                        itemBuilder: (_, k, e) {
                          return ListContainer(
                            child: ListTile(
                                onLongPress: () async {
                                  await Get.toNamed(Routes.CREATE_SUPPLIER,
                                      arguments: [true, e.item]);
                                  c.supplierList.value = c
                                      .objectBoxController.supplierBox
                                      .getAll();
                                },
                                onTap: () {
                                  c.supplierController.openBottomSheet(e.item);
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                        e.item.shopOrBusinessName ?? "",
                                        stepGranularity: 1.sp,
                                        minFontSize: 8.sp,
                                        style: Get.textTheme.titleLarge),
                                    AutoSizeText(e.name,
                                        stepGranularity: 1.sp,
                                        minFontSize: 8.sp,
                                        style: Get.textTheme.titleLarge),
                                    AutoSizeText(
                                      e.item.phone ?? "",
                                      stepGranularity: 1.sp,
                                      minFontSize: 8.sp,
                                      style: Get.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                                subtitle: AutoSizeText(e.item.nickName ?? " ",
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: Get.textTheme.titleSmall),
                                leading: ProfilePicture(
                                  name: e.name,
                                  radius: 20.r,
                                  fontsize: 15.sp,
                                ),
                                trailing: DeleteButton(
                                  onDelete: () {
                                    c.supplierController
                                        .deleteSupplier(e.item.id!);
                                    c.supplierList.value = c
                                        .objectBoxController.supplierBox
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
