import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
// import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/create_purchased_item_controller.dart';

class CreatePurchasedItemView extends GetView<CreatePurchasedItemController> {
  final godownMultiKey = GlobalKey<DropdownSearchState<String>>();
  final storeRoomMultiKey = GlobalKey<DropdownSearchState<String>>();
  final almirahMultiKey = GlobalKey<DropdownSearchState<String>>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // final networkController = Get.find<NetworkController>();
    return Scaffold(
        appBar: customAppBar(titleText: c.appBarText),
        body: Form(
          key: _formKey,
          child: Center(
              child: SizedBox(
            width: 1.sh > 1.sw ? 0.9.sw : 0.9.sh,
            child: ListView(
              children: [
                SizedBox(height: 10.h),
                DropDownSearchField<ItemVariant>(
                  label: 'item_name'.tr,
                  searchHint: "search_item_here".tr,
                  notFoundText: 'no_item_found'.tr,
                  items: c.items,
                  itemAsString: (ItemVariant? itemVariant) =>
                      itemVariant!.item.target!.name ?? " ",
                  onChanged: (ItemVariant? itemVariant) {
                    if (itemVariant != null) {
                      c.currentItem.value = itemVariant;
                    }
                  },
                  popupItemBuilder: (_, itemVariant, b) {
                    return ListTile(
                      isThreeLine: true,
                      title: Column(
                        children: [
                          AutoSizeText(itemVariant.item.target!.name ?? "",
                              stepGranularity: 1.sp,
                              minFontSize: 8.sp,
                              style: TextStyle(fontSize: 13.sp)),
                          itemVariant.item.target!.alternateName != null
                              ? Wrap(
                                  children: [
                                    for (final name in itemVariant
                                        .item.target!.alternateName!)
                                      AutoSizeText(
                                        name,
                                        stepGranularity: 1.sp,
                                        minFontSize: 8.sp,
                                        style: TextStyle(fontSize: 10.sp),
                                      )
                                  ],
                                  spacing: 2.w,
                                )
                              : SizedBox()
                        ],
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
                                itemVariant.item.target!.company.target!.name ??
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
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_ITEM_VARIANT,
                        arguments: [false]);
                    c.items.value =
                        c.objectBoxController.itemVariantBox.getAll();
                    Get.back();
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                DropDownSearchField<Supplier>(
                  label: 'supplier_name'.tr,
                  searchHint: "search_supplier_here".tr,
                  notFoundText: 'no_supplier_found'.tr,
                  items: c.suppliers,
                  itemAsString: (Supplier? supplier) => supplier!.name ?? " ",
                  onChanged: (Supplier? supplier) {
                    if (supplier != null) {
                      c.currentSupplier.value = supplier;
                    }
                  },
                  popupItemBuilder: (_, supplier, b) {
                    return ListTile(
                      title: AutoSizeText(supplier.name ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 13.sp)),
                      trailing: AutoSizeText(
                        supplier.name ?? "",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    );
                  },
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_SUPPLIER,
                        arguments: [false]);
                    c.suppliers.value =
                        c.objectBoxController.supplierBox.getAll();
                    Get.back();
                  },
                ),
                SizedBox(height: 5.h),
                CustomDateField(
                  labelText: "purchasing_date".tr,
                  hint: DateTime.now().toString(),
                  initialDate: c.purchasedDate,
                  validator: (value) {
                    if (value == null) {
                      return null;
                    } else if (value.isAfter(DateTime.now())) {
                      return "purchasing_date_hint".tr;
                    }
                    return null;
                  },
                  onDateSelected: (DateTime value) {
                    c.purchasedDate = value;
                  },
                ),
                CustomTextField(
                  suffixIcon: SizedBox(
                    width: 150.w,
                    child: DropDownSearchField<Unit>(
                      allowDecoration: false,
                      hint: 'unit'.tr,
                      searchHint: "search_unit_here".tr,
                      notFoundText: 'no_unit_found'.tr,
                      items: c.units,
                      itemAsString: (Unit? u) => u!.fullName ?? " ",
                      onChanged: (Unit? unit) {
                        if (unit != null) {
                          c.sellingPriceUnit.value = unit;
                        }
                      },
                      popupItemBuilder: (_, unit, b) {
                        return ListTile(
                          title: AutoSizeText(unit.fullName ?? "",
                              stepGranularity: 1.sp,
                              minFontSize: 8.sp,
                              style: TextStyle(fontSize: 13.sp)),
                          trailing: AutoSizeText(
                            unit.shortName ?? "",
                            stepGranularity: 1.sp,
                            minFontSize: 8.sp,
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        );
                      },
                      onPressed: () async {
                        await Get.toNamed(Routes.CREATE_UNIT);
                        c.units.value = c.objectBoxController.unitBox.getAll();
                        Get.back();
                      },
                    ),
                  ),
                  controller: controller.purchasingPriceController,
                  labelText: "purchasing_price".tr,
                  hint: "100.00",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'purchasing_price_hint'.tr;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                CustomTextField(
                    suffixIcon: SizedBox(
                      width: 150.w,
                      child: DropDownSearchField<Unit>(
                        allowDecoration: false,
                        hint: 'unit'.tr,
                        searchHint: "search_unit_here".tr,
                        notFoundText: 'no_unit_found'.tr,
                        items: c.units,
                        itemAsString: (Unit? u) => u!.fullName ?? " ",
                        onChanged: (Unit? unit) {
                          if (unit != null) {
                            c.sellingPriceUnit.value = unit;
                          }
                        },
                        popupItemBuilder: (_, unit, b) {
                          return ListTile(
                            title: AutoSizeText(unit.fullName ?? "",
                                stepGranularity: 1.sp,
                                minFontSize: 8.sp,
                                style: TextStyle(fontSize: 13.sp)),
                            trailing: AutoSizeText(
                              unit.shortName ?? "",
                              stepGranularity: 1.sp,
                              minFontSize: 8.sp,
                              style: TextStyle(fontSize: 13.sp),
                            ),
                          );
                        },
                        onPressed: () async {
                          await Get.toNamed(Routes.CREATE_UNIT);
                          c.units.value =
                              c.objectBoxController.unitBox.getAll();
                          Get.back();
                        },
                      ),
                    ),
                    controller: controller.sellingPriceController,
                    labelText: "selling_price".tr,
                    hint: 'selling_price_hint'.tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'selling_price_hint'.tr;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number),
                CustomTextField(
                    suffixIcon: SizedBox(
                      width: 150.w,
                      child: DropDownSearchField<Unit>(
                        allowDecoration: false,
                        hint: 'unit'.tr,
                        searchHint: "search_unit_here".tr,
                        notFoundText: 'no_unit_found'.tr,
                        items: c.units,
                        itemAsString: (Unit? u) => u!.fullName ?? " ",
                        onChanged: (Unit? unit) {
                          if (unit != null) {
                            c.purchasedQuantityUnit.value = unit;
                            c.unitController.addSearchedUnit(unit);
                          }
                        },
                        popupItemBuilder: (_, unit, b) {
                          return ListTile(
                            title: AutoSizeText(unit.fullName ?? "",
                                stepGranularity: 1.sp,
                                minFontSize: 8.sp,
                                style: TextStyle(fontSize: 13.sp)),
                            trailing: AutoSizeText(
                              unit.shortName ?? "",
                              stepGranularity: 1.sp,
                              minFontSize: 8.sp,
                              style: TextStyle(fontSize: 13.sp),
                            ),
                          );
                        },
                        onPressed: () async {
                          await Get.toNamed(Routes.CREATE_UNIT);
                          c.units.value =
                              c.objectBoxController.unitBox.getAll();
                          Get.back();
                        },
                      ),
                    ),
                    controller: c.purchasedQuantityController,
                    labelText: "purchased_quantity".tr,
                    hint: 'purchased_quantity_hint'.tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'purchased_quantity_hint'.tr;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number),

                DropDownMultiSearchField<Godown>(
                  onPressed: () async {
                    await Get.toNamed(Routes.CREATE_GODOWN, arguments: [false]);
                    c.godowns.value = c.objectBoxController.godownBox.getAll();
                    Get.back();
                  },
                  items: c.godowns,
                  multiKey: godownMultiKey,
                  label: "godown".tr,
                  searchHint: "search_godown_here".tr,
                  notFoundText: "no_godown_found".tr,
                  itemAsString: (godown) {
                    if (godown != null) {
                      return godown.name ?? "";
                    }
                    return "";
                  },
                  onChanged: (godowns) {
                    if (godowns != null) {
                      c.selectedGodowns = godowns;
                    }
                  },
                  selectedItems: c.selectedGodowns,
                  popupItemBuilder: (_, godown, b) {
                    return ListTile(
                      title: AutoSizeText(godown.name ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 13.sp)),
                    );
                  },
                ),
                DropDownMultiSearchField<StoreRoom>(
                  label: "store_room".tr,
                  multiKey: storeRoomMultiKey,
                  searchHint: "search_store_room_here".tr,
                  notFoundText: "no_store_room_found".tr,
                  itemAsString: (storeRoom) {
                    if (storeRoom != null) {
                      return storeRoom.name ?? "";
                    }
                    return "";
                  },
                  onChanged: (storeRooms) {
                    if (storeRooms != null) {
                      c.selectedStoreRooms = storeRooms;
                    }
                  },
                  selectedItems: c.selectedStoreRooms,
                  popupItemBuilder: (_, storeRoom, b) {
                    return ListTile(
                      title: AutoSizeText(storeRoom.name ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 14.sp)),
                      subtitle: AutoSizeText(
                          storeRoom.godown.target!.name ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 13.sp)),
                    );
                  },
                ),
                DropDownMultiSearchField<Almirah>(
                  label: "almirah".tr,
                  multiKey: almirahMultiKey,
                  searchHint: "search_almirahy_here".tr,
                  notFoundText: "no_almirah_found".tr,
                  itemAsString: (storeRoom) {
                    if (storeRoom != null) {
                      return storeRoom.name ?? "";
                    }
                    return "";
                  },
                  onChanged: (almirahs) {
                    if (almirahs != null) {
                      c.selectedAlmirahs = almirahs;
                    }
                  },
                  selectedItems: c.almirahs,
                  popupItemBuilder: (_, storeRoom, b) {
                    return ListTile(
                      title: AutoSizeText(storeRoom.name ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 14.sp)),
                      subtitle: AutoSizeText(
                          storeRoom.godown.target!.name ?? "",
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 13.sp)),
                    );
                  },
                ),
                // Obx(() => c.godowns.isEmpty
                //     ? SizedBox()
                //     : CustomDropDownField(
                //         items: c.godowns
                //             .map((item) => DropdownMenuItem<Godown>(
                //                   value: item,
                //                   child: AutoSizeText(
                //                     item.name ?? " ",
                //                     style: TextStyle(
                //                       fontSize: 13.sp,
                //                       color: Color.fromARGB(255, 7, 1, 32),
                //                     ),
                //                   ),
                //                 ))
                //             .toList(),
                //         value: c.godowns.first,
                //         onChanged: (Godown? value) {
                //           c.fetchStoreRoom(value!.id!);
                //         },
                //       )),
                // Obx(() => c.storeRooms.isEmpty
                //     ? SizedBox()
                //     : CustomDropDownField(
                //         items: c.storeRooms
                //             .map((item) => DropdownMenuItem<StoreRoom>(
                //                   value: item,
                //                   child: AutoSizeText(
                //                     item.name ?? " ",
                //                     style: TextStyle(
                //                       fontSize: 13.sp,
                //                       color: Color.fromARGB(255, 7, 1, 32),
                //                     ),
                //                   ),
                //                 ))
                //             .toList(),
                //         value: c.storeRooms.first,
                //         onChanged: (StoreRoom? value) {
                //           c.fetchAlmirah(value!.id!);
                //         },
                //       )),
                // Obx(() => c.items.isEmpty
                //     ? SizedBox()
                //     : Container(
                //         margin: EdgeInsets.symmetric(vertical: 8.h),
                //         child: MultiSelectDialogField<Almirah>(
                //           confirmText: Text("confirm".tr),
                //           cancelText: Text("cancel".tr),
                //           items: c.items,
                //           title: Text("almirah".tr),
                //           selectedColor: Color.fromARGB(255, 96, 33, 243),
                //           decoration: BoxDecoration(
                //             color: Color.fromARGB(255, 236, 234, 250),
                //             borderRadius: BorderRadius.all(Radius.circular(4)),
                //             border: Border.all(
                //               // color: Color.fromARGB(255, 107, 33, 243),
                //               width: 1,
                //             ),
                //           ),
                //           buttonIcon: Icon(
                //             Icons.book,
                //             color: Colors.deepPurple,
                //           ),
                //           buttonText: Text(
                //             "choose_almirah".tr,
                //             style: TextStyle(
                //               fontSize: 13.sp,
                //             ),
                //           ),
                //           onConfirm: (results) {
                //             c.currentAlmirah.addAll(results);
                //           },
                //         ),
                //       )),
                CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: c.rowController,
                    labelText: '${'row'.tr}:',
                    hint: 'row_hint'.tr,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.removeAllWhitespace.isEmpty) {
                        return null;
                      } else if (!value.isNumericOnly) {
                        return 'row_hint'.tr;
                      }
                      return null;
                    }),
                CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: c.columnController,
                    labelText: '${'column'.tr}:',
                    hint: 'column_hint'.tr,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.removeAllWhitespace.isEmpty) {
                        return null;
                      } else if (!value.isNumericOnly) {
                        return 'column_hint'.tr;
                      }
                      return null;
                    }),
                SizedBox(height: 10.h),
                Obx(() => c.isLoading.value
                    ? Center(child: const CircularProgressIndicator())
                    : c.isUpdating.value
                        ? UpdateButton(
                            onPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addPurchasedItem();
                              }
                            },
                          )
                        : AddButton(
                            onAddPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addPurchasedItem();
                              }
                            },
                            onAddMorePressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = true;
                                c.addPurchasedItem();
                              }
                            },
                          )),
                SizedBox(height: 30.h)
              ],
            ),
          )),
        ));
  }
}
