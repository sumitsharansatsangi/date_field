import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/create_godown_controller.dart';

class CreateGodownView extends GetView<CreateGodownController> {
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
            width: 1.sh > 1.sw ? 0.95.sw : 0.95.sh,
            child: ListView(
              children: [
                SizedBox(height: 20.h),
                TextFieldWidget(
                    textEditingController: c.nameController,
                    labelText: '${'godown_name'.tr}:',
                    isDeviceConnected: networkController.connectionStatus.value,
                    hint: 'godown_name_hint'.tr,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.removeAllWhitespace.isEmpty) {
                        c.nameController.clear();
                        return 'godown_name_hint'.tr;
                      }
                      return null;
                    }),
                SizedBox(
                  height: 20.h,
                ),
                Table(
                  columnWidths: {
                    0: FlexColumnWidth(1 / 3),
                    1: FixedColumnWidth(26.sp)
                  },
                  children: [
                    TableRow(children: [
                      Text(
                        'add_open_space_godown'.tr,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 25.sp,
                        width: 25.sp,
                        child: Obx(() => Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              checkColor: Colors.greenAccent,
                              // activeColor: Colors.red,
                              value: c.addOpenSpace.value,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  c.addOpenSpace.value = value;
                                }
                              },
                            )),
                      ),
                    ])
                  ],
                ),
                SizedBox(height: 30.h),
                Obx(() => c.isLoading.value
                    ? Center(child: const CircularProgressIndicator())
                    : c.isUpdating.value
                        ? UpdateButton(
                            onPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addGodown();
                              }
                            },
                          )
                        : AddButton(
                            onAddPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addGodown();
                              }
                            },
                            onAddMorePressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = true;
                                c.addGodown();
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
