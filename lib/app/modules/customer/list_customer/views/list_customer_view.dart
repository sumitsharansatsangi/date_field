import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/alphabets_scroll.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:text_icon/text_icon.dart';

import '../../../../data/model.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/list_customer_controller.dart';

class ListCustomerView extends GetView<ListCustomerController> {
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
                  hint: "search_customer_here".tr,
                  isDeviceConnected: networkController.connectionStatus.value,
                  itemBuilder: (context, Customer suggestion) {
                    return ListTile(
                        title: AutoSizeText(suggestion.name ?? "",
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: Get.textTheme.titleLarge),
                        subtitle: Text(suggestion.nickName ?? " ",
                            style: Get.textTheme.titleSmall));
                  },
                  noItemText: "no_customer_found".tr,
                  onSuggestionSelected: (Customer suggestion) {
                    c.searchController.clear();
                    c.customerController.addSearchedCustomer(suggestion);
                    c.customerController.openBottomSheet(suggestion);
                  },
                  suggestionsCallback: (pattern) {
                    return c.customerController.searchCustomers(pattern);
                  },
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.customerList.isEmpty
              ? NoItemWidget(
                  noText: "no_customer".tr,
                  addText: "add_no_customer".tr,
                  onPressed: () {
                    Get.toNamed(Routes.CREATE_CUSTOMER, arguments: [false]);
                    c.customerList.value = c
                        .customerController.objectBoxController.customerBox
                        .getAll();
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: AlphabetScrollView(
                        list: c.customerList
                            .map((e) => AlphaModel(e, e.name ?? " "))
                            .toList(),
                        itemBuilder: (_, k, e) {
                          return ListContainer(
                            child: ListTile(
                              onTap: () {
                                c.customerController.openBottomSheet(e.item);
                              },
                              onLongPress: () async {
                                await Get.toNamed(Routes.CREATE_CUSTOMER,
                                    arguments: [true, e.item]);
                                c.customerList.value = c.customerController
                                    .objectBoxController.customerBox
                                    .getAll();
                              },
                              title: AutoSizeText(e.name,
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: Get.textTheme.titleLarge),
                              subtitle: AutoSizeText(e.item.nickName ?? " ",
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: Get.textTheme.titleSmall),
                              trailing: DeleteButton(
                                onDelete: () {
                                  c.customerController
                                      .deleteCustomer(e.item.id!);
                                  c.customerList.value = c.customerController
                                      .objectBoxController.customerBox
                                      .getAll();
                                },
                              ),
                              leading: ProfilePicture(
                                name: e.name,
                                radius: 30.r,
                                fontsize: 21.sp,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
        ));
  }
}
