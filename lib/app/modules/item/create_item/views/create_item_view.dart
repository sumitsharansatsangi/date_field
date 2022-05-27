import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speed_up_get/speed_up_get.dart';
import '../../../../data/model.dart';
import '../controllers/create_item_controller.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as a;

class CreateItemView extends GetView<CreateItemController> {
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
        body: Center(
          child: SizedBox(
            width: 1.sh > 1.sw ? 0.95.sw : 0.95.sh,
            child: Form(
              key: _formKey,
              child: ListView(children: [
                SizedBox(height: 15.h),
                TextFieldWidget(
                  textEditingController: controller.itemNameController,
                  labelText: '${"item_name".tr}:',
                  isDeviceConnected: networkController.connectionStatus.value,
                  hint: "item_name_hint".tr,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.replaceAll(" ", "").isEmpty) {
                      return "item_name_hint".tr;
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => ListView.builder(
                          physics:
                              const NeverScrollableScrollPhysics(), // <= This was the key for me
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return TextFieldWidget(
                              suffixIcon: SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: a.GradientIconButton(
                                  onPressed: c.alternateNameList.length > 1
                                      ? () {
                                          c.alternateNameList.removeAt(index);
                                        }
                                      : null,
                                  gradient: g1,
                                  icon: Icon(
                                    CupertinoIcons.minus_circle_fill,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                              textEditingController: c.alternateNameList[index],
                              labelText: c.alternateNameList.length == 1
                                  ? 'alternate_name'.tr
                                  : '${'alternate_name'.tr} ${index + 1}',
                              isDeviceConnected:
                                  networkController.connectionStatus.value,
                              hint: '${'alternate_name_hint'.tr} ${index + 1}',
                            );
                          },
                          itemCount: c.alternateNameList.length)),
                    ),
                    a.GradientIconButton(
                      padding: EdgeInsets.all(0),
                      gradient: g1,
                      icon: Icon(
                        Icons.add_circle_outlined,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        c.alternateNameList.add(TextEditingController());
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                DropDownSearchField<ItemCategory>(
                    onPressed: () async {
                      await Get.toNamed(Routes.CREATE_ITEM_CATEGORY,
                          arguments: [false]);
                      c.itemCategories.value =
                          c.objectBoxController.itemCategoryBox.getAll();
                      Get.back();
                    },
                    searchHint: 'search_item_category_here'.tr,
                    label: 'item_category_name'.tr,
                    notFoundText: "no_item_category_found".tr,
                    items: c.itemCategories,
                    itemAsString: (ItemCategory? itemCategory) {
                      return itemCategory!.name ?? "";
                    },
                    onChanged: (ItemCategory? itemCategory) {
                      c.currentCategory.value = itemCategory!;
                      c.categoryController.addSearchedCategory(itemCategory);
                    },
                    popupItemBuilder: (_, ItemCategory itemCategory, b) {
                      return ListTile(
                        title: Text(itemCategory.name ?? " "),
                      );
                    }),
                SizedBox(
                  height: 10.h,
                ),
                DropDownSearchField(
                    onPressed: () async {
                      await Get.toNamed(Routes.CREATE_COMPANY,
                          arguments: [false]);
                      c.companies.value =
                          c.objectBoxController.companyBox.getAll();
                      Get.back();
                    },
                    searchHint: 'search_company_here'.tr,
                    label: 'company'.tr,
                    notFoundText: "no_company_found".tr,
                    items: c.companies,
                    itemAsString: (Company? company) {
                      return company!.name ?? "";
                    },
                    onChanged: (Company? suggestion) {
                      c.currentCompany.value = suggestion!;
                      c.companyController.addSearchedCompany(suggestion);
                    },
                    popupItemBuilder: (_, Company company, b) {
                      return ListTile(
                        title: Text(company.name ?? " "),
                      );
                    }),
                SizedBox(height: 5.h),
                TextFieldWidget(
                  maxline: 2,
                  isDeviceConnected: networkController.connectionStatus.value,
                  textEditingController: controller.descriptionController,
                  labelText: "item_description".tr,
                  hint: "item_description_hint".tr,
                ),
                SizedBox(height: 15.h),
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
              ]),
            ),
          ),
        ));
  }
}
