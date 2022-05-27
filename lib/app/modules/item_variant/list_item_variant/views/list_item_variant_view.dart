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
import 'package:text_icon/text_icon.dart';
import '../controllers/list_item_variant_controller.dart';

class ListItemVariantView extends GetView<ListItemVariantController> {
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
                  itemBuilder: (context, ItemVariant suggestion) {
                    return ListTile(
                      title: AutoSizeText(
                        suggestion.item.target!.name!,
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      subtitle: Row(
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
                              AutoSizeText(suggestion.color ?? "",
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
                              AutoSizeText(suggestion.model ?? "",
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
                              AutoSizeText(suggestion.size.toString(),
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
                                'Company',
                                stepGranularity: 1.sp,
                                minFontSize: 8.sp,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                              AutoSizeText(
                                suggestion.item.target!.company.target!.name ??
                                    "",
                                stepGranularity: 1.sp,
                                minFontSize: 8.sp,
                                style: TextStyle(fontSize: 11.sp),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  noItemText: "no_item_variant_found".tr,
                  onSuggestionSelected: (ItemVariant suggestion) {
                    c.searchController.clear();
                    c.itemController.addSearchedItemVariant(suggestion);
                    c.itemController.openBottomSheet(suggestion);
                  },
                  suggestionsCallback: (pattern) {
                    return c.itemController.searchItemVariants(pattern);
                  },
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.itemList.isEmpty
              ? NoItemWidget(
                  noText: "no_item_variant".tr,
                  addText: "add_no_item_variant".tr,
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_ITEM_VARIANT,
                        arguments: [false]);
                    c.itemList.value =
                        c.objectBoxController.itemVariantBox.getAll();
                  },
                )
              : Column(
                  children: [
                    Expanded(
                        child: Obx(
                      () => AlphabetScrollView(
                        list: c.itemList
                            .map((e) => AlphaModel(
                                  e,
                                  e.item.target!.name ?? " ",
                                ))
                            .toList(),
                        itemBuilder: (_, k, e) {
                          return ListContainer(
                            child: ListTile(
                                style: ListTileStyle.drawer,
                                onLongPress: () async {
                                  await Get.toNamed(Routes.CREATE_ITEM,
                                      arguments: [true, e.item]);
                                  c.itemList.value = c
                                      .objectBoxController.itemVariantBox
                                      .getAll();
                                },
                                onTap: () =>
                                    c.itemController.openBottomSheet(e.item),
                                title: AutoSizeText(
                                  " ${e.item.item.target!.company.target!.name ?? ""}  ${e.name}",
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        AutoSizeText(e.item.color,
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
                                        AutoSizeText(e.item.model,
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
                                        AutoSizeText(e.item.size.toString(),
                                            stepGranularity: 1.sp,
                                            minFontSize: 8.sp,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                                leading: ProfilePicture(
                                  name: e.name,
                                  radius: 20.r,
                                  fontsize: 21.sp,
                                ),
                                trailing: DeleteButton(
                                  onDelete: () {
                                    c.itemController
                                        .deleteItemVariant(e.item.id!);
                                    c.itemList.value = c
                                        .objectBoxController.itemVariantBox
                                        .getAll();
                                  },
                                )),
                          );
                        },
                      ),
                    ))
                  ],
                ),
        ));
  }
}
