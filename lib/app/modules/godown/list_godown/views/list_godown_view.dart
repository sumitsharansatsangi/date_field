import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/alphabets_scroll.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speed_up_get/speed_up_get.dart';

import '../controllers/list_godown_controller.dart';

class ListGodownView extends GetView<ListGodownController> {
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
                  hint: "search_godown_here".tr,
                  isDeviceConnected: networkController.connectionStatus.value,
                  itemBuilder: (context, Godown suggestion) {
                    return ListTile(
                      title: AutoSizeText(
                        suggestion.name ?? " ",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleLarge,
                      ),
                    );
                  },
                  noItemText: "no_godown_found".tr,
                  onSuggestionSelected: (Godown suggestion) {
                    c.searchController.clear();
                    c.godownController.addSearchedGodown(suggestion);
                    c.godownController.openBottomSheet(suggestion);
                  },
                  suggestionsCallback: (pattern) {
                    return c.godownController.searchGodowns(pattern);
                  },
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.godownList.isEmpty
              ? NoItemWidget(
                  noText: "no_godown".tr,
                  addText: "add_no_godown".tr,
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_GODOWN, arguments: [false]);
                    c.godownList.value =
                        c.objectBoxController.godownBox.getAll();
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: AlphabetScrollView(
                        list: c.godownList
                            .map((e) => AlphaModel(e, e.name ?? " "))
                            .toList(),
                        itemBuilder: (_, k, e) {
                          return ListContainer(
                            child: ListTile(
                                onLongPress: () async {
                                  await Get.toNamed(Routes.CREATE_GODOWN,
                                      arguments: [true, e.item]);
                                  c.godownList.value =
                                      c.objectBoxController.godownBox.getAll();
                                },
                                onTap: () {
                                  c.godownController.openBottomSheet(e.item);
                                },
                                title: AutoSizeText(e.name,
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: Get.textTheme.titleLarge),
                                trailing: DeleteButton(
                                  onDelete: () {
                                    c.godownController.deleteGodown(e.item.id!);
                                    c.godownList.value = c
                                        .objectBoxController.godownBox
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
