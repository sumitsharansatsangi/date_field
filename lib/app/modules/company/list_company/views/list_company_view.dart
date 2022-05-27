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

import '../controllers/list_company_controller.dart';

class ListCompanyView extends GetView<ListCompanyController> {
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
                    c.companyController.addSearchedCompany(suggestion);
                    c.companyController.openBottomSheet(suggestion);
                  },
                  suggestionsCallback: (pattern) {
                    return c.companyController.searchCompanies(pattern);
                  },
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.companyList.isEmpty
              ? NoItemWidget(
                  noText: "no_company".tr,
                  addText: "add_no_company".tr,
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_COMPANY,
                        arguments: [false]);
                    c.companyList.value = c
                        .companyController.objectBoxController.companyBox
                        .getAll();
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: AlphabetScrollView(
                        list: c.companyList
                            .map((e) => AlphaModel(e, e.name ?? " "))
                            .toList(),
                        itemBuilder: (_, k, e) {
                          return ListContainer(
                            child: ListTile(
                                onTap: () =>
                                    c.companyController.openBottomSheet(e.item),
                                onLongPress: () async {
                                  await Get.toNamed(Routes.CREATE_COMPANY,
                                      arguments: [true, e.item]);
                                  c.companyList.value = c.companyController
                                      .objectBoxController.companyBox
                                      .getAll();
                                },
                                title: AutoSizeText(e.name,
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: Get.textTheme.titleLarge),
                                trailing: DeleteButton(
                                  onDelete: () {
                                    c.companyController
                                        .deleteCompany(e.item.id!);
                                    c.companyList.value = c.companyController
                                        .objectBoxController.companyBox
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
