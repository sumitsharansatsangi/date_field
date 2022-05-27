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
import '../controllers/almirah_controller.dart';

class AlmirahView extends GetView<AlmirahController> {
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
                  hint: "search_almirah_here".tr,
                  noItemText: "no_almirah_found".tr,
                  isDeviceConnected: networkController.connectionStatus.value,
                  suggestionsCallback: (pattern) {
                    return c.searchAlmirahs(pattern);
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
                    c.openBottomSheet(suggestion);
                  },
                  controller: c.searchController),
            ],
          ),
        )),
      ),
      body: Obx(() => c.searchedAlmirahList.isEmpty
          ? SearchWidget(text: 'start_searching_almirah'.tr)
          : ListView.builder(
              itemCount: c.searchedAlmirahList.length,
              itemBuilder: (_, index) {
                final DateTime dateTime = c.searchedAlmirahList[index].datetime;
                final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                final String formattedDate = formatter.format(dateTime);
                final almirah =
                    c.searchedAlmirahList[index].searchedAlmirah.target!;
                return ListContainer(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          almirah.name ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleLarge,
                        ),
                        AutoSizeText(
                          almirah.room.target != null
                              ? almirah.room.target!.name ?? ""
                              : almirah.godown.target != null
                                  ? almirah.godown.target!.name ?? ""
                                  : " ",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    subtitle: AutoSizeText(formattedDate,
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleSmall),
                    trailing: DeleteButton(
                      onDelete: () {
                        c.deleteSearchedAlmirah(
                            c.searchedAlmirahList[index].id!);
                        c.fetchSearchedAlmirah();
                      },
                    ),
                    onTap: () => c.openBottomSheet(
                        c.searchedAlmirahList[index].searchedAlmirah.target!),
                    onLongPress: () async {
                      await Get.toNamed(Routes.CREATE_ALMIRAH, arguments: [
                        true,
                        c.searchedAlmirahList[index].searchedAlmirah.target!
                      ]);
                      c.fetchSearchedAlmirah();
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
                await Get.toNamed(Routes.LIST_ALMIRAH);
                c.fetchSearchedAlmirah();
              },
              text: "view_almirah_n".tr,
              icon: Icons.menu),
          SizedBox(height: 20.h),
          FloatingButton(
              heroTag: 'add',
              onPressed: () {
                Get.toNamed(Routes.CREATE_ALMIRAH, arguments: [false]);
              },
              text: "add_almirah_n".tr,
              icon: Icons.add),
        ],
      ),
    );
  }
}
