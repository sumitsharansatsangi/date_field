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
import '../controllers/unit_controller.dart';

class UnitView extends GetView<UnitController> {
  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(AppBar().preferredSize.width,
              AppBar().preferredSize.height * 1.5),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomBack(),
                SearchField(
                  controller: c.searchController,
                  hint: "search_unit_here".tr,
                  isDeviceConnected: networkController.connectionStatus.value,
                  itemBuilder: (context, Unit suggestion) {
                    return ListTile(
                        title: AutoSizeText(
                          suggestion.fullName ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleLarge,
                        ),
                        trailing: AutoSizeText(
                          suggestion.shortName ?? " ",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleMedium,
                        ));
                  },
                  noItemText: "no_unit_found".tr,
                  onSuggestionSelected: (Unit suggestion) {
                    c.searchController.clear();
                    c.addSearchedUnit(suggestion);
                    c.fetchUnitDetails(suggestion.id!);
                    c.openBottomSheet(suggestion);
                  },
                  suggestionsCallback: (pattern) {
                    return c.searchUnits(pattern);
                  },
                ),
              ],
            ),
          ),
        ),
        body: Obx(() => c.searchedUnitList.isEmpty
            ? SearchWidget(text: 'start_searching_unit'.tr)
            : ListView.builder(
                itemCount: c.searchedUnitList.length,
                itemBuilder: (_, index) {
                  final DateTime dateTime = c.searchedUnitList[index].datetime;
                  final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                  final String formattedDate = formatter.format(dateTime);
                  return ListContainer(
                    child: ListTile(
                      onLongPress: () async {
                        await Get.toNamed(Routes.CREATE_UNIT, arguments: [
                          true,
                          c.searchedUnitList[index].searchedUnit.target!
                        ]);
                        c.fetchSearchedUnit();
                      },
                      onTap: () {
                        c.fetchUnitDetails(
                            c.searchedUnitList[index].searchedUnit.targetId);
                        c.openBottomSheet(
                            c.searchedUnitList[index].searchedUnit.target!);
                      },
                      subtitle: AutoSizeText(formattedDate,
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleSmall),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            c.searchedUnitList[index].searchedUnit.target!
                                .fullName!,
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: Get.textTheme.titleLarge,
                          ),
                          SizedBox(width: 10.w),
                          AutoSizeText(
                            c.searchedUnitList[index].searchedUnit.target!
                                .shortName!,
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: Get.textTheme.titleMedium,
                          ),
                          SizedBox()
                        ],
                      ),
                      trailing: DeleteButton(
                        onDelete: () {
                          c.deleteSearchedUnit(c.searchedUnitList[index].id!);
                          c.fetchSearchedUnit();
                        },
                      ),
                    ),
                  );
                })),
        floatingActionButton: Column(
          children: [
            Spacer(),
            FloatingButton(
              heroTag: 'list',
              icon: Icons.menu,
              onPressed: () async {
                await Get.toNamed(Routes.LIST_UNIT);
                c.fetchSearchedUnit();
              },
              text: "view_unit_n".tr,
            ),
            SizedBox(height: 20.h),
            FloatingButton(
              heroTag: 'add',
              icon: Icons.add,
              onPressed: () {
                Get.toNamed(Routes.CREATE_UNIT, arguments: [false]);
              },
              text: "add_unit_n".tr,
            ),
          ],
        ),
      ),
    );
  }
}
