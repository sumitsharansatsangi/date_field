import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_textfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/create_almirah_controller.dart';

class CreateAlmirahView extends GetView<CreateAlmirahController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();
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
                TextFieldWidget(
                    textEditingController: c.nameController,
                    labelText: '${'almirah'.tr}:',
                    isDeviceConnected: networkController.connectionStatus.value,
                    hint: 'almirah_hint'.tr,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.removeAllWhitespace.isEmpty) {
                        return 'almirah_hint'.tr;
                      }
                      return null;
                    }),
                Obx(() => c.godowns.isEmpty
                    ? SizedBox()
                    : SizedBox(
                        height: 10.h,
                      )),
                Obx(() => c.godowns.isEmpty
                    ? SizedBox()
                    : DropDownSearchField<Godown>(
                        onPressed: () async {
                          await Get.toNamed(Routes.CREATE_GODOWN);
                        },
                        items: c.godowns,
                        label: 'godown'.tr,
                        searchHint: 'search_godown_here'.tr,
                        notFoundText: 'no_godown_found'.tr,
                        itemAsString: (godown) {
                          return godown != null ? godown.name ?? "" : "";
                        },
                        onChanged: (Godown? value) {
                          c.currentGodown.value = value!;
                          c.fetchStoreRoom(value.id!);
                        },
                        popupItemBuilder: (_, godown, b) {
                          return ListTile(
                            title: AutoSizeText(godown.name ?? " ",
                                stepGranularity: 1.sp,
                                minFontSize: 8.sp,
                                style: Get.textTheme.titleLarge),
                          );
                        })),
                Obx(() => c.godowns.isEmpty
                    ? SizedBox()
                    : c.storeRooms.isEmpty
                        ? SizedBox(
                            height: 5.h,
                          )
                        : SizedBox(
                            height: 10.h,
                          )),
                Obx(() => c.storeRooms.isEmpty
                    ? SizedBox()
                    : DropDownSearchField<StoreRoom>(
                        onPressed: () async {
                          await Get.toNamed(Routes.CREATE_STORE_ROOM);
                        },
                        items: c.storeRooms,
                        label: 'store_room'.tr,
                        searchHint: 'search_store_room_here'.tr,
                        notFoundText: 'no_store_room_found'.tr,
                        itemAsString: (storeRoom) {
                          return storeRoom != null ? storeRoom.name ?? "" : "";
                        },
                        onChanged: (storeRoom) {
                          c.currentStoreRoom.value = storeRoom!;
                        },
                        popupItemBuilder: (_, godown, b) {
                          return ListTile(
                            title: AutoSizeText(godown.name ?? " ",
                                stepGranularity: 1.sp,
                                minFontSize: 8.sp,
                                style: Get.textTheme.titleLarge),
                          );
                        })),
                CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: c.rowController,
                    labelText: '${'almirah_row'.tr}:',
                    hint: 'almirah_row_hint'.tr,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.removeAllWhitespace.isEmpty ||
                          !value.isNumericOnly) {
                        return 'almirah_row_hint'.tr;
                      }
                      return null;
                    }),
                CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: c.columnController,
                    labelText: '${'almirah_column'.tr}:',
                    hint: 'almirah_column_hint'.tr,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.removeAllWhitespace.isEmpty ||
                          !value.isNumericOnly) {
                        return 'almirah_column_hint'.tr;
                      }
                      return null;
                    }),
                SizedBox(height: 15.h),
                Obx(
                  () => c.isLoading.value
                      ? Center(child: const CircularProgressIndicator())
                      : c.isUpdating.value
                          ? UpdateButton(
                              onPressed: () {
                                _formKey.currentState!.save;
                                if (_formKey.currentState!.validate()) {
                                  c.isLoading.value = true;
                                  c.isAddMore.value = false;
                                  c.addAlmirah();
                                }
                              },
                            )
                          : AddButton(
                              onAddPressed: () {
                                _formKey.currentState!.save;
                                if (_formKey.currentState!.validate()) {
                                  c.isLoading.value = true;
                                  c.isAddMore.value = false;
                                  c.addAlmirah();
                                }
                              },
                              onAddMorePressed: () {
                                _formKey.currentState!.save;
                                if (_formKey.currentState!.validate()) {
                                  c.isLoading.value = true;
                                  c.isAddMore.value = true;
                                  c.addAlmirah();
                                }
                              },
                            ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
