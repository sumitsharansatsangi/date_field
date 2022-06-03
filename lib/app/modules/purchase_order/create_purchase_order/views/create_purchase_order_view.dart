import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';
import 'package:app/app/widgets/custom_widget.dart';
import '../controllers/create_purchase_order_controller.dart';

class CreatePurchaseOrderView extends GetView<CreatePurchaseOrderController> {
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
            width: 1.sh > 1.sw ? 0.95.sw : 0.95.sh,
            child: ListView(
              children: [
                SizedBox(height: 20.h),
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
                IconButton(
                    icon: Icon(
                      Icons.add_box_rounded,
                      color: Color(0xFF6400FF),
                    ),
                    onPressed: () {
                      c.purchasedOrderedItems.add(PurchaseOrderItem());
                      c.controllerList.add(TextEditingController());
                    }),
                Obx(
                  () => ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: c.purchasedOrderedItems.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onDoubleTap: () {
                            c.purchasedOrderedItems.removeAt(index);
                            c.controllerList.removeAt(index);
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 150.w,
                                child: DropDownSearchField<ItemVariant>(
                                  items: c.items,
                                  allowCreation: false,
                                  allowDecoration: false,
                                  searchHint: "search_item_here".tr,
                                  notFoundText: "no_item_found".tr,
                                  label: "item".tr,
                                  itemAsString: (item) {
                                    return item != null
                                        ? item.item.target!.name ?? ""
                                        : "";
                                  },
                                  onChanged: (item) {
                                    if (item != null) {
                                      c.purchasedOrderedItems[index].item
                                          .targetId = item.id;
                                    }
                                  },
                                  popupItemBuilder: (context, item, b) {
                                    return SizedBox(
                                        child: ListTile(
                                      title: Column(
                                        children: [
                                          FittedBox(
                                            child: Text(
                                                "${item.item.target!.company.target!.name ?? ""} ${item.item.target!.name ?? ""} ",
                                                style:
                                                    TextStyle(fontSize: 11.sp)),
                                          ),
                                          SizedBox(height: 5.h),
                                          Row(
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                  AutoSizeText(item.color ?? "",
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                  AutoSizeText(item.model ?? "",
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                      item.size.toString(),
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
                                      subtitle: Text(
                                        item.item.target!.alternateName!.first,
                                        style: TextStyle(fontSize: 11.sp),
                                      ),
                                    ));
                                  },
                                ),
                              ),
                              SizedBox(
                                  width: 90.w,
                                  child: CustomTextField(
                                    onChanged: (value) {
                                      if (value.isNumericOnly) {
                                        c.purchasedOrderedItems[index]
                                            .quantity = double.tryParse(value);
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    allowDecoration: false,
                                    controller: c.controllerList[index],
                                    hint: 'Quantity',
                                    labelText: 'Quantity',
                                  )),
                              SizedBox(
                                width: 100.w,
                                child: DropDownSearchField<Unit>(
                                  allowDecoration: false,
                                  label: 'unit'.tr,
                                  searchHint: "search_unit_here".tr,
                                  notFoundText: 'no_unit_found'.tr,
                                  items: c.units,
                                  itemAsString: (Unit? u) => u!.fullName ?? " ",
                                  onChanged: (Unit? unit) {
                                    if (unit != null) {
                                      c.purchasedOrderedItems[index].unit
                                          .targetId = unit.id;
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
                              )
                            ],
                          ),
                        );
                      }),
                ),
                SizedBox(height: 25.h),
                Obx(() => c.isLoading.value
                    ? Center(child: const CircularProgressIndicator())
                    : c.isUpdating.value
                        ? UpdateButton(
                            onPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addPurchaseOrder();
                              }
                            },
                          )
                        : AddButton(
                            onAddPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addPurchaseOrder();
                              }
                            },
                            onAddMorePressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = true;
                                c.addPurchaseOrder();
                              }
                            },
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
