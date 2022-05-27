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
import '../controllers/customer_controller.dart';

class CustomerView extends GetView<CustomerController> {
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
                      title: AutoSizeText(suggestion.name ?? " ",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 13.sp)),
                      trailing: AutoSizeText(suggestion.nickName ?? " ",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 13.sp)));
                },
                noItemText: "no_customer_found".tr,
                onSuggestionSelected: (Customer suggestion) {
                  c.searchController.clear();
                  c.addSearchedCustomer(suggestion);
                  c.openBottomSheet(suggestion);
                },
                suggestionsCallback: (pattern) {
                  return c.searchCustomers(pattern);
                },
              ),
            ],
          ),
        )),
      ),
      body: Obx(() => c.searchedCustomerList.isEmpty
          ? SearchWidget(
              text: 'start_searching_customer'.tr,
            )
          : ListView.builder(
              itemCount: c.searchedCustomerList.length,
              itemBuilder: (_, index) {
                final DateTime dateTime =
                    c.searchedCustomerList[index].datetime;
                final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                final String formattedDate = formatter.format(dateTime);

                return ListContainer(
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                            "${c.searchedCustomerList[index].searchedCustomer.target!.name}",
                            style: TextStyle(fontSize: 13.sp)),
                        SizedBox(width: 10.w),
                        Text(
                          c.searchedCustomerList[index].searchedCustomer.target!
                                  .nickName ??
                              " ",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    ),
                    subtitle: Text(formattedDate,
                        style:
                            TextStyle(color: Colors.black54, fontSize: 11.sp)),
                    trailing: DeleteButton(
                      onDelete: () {
                        c.deleteSearchedCustomer(
                            c.searchedCustomerList[index].id);
                        c.fetchSearchedCustomer();
                      },
                    ),
                    onTap: () => c.openBottomSheet(
                        c.searchedCustomerList[index].searchedCustomer.target!),
                    onLongPress: () async {
                      await Get.toNamed(Routes.CREATE_CUSTOMER, arguments: [
                        true,
                        c.searchedCustomerList[index].searchedCustomer.target!
                      ]);
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
                await Get.toNamed(Routes.LIST_CUSTOMER);
                c.fetchSearchedCustomer();
              },
              text: "view_customer_n".tr,
              icon: Icons.menu),
          SizedBox(height: 20.h),
          FloatingButton(
              heroTag: 'add',
              onPressed: () {
                Get.toNamed(Routes.CREATE_CUSTOMER, arguments: [false]);
              },
              text: "add_customer_n".tr,
              icon: Icons.person_add),
        ],
      ),
    );
  }
}
