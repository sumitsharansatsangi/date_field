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
import '../controllers/item_variant_controller.dart';

class ItemVariantView extends GetView<ItemVariantController> {
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
                hint: "search_item_variant_here".tr,
                isDeviceConnected: networkController.connectionStatus.value,
                itemBuilder: (context, ItemVariant itemVariant) {
                  final item = itemVariant.item.target!;
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          "${item.company.target!.name ?? ""} ${item.name ?? ""} ",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                AutoSizeText(
                                  'Color',
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                AutoSizeText(itemVariant.color ?? "",
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                    )),
                              ],
                            ),
                            Column(
                              children: [
                                AutoSizeText(
                                  'Model',
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                AutoSizeText(itemVariant.model ?? "",
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                    )),
                              ],
                            ),
                            Column(
                              children: [
                                AutoSizeText(
                                  'Size',
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                AutoSizeText(itemVariant.size.toString(),
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    subtitle: itemVariant.item.target!.alternateName != null
                        ? Wrap(
                            children: [
                              for (final name
                                  in itemVariant.item.target!.alternateName!)
                                AutoSizeText(name,
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: TextStyle(fontSize: 10.sp))
                            ],
                            spacing: 2.w,
                          )
                        : SizedBox(),
                  );
                },
                noItemText: "no_item_variant_found".tr,
                onSuggestionSelected: (ItemVariant suggestion) {
                  c.searchController.clear();
                  c.addSearchedItemVariant(suggestion);
                  c.openBottomSheet(suggestion);
                },
                suggestionsCallback: (pattern) {
                  return c.searchItemVariants(pattern);
                },
              ),
            ],
          ),
        )),
      ),
      body: Obx(() => c.searchedItemVariantList.isEmpty
          ? SearchWidget(text: 'start_searching_item_variant'.tr)
          : ListView.builder(
              itemCount: c.searchedItemVariantList.length,
              itemBuilder: (_, index) {
                final DateTime dateTime =
                    c.searchedItemVariantList[index].datetime;
                final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                final String formattedDate = formatter.format(dateTime);
                return Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(bottom: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius:
                        BorderRadius.circular(30), //border corner radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple
                            .withOpacity(0.5), //color of shadow
                        spreadRadius: 5.sp, //spread radius
                        blurRadius: 7.sp, // blur radius
                        offset:
                            const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    style: ListTileStyle.drawer,
                    tileColor: Colors.deepPurple.shade50,
                    isThreeLine: true,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5.h),
                        AutoSizeText(
                            "  ${c.searchedItemVariantList[index].searchedItemVariant.target!.item.target!.company.target!.name ?? ""}  ${c.searchedItemVariantList[index].searchedItemVariant.target!.item.target!.name ?? ""}",
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold, // 36, 6 108,100
                                color: Color.fromARGB(255, 32, 2, 73))),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                AutoSizeText(
                                  'Color',
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                AutoSizeText(
                                    c
                                            .searchedItemVariantList[index]
                                            .searchedItemVariant
                                            .target!
                                            .color ??
                                        "",
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                    )),
                              ],
                            ),
                            Column(
                              children: [
                                AutoSizeText(
                                  'Model',
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                AutoSizeText(
                                    c
                                            .searchedItemVariantList[index]
                                            .searchedItemVariant
                                            .target!
                                            .model ??
                                        "",
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                    )),
                              ],
                            ),
                            Column(
                              children: [
                                AutoSizeText(
                                  'Size',
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                AutoSizeText(
                                    c.searchedItemVariantList[index]
                                        .searchedItemVariant.target!.size
                                        .toString(),
                                    stepGranularity: 1.sp,
                                    minFontSize: 8.sp,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    subtitle: AutoSizeText(formattedDate,
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style:
                            TextStyle(color: Colors.black54, fontSize: 11.sp)),
                    trailing: DeleteButton(
                      onDelete: () {
                        c.deleteSearchedItemVariant(
                            c.searchedItemVariantList[index].id!);
                        c.fetchSearchedItemVariant();
                      },
                    ),
                    onTap: () => c.openBottomSheet(c
                        .searchedItemVariantList[index]
                        .searchedItemVariant
                        .target!),
                    onLongPress: () {
                      Get.toNamed(Routes.CREATE_ITEM, arguments: [
                        true,
                        c.searchedItemVariantList[index].searchedItemVariant
                            .target!
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
                await Get.toNamed(Routes.LIST_ITEM_VARIANT);
                c.fetchSearchedItemVariant();
              },
              text: "view_item_variant_n".tr,
              icon: Icons.menu),
          SizedBox(height: 20),
          FloatingButton(
              heroTag: 'add',
              onPressed: () {
                Get.toNamed(Routes.CREATE_ITEM_VARIANT, arguments: [false]);
              },
              text: "add_item_variant_n".tr,
              icon: Icons.add),
        ],
      ),
    );
  }
}
