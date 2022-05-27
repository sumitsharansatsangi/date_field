import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speed_up_get/speed_up_get.dart';
import '../controllers/create_item_variant_controller.dart';

class CreateItemVariantView extends GetView<CreateItemVariantController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Gradient g1 = LinearGradient(
    colors: [
      Color(0xFF7F00FF),
      Color(0xFFE100FF),
    ],
  );
  final Gradient g2 = LinearGradient(
    colors: [
      Color.fromARGB(255, 118, 42, 194),
      Color.fromARGB(255, 176, 67, 226),
    ],
  );
  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();
    return Scaffold(
        appBar: customAppBar(
          titleText: c.appBarText,
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              width: 1.sh > 1.sw ? 0.9.sw : 0.9.sh,
              child: ListView(children: [
                SizedBox(height: 15.h),
                DropDownSearchField<Item>(
                    items: c.items,
                    searchHint: 'search_item_here'.tr,
                    notFoundText: "no_item_found".tr,
                    label: 'item'.tr,
                    itemAsString: (item) {
                      if (item != null) {
                        return item.name ?? "";
                      }
                      return "";
                    },
                    onChanged: (Item? item) {
                      if (item != null) {
                        c.currentItem.value = item;
                        c.itemController.addSearchedItem(item);
                        c.itemNameController.text = item.name ?? " ";
                      }
                    },
                    onPressed: () async {
                      await Get.toNamed(Routes.CREATE_ITEM, arguments: [false]);
                      c.items.value = c.objectBoxController.itemBox.getAll();
                      Get.back();
                    },
                    popupItemBuilder: (_, item, b) {
                      return ListTile(
                        title: Text(item.name ?? " "),
                        subtitle: Text(item.company.target!.name ?? " "),
                      );
                    }),
                TextFieldWidget(
                    labelText: "color".tr,
                    isDeviceConnected: networkController.connectionStatus.value,
                    hint: "Blue",
                    textEditingController: c.colorController),
                TextFieldWidget(
                    labelText: "model".tr,
                    isDeviceConnected: networkController.connectionStatus.value,
                    hint: "Deluxe",
                    textEditingController: c.modelController),
                TextFieldWidget(
                    labelText: "size".tr,
                    isDeviceConnected: networkController.connectionStatus.value,
                    hint: "4 inch",
                    textEditingController: c.sizeController),
                TextFieldWidget(
                  suffixIcon: SizedBox(
                    width: 150.w,
                    child: DropDownSearchField<Unit>(
                        allowDecoration: false,
                        onPressed: () async {
                          await Get.toNamed(Routes.CREATE_UNIT,
                              arguments: [false]);
                          c.units.value =
                              c.objectBoxController.unitBox.getAll();
                          Get.back();
                        },
                        searchHint: "search_unit_here".tr,
                        notFoundText: "no_unit_found".tr,
                        hint: "unit".tr,
                        items: c.units,
                        itemAsString: (unit) {
                          if (unit != null) {
                            return unit.fullName ?? "";
                          }
                          return "";
                        },
                        onChanged: (Unit? unit) {
                          if (unit != null) {
                            c.unitController.addSearchedUnit(unit);
                            c.minimumStockUnit.value = unit;
                            c.minimumStockUnitController.text =
                                unit.fullName ?? " ";
                          }
                        },
                        popupItemBuilder: (_, unit, b) {
                          return ListTile(
                            title: Text(unit.fullName ?? " "),
                            trailing: Text(unit.shortName ?? " "),
                          );
                        }),
                  ),
                  keyboardType: TextInputType.number,
                  labelText: "minimum_stock".tr,
                  hint: "2",
                  textEditingController: c.minimumStockController,
                  isDeviceConnected: networkController.connectionStatus.value,
                ),
                TextFieldWidget(
                  maxline: 2,
                  isDeviceConnected: networkController.connectionStatus.value,
                  textEditingController: controller.descriptionController,
                  labelText: "item_description".tr,
                  hint: "item_description_hint".tr,
                ),
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
                                c.addItem();
                              }
                            },
                          )
                        : AddButton(
                            onAddPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addItem();
                              }
                            },
                            onAddMorePressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = true;
                                c.addItem();
                              }
                            },
                          )),
                SizedBox(height: 30.h)
              ]),
            ),
          ),
        ));
  }
}
