import 'package:app/app/data/model.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_textfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/create_store_room_controller.dart';

class CreateStoreRoomView extends GetView<CreateStoreRoomController> {
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
                    labelText: '${'store_room_name'.tr}:',
                    isDeviceConnected: networkController.connectionStatus.value,
                    hint: 'store_room_name_hint'.tr,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.removeAllWhitespace.isEmpty) {
                        return 'store_room_name_hint'.tr;
                      }
                      return null;
                    }),
                SizedBox(height: 5.h),
                Obx(
                  () => c.godowns.isEmpty
                      ? const SizedBox()
                      : DropDownSearchField<Godown>(
                          searchHint: 'search_godown_here'.tr,
                          label: 'godown'.tr,
                          items: c.godowns,
                          notFoundText: 'no_store_room_found'.tr,
                          itemAsString: (Godown? godown) =>
                              godown != null ? godown.name ?? " " : " ",
                          onChanged: (Godown? godown) {
                            if (godown != null) {
                              c.currentGodown.value = godown;
                            }
                          },
                          popupItemBuilder: (_, godown, b) {
                            return ListTile(
                              title: AutoSizeText(godown.name ?? " ",
                                  stepGranularity: 1.sp,
                                  minFontSize: 8.sp,
                                  style: Get.textTheme.titleLarge),
                            );
                          }),
                ),
                SizedBox(height: 20.h),
                Obx(() => c.isLoading.value
                    ? Center(child: const CircularProgressIndicator())
                    : c.isUpdating.value
                        ? UpdateButton(
                            onPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addStoreRoom();
                              }
                            },
                          )
                        : AddButton(
                            onAddPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addStoreRoom();
                              }
                            },
                            onAddMorePressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = true;
                                c.addStoreRoom();
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
