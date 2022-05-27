import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/company_controller.dart';

class CompanyView extends GetView<CompanyController> {
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
                hint: "search_company_here".tr,
                isDeviceConnected: networkController.connectionStatus.value,
                itemBuilder: (context, Company suggestion) {
                  return ListTile(
                    title: AutoSizeText(suggestion.name ?? " ",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleLarge),
                  );
                },
                noItemText: "no_company_found".tr,
                onSuggestionSelected: (Company suggestion) async {
                  c.searchController.clear();
                  c.addSearchedCompany(suggestion);
                  c.openBottomSheet(suggestion);
                },
                suggestionsCallback: (pattern) {
                  return c.searchCompanies(pattern);
                },
              ),
            ],
          ),
        )),
      ),
      body: Obx(() => c.searchedCompanyList.isEmpty
          ? SearchWidget(
              text: 'start_searching_company'.tr,
            )
          : ListView.builder(
              itemCount: c.searchedCompanyList.length,
              itemBuilder: (_, index) {
                final DateTime dateTime = c.searchedCompanyList[index].datetime;
                final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                final String formattedDate = formatter.format(dateTime);
                return ListContainer(
                  child: ListTile(
                    title: AutoSizeText(
                      c.searchedCompanyList[index].searchedCompany.target!
                              .name ??
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
                        c.deleteSearchedCompany(
                            c.searchedCompanyList[index].id!);
                        c.fetchSearchedCompany();
                      },
                    ),
                    onLongPress: () async {
                      await Get.toNamed(Routes.CREATE_COMPANY, arguments: [
                        true,
                        c.searchedCompanyList[index].searchedCompany.target!
                      ]);
                      c.fetchSearchedCompany();
                    },
                    onTap: () => c.openBottomSheet(
                        c.searchedCompanyList[index].searchedCompany.target!),
                  ),
                );
              })),
      floatingActionButton: Column(
        children: [
          Spacer(),
          FloatingButton(
              heroTag: 'list',
              onPressed: () async {
                await Get.toNamed(Routes.LIST_COMPANY);
                c.fetchSearchedCompany();
              },
              text: "view_company_n".tr,
              icon: Icons.menu),
          SizedBox(height: 20.h),
          FloatingButton(
              heroTag: 'add',
              onPressed: () {
                Get.toNamed(Routes.CREATE_COMPANY, arguments: [false]);
              },
              text: "add_company_n".tr,
              icon: Icons.add),
        ],
      ),
    );
  }
}
