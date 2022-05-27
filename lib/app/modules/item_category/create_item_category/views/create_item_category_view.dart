import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/create_item_category_controller.dart';

class CreateItemCategoryView extends GetView<CreateItemCategoryController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
            child: ListView(
              children: [
                SizedBox(height: 20.h),
                TextFieldWidget(
                    textEditingController: c.nameController,
                    labelText: '${'item_category_name'.tr}:',
                    isDeviceConnected: networkController.connectionStatus.value,
                    hint: 'Pipe',
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.removeAllWhitespace.isEmpty) {
                        return 'item_category_hint'.tr;
                      }
                      return null;
                    }),
                Obx(() => c.isLoading.value
                    ? Center(child: const CircularProgressIndicator())
                    : c.isUpdating.value
                        ? UpdateButton(
                            onPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addCategory();
                              }
                            },
                          )
                        : AddButton(
                            onAddPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addCategory();
                              }
                            },
                            onAddMorePressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = true;
                                c.addCategory();
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
