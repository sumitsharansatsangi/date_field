import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/supplier_controller.dart';

class SupplierView extends GetView<SupplierController> {
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
                      title: AutoSizeText(suggestion.name ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleLarge),
                      subtitle: AutoSizeText(suggestion.phone ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleMedium),
                      trailing: AutoSizeText(suggestion.nickName ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleSmall));
                },
                noItemText: "no_supplier_found".tr,
                onSuggestionSelected: (Supplier suggestion) {
                  c.searchController.clear();
                  c.addSearchedSupplier(suggestion);
                  c.openBottomSheet(suggestion);
                },
                suggestionsCallback: (pattern) async {
                  return c.searchSuppliers(pattern);
                },
              ),
            ],
          ),
        )),
      ),
      body: Obx(() => c.searchedSupplierList.isEmpty
          ? SearchWidget(text: 'start_searching_supplier'.tr)
          : ListView.builder(
              itemCount: c.searchedSupplierList.length,
              itemBuilder: (_, index) {
                final DateTime dateTime =
                    c.searchedSupplierList[index].datetime;
                final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                final String formattedDate = formatter.format(dateTime);
                return ListContainer(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                            "${c.searchedSupplierList[index].searchedSupplier.target!.name}",
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: Get.textTheme.titleLarge),
                        SizedBox(width: 10.w),
                        AutoSizeText(
                            c.searchedSupplierList[index].searchedSupplier
                                    .target!.nickName ??
                                " ",
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: Get.textTheme.titleSmall),
                        SizedBox()
                      ],
                    ),
                    subtitle: AutoSizeText(formattedDate,
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleMedium),
                    trailing: DeleteButton(
                      onDelete: () {
                        c.deleteSearchedSupplier(
                            c.searchedSupplierList[index].id!);
                        c.fetchSearchedSupplier();
                      },
                    ),
                    onTap: () => c.openBottomSheet(
                        c.searchedSupplierList[index].searchedSupplier.target!),
                    onLongPress: () async {
                      await Get.toNamed(Routes.CREATE_SUPPLIER, arguments: [
                        true,
                        c.searchedSupplierList[index].searchedSupplier.target!
                      ]);
                      c.fetchSearchedSupplier();
                    },
                  ),
                );
              })),
      floatingActionButton: Column(
        children: [
          Spacer(),
          FloatingButton(
              heroTag: 'list',
              onPressed: () async {
                await Get.toNamed(Routes.LIST_SUPPLIER, arguments: [false]);
                c.fetchSearchedSupplier();
              },
              text: "view_supplier_n".tr,
              icon: Icons.menu),
          SizedBox(height: 20.h),
          FloatingButton(
              heroTag: 'add',
              onPressed: () {
                Get.toNamed(Routes.CREATE_SUPPLIER, arguments: [false]);
              },
              text: "add_supplier_n".tr,
              icon: Icons.add),
        ],
      ),
    );
  }
}
