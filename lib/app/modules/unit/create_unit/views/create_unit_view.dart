import 'package:app/app/data/model.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_textfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as a;
import '../controllers/create_unit_controller.dart';

class CreateUnitView extends GetView<CreateUnitController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Gradient g1 = const LinearGradient(
    colors: [
      Color(0xFF6400FF),
      Color(0xFF7700FF),
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
            width: 1.sh > 1.sw ? 0.95.sw : 0.95.sh,
            child: ListView(
              children: [
                SizedBox(height: 20.h),
                TextFieldWidget(
                    textEditingController: c.fullUnitController,
                    labelText: 'unit_full_name'.tr,
                    isDeviceConnected: networkController.connectionStatus.value,
                    hint: 'unit_full_name_hint'.tr,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.removeAllWhitespace.isEmpty) {
                        return 'unit_full_name_hint'.tr;
                      }
                      return null;
                    }),
                TextFieldWidget(
                  textEditingController: c.shortUnitController,
                  labelText: 'unit_short_name'.tr,
                  isDeviceConnected: networkController.connectionStatus.value,
                  hint: 'unit_short_name_hint'.tr,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.removeAllWhitespace.isEmpty) {
                      return 'unit_short_name_hint'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                Center(
                  child: Container(
                    height: 30.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple
                                .withOpacity(0.5), //color of shadow
                            spreadRadius: 5, //spread radius
                            blurRadius: 7, // blur radius
                            offset: Offset(0, 3), // changes position of shadow
                          )
                        ],
                        gradient: g1),
                    child: TextButton(
                        child: Text(
                          "set_conversion_value".tr,
                          style:
                              TextStyle(fontSize: 13.sp, color: Colors.white),
                        ),
                        onPressed: () {
                          // c.fullname.value = "kaccha abadam";
                          c.conversionTextList.add(TextEditingController());
                          c.conversionHintList.add("".obs);
                          c.isConversion.value = true;
                        }),
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(
                  () => c.isConversion.value
                      ? c.unitList.isNotEmpty
                          ? Row(
                              children: [
                                Expanded(
                                    child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.h),
                                            child: Column(
                                              children: [
                                                CustomTextField(
                                                  prefixIcon: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.w),
                                                    child: SizedBox(
                                                      width: 150.w,
                                                      child:
                                                          DropDownSearchField<
                                                              Unit>(
                                                        items: c.unitList,
                                                        itemAsString:
                                                            (Unit? u) =>
                                                                u!.fullName ??
                                                                " ",
                                                        label: 'unit'.tr,
                                                        notFoundText:
                                                            "no_unit_found".tr,
                                                        allowDecoration: false,
                                                        searchHint:
                                                            "search_unit_here"
                                                                .tr,
                                                        onChanged:
                                                            (Unit? unit) {
                                                          if (unit != null) {
                                                            c.currentConversionUnit
                                                                .value = unit;
                                                          }
                                                        },
                                                        popupItemBuilder:
                                                            (_, unit, b) {
                                                          return Column(
                                                            children: [
                                                              ListTile(
                                                                minVerticalPadding:
                                                                    0,
                                                                title: AutoSizeText(
                                                                    unit.fullName ??
                                                                        "",
                                                                    stepGranularity:
                                                                        1.sp,
                                                                    minFontSize:
                                                                        8.sp,
                                                                    style: Get
                                                                        .textTheme
                                                                        .titleLarge),
                                                                trailing:
                                                                    AutoSizeText(
                                                                  unit.shortName ??
                                                                      "",
                                                                  stepGranularity:
                                                                      1.sp,
                                                                  minFontSize:
                                                                      8.sp,
                                                                  style: Get
                                                                      .textTheme
                                                                      .titleMedium,
                                                                ),
                                                              ),
                                                              Divider()
                                                            ],
                                                          );
                                                        },
                                                        allowCreation: false,
                                                      ),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    c.conversionHintList[index]
                                                            .value =
                                                        "1 ${c.fullUnitController.text} =  $value ${c.currentConversionUnit.value.fullName}";
                                                  },
                                                  controller:
                                                      c.conversionTextList[
                                                          index],
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'conversion_value_hint'
                                                          .tr;
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  labelText:
                                                      '${'conversion_value'.tr}:',
                                                  hint: '10',
                                                  suffixIcon: MinusButton(
                                                    onPressed:
                                                        c.conversionTextList
                                                                    .length >
                                                                1
                                                            ? () {
                                                                c.conversionTextList
                                                                    .removeAt(
                                                                        index);
                                                                c.conversionHintList
                                                                    .removeAt(
                                                                        index);
                                                              }
                                                            : null,
                                                  ),
                                                ),
                                                Obx(() => AutoSizeText(
                                                      c.fullname.value == ""
                                                          ? "enter_full_unit_first"
                                                              .tr
                                                          : c
                                                              .conversionHintList[
                                                                  index]
                                                              .value,
                                                      stepGranularity: 1.sp,
                                                      minFontSize: 8.sp,
                                                      style: TextStyle(
                                                          fontSize: 13.sp),
                                                    )),
                                              ],
                                            ),
                                          );
                                        },
                                        itemCount:
                                            c.conversionTextList.length)),
                                PlusButton(
                                  onPressed: () {
                                    c.conversionTextList
                                        .add(TextEditingController());
                                    c.conversionHintList.add("".obs);
                                  },
                                )
                              ],
                            )
                          : Center(
                              child: AutoSizeText("no_unit".tr,
                                  style: TextStyle(fontSize: 11.sp)),
                            )
                      : SizedBox(),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Obx(() => c.isLoading.value
                    ? Center(child: const CircularProgressIndicator())
                    : c.isUpdating.value
                        ? UpdateButton(
                            onPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addUnit();
                              }
                            },
                          )
                        : AddButton(
                            onAddPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addUnit();
                              }
                            },
                            onAddMorePressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = true;
                                c.addUnit();
                              }
                            },
                          )),
                SizedBox(
                  height: Get.height / 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
