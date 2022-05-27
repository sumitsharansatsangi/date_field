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
import '../controllers/godown_controller.dart';

class GodownView extends GetView<GodownController> {
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
                      suggestion.name ?? "",
                      stepGranularity: 1.sp,
                      minFontSize: 8.sp,
                      style: Get.textTheme.titleLarge,
                    ),
                  );
                },
                noItemText: "no_godown_found".tr,
                onSuggestionSelected: (Godown suggestion) {
                  c.searchController.clear();
                  c.addSearchedGodown(suggestion);
                  c.openBottomSheet(suggestion);
                },
                suggestionsCallback: (pattern) {
                  return c.searchGodowns(pattern);
                },
              ),
            ],
          ),
        )),
      ),
      body: Obx(() => c.searchedGodownList.isEmpty
          ? SearchWidget(
              text: 'start_searching_godown'.tr,
            )
          : ListView.builder(
              itemCount: c.searchedGodownList.length,
              itemBuilder: (_, index) {
                final DateTime dateTime = c.searchedGodownList[index].datetime;
                final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                final String formattedDate = formatter.format(dateTime);
                return ListContainer(
                  child: ListTile(
                    title: AutoSizeText(
                        c.searchedGodownList[index].searchedGodown.target !=
                                null
                            ? c.searchedGodownList[index].searchedGodown.target!
                                    .name ??
                                ""
                            : "",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleLarge),
                    subtitle: AutoSizeText(formattedDate,
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleMedium),
                    trailing: DeleteButton(
                      onDelete: () {
                        c.deleteSearchedGodown(c.searchedGodownList[index].id!);
                        c.fetchSearchedGodown();
                      },
                    ),
                    onTap: () => c.openBottomSheet(
                        c.searchedGodownList[index].searchedGodown.target!),
                    onLongPress: () async {
                      await Get.toNamed(Routes.CREATE_GODOWN, arguments: [
                        true,
                        c.searchedGodownList[index].searchedGodown.target!
                      ]);
                      c.fetchSearchedGodown();
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
                await Get.toNamed(Routes.LIST_GODOWN);
                c.fetchSearchedGodown();
              },
              text: "view_godown_n".tr,
              icon: Icons.menu),
          SizedBox(height: 20.h),
          FloatingButton(
              heroTag: 'add',
              onPressed: () {
                Get.toNamed(Routes.CREATE_GODOWN, arguments: [false]);
              },
              text: "add_godown_n".tr,
              icon: Icons.add),
        ],
      ),
    );
  }
}
