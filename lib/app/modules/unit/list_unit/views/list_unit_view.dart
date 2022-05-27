import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/alphabets_scroll.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';

import '../controllers/list_unit_controller.dart';

class ListUnitView extends GetView<ListUnitController> {
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
                    c.unitController.addSearchedUnit(suggestion);
                    c.unitController.fetchUnitDetails(suggestion.id!);
                    c.unitController.openBottomSheet(suggestion);
                  },
                  suggestionsCallback: (pattern) {
                    return c.unitController.searchUnits(pattern);
                  },
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.unitList.isEmpty
              ? NoItemWidget(
                  noText: "no_unit".tr,
                  addText: "add_no_unit".tr,
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_UNIT, arguments: [false]);
                    c.unitList.value = c.objectBoxController.unitBox.getAll();
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: AlphabetScrollView(
                        list: [
                          for (final unit in c.unitList)
                            AlphaModel(unit, unit.fullName ?? "")
                        ],
                        itemBuilder: (_, k, e) {
                          return ListContainer(
                            child: ListTile(
                                onLongPress: () async {
                                  await Get.toNamed(Routes.CREATE_UNIT,
                                      arguments: [true, e.item]);
                                  c.unitList.value =
                                      c.objectBoxController.unitBox.getAll();
                                },
                                onTap: () {
                                  c.unitController.fetchUnitDetails(e.item.id!);
                                  c.unitController.openBottomSheet(e.item);
                                },
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.name,
                                        style: Get.textTheme.titleLarge),
                                    SizedBox(width: 10.w),
                                    Text(e.item.shortName,
                                        style: Get.textTheme.titleMedium),
                                    SizedBox()
                                  ],
                                ),
                                trailing: DeleteButton(
                                  onDelete: () {
                                    c.unitController.deleteUnit(e.item.id!);
                                    c.unitList.value =
                                        c.objectBoxController.unitBox.getAll();
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
