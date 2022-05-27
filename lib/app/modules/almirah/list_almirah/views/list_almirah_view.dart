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

import '../controllers/list_almirah_controller.dart';

class ListAlmirahView extends GetView<ListAlmirahController> {
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
                  noItemText: "no_almirah_found".tr,
                  hint: "search_almirah_here".tr,
                  isDeviceConnected: networkController.connectionStatus.value,
                  suggestionsCallback: (pattern) {
                    return c.almirahController.searchAlmirahs(pattern);
                  },
                  itemBuilder: (context, Almirah almirah) {
                    return ListTile(
                      title: AutoSizeText(almirah.name ?? " ",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleLarge),
                      subtitle: AutoSizeText(
                        almirah.room.target != null
                            ? almirah.room.target!.name ?? ""
                            : almirah.godown.target != null
                                ? almirah.godown.target!.name ?? ""
                                : " ",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleSmall,
                      ),
                    );
                  },
                  onSuggestionSelected: (Almirah suggestion) async {
                    c.searchController.clear();
                    c.addSearchedAlmirah(suggestion);
                    c.almirahController.openBottomSheet(suggestion);
                  },
                  controller: c.searchController),
            ],
          ),
        )),
      ),
      body: Obx(() => c.almirahList.isEmpty
          ? NoItemWidget(
              noText: "no_almirah".tr,
              addText: "add_no_almirah".tr,
              onPressed: () async {
                await Get.toNamed(Routes.CREATE_ALMIRAH, arguments: [false]);
                c.almirahList.value =
                    c.almirahController.objectBoxController.almirahBox.getAll();
              },
            )
          : Column(
              children: [
                Expanded(
                  child: AlphabetScrollView(
                    list: c.almirahList
                        .map((e) => AlphaModel(e, e.name ?? " "))
                        .toList(),
                    itemBuilder: (_, k, e) {
                      return ListContainer(
                        child: ListTile(
                          onTap: () {
                            c.almirahController.openBottomSheet(e.item);
                          },
                          onLongPress: () async {
                            await Get.toNamed(Routes.CREATE_ALMIRAH,
                                arguments: [true, e.item]);
                            c.almirahList.value = c.almirahController
                                .objectBoxController.almirahBox
                                .getAll();
                          },
                          trailing: DeleteButton(
                            onDelete: () {
                              c.almirahController.deleteAlmirah(e.item.id!);
                              c.almirahList.value = c.almirahController
                                  .objectBoxController.almirahBox
                                  .getAll();
                            },
                          ),
                          title: AutoSizeText(
                            e.name,
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: Get.textTheme.titleLarge,
                          ),
                          subtitle: AutoSizeText(
                            e.item.room.target != null
                                ? e.item.room.target!.name ?? ""
                                : e.item.godown.target != null
                                    ? e.item.godown.target!.name ?? ""
                                    : " ",
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: Get.textTheme.titleSmall,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            )),
    );
  }
}
