import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_textfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/create_supplier_controller.dart';

class CreateSupplierView extends GetView<CreateSupplierController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();
    return Scaffold(
      appBar: customAppBar(
        actions: [
          SizedBox(
            height: 35.r,
            width: 55.r,
            child: DropDownSearchField<Contact>(
                searchHint: "search_contact_here".tr,
                popupTitle: 'contact'.tr,
                notFoundText: 'no_contact_found'.tr,
                itemAsString: (Contact? contact) {
                  return contact!.displayName;
                },
                isIconBased: true,
                icon: Icon(Icons.contacts,
                    color: Colors.deepPurple.shade50, size: 22.sp),
                onChanged: (contact) async {
                  c.isFromContact.value = true;
                  final fullContact =
                      await FlutterContacts.getContact(contact!.id);
                  if (fullContact != null || fullContact!.phones.isNotEmpty) {
                    final phoneNumber = fullContact.phones.first.number;
                    if (phoneNumber.contains("+")) {
                      final phoneList = phoneNumber.split(" ");
                      final phone = phoneList.sublist(1).join();
                      c.phoneList.last = PhoneNumber(
                          phoneNumber: phone,
                          isoCode:
                              PhoneNumber.getISO2CodeByPrefix(phoneList.first));
                    } else {
                      c.phoneList.last =
                          PhoneNumber(isoCode: "IN", phoneNumber: phoneNumber);
                    }
                    c.supplierNameController.text = fullContact.displayName;
                    c.currentContact.value = fullContact;
                  }
                },
                onFind: (string) async {
                  final bool permissionGranted =
                      await FlutterContacts.requestPermission();
                  if (permissionGranted) {
                    c.contacts.value = await FlutterContacts.getContacts();
                  } else {
                    Get.defaultDialog(
                        middleText: 'permission_denied_for_contacts'.tr);
                  }
                  return c.contacts;
                },
                popupItemBuilder: (_, contact, b) {
                  return ListTile(
                    title: AutoSizeText(contact.displayName),
                    subtitle: AutoSizeText(contact.phones.isNotEmpty
                        ? contact.phones.first.number
                        : ''),
                  );
                }),
          ),
        ],
        titleText: c.appBarText,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: 1.sh > 1.sw ? 0.95.sw : 0.95.sh,
            child: ListView(
              children: [
                SizedBox(height: 25.h),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return PhoneWidget(
                              initialValue: PhoneNumber(),
                              // initialValue: c.countryCode[index],
                              // controller: c.phoneList[index],
                              labelText: c.phoneList.length == 1
                                  ? '${'supplier_mobile_number'.tr}:'
                                  : "${'supplier_mobile_number'.tr}${index + 1}:",
                              hint: 'supplier_mobile_number_hint'.tr,
                              onChanged: (phone) {
                                c.phoneList[index] = phone;
                              },
                              suffixIcon: MinusButton(
                                onPressed: c.phoneList.length > 1
                                    ? () {
                                        c.phoneList.removeAt(index);
                                      }
                                    : null,
                              ),
                            );
                          },
                          itemCount: c.phoneList.length)),
                    ),
                    PlusButton(onPressed: () {
                      c.phoneList.add(PhoneNumber(isoCode: "IN"));
                    })
                  ],
                ),
                TextFieldWidget(
                    textEditingController: c.supplierNameController,
                    labelText: '${'supplier_name'.tr}:',
                    isDeviceConnected: networkController.connectionStatus.value,
                    hint: 'supplier_name_hint'.tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'supplier_name_hint'.tr;
                      }
                      return null;
                    }),
                TextFieldWidget(
                    textEditingController: c.supplierNickNameController,
                    labelText: '${'supplier_nick_name'.tr}:',
                    isDeviceConnected: networkController.connectionStatus.value,
                    hint: "supplier_nick_name_hint".tr,
                    validator: (value) {
                      if (value != null && value.removeAllWhitespace.isEmpty) {
                        c.supplierNickNameController.clear();
                      }
                      return null;
                    }),
                TextFieldWidget(
                    textEditingController:
                        c.supplierShopOrBusinessNameController,
                    labelText: '${'supplier_shop_or_business_name'.tr}:',
                    isDeviceConnected: networkController.connectionStatus.value,
                    hint: "supplier_shop_or_business_name_hint".tr,
                    validator: (value) {
                      if (value != null && value.removeAllWhitespace.isEmpty) {
                        c.supplierShopOrBusinessNameController.clear();
                      }
                      return null;
                    }),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                  width: 1.sh > 1.sw ? 0.95.sw : 0.95.sh,
                  child: TextField(
                    style: TextStyle(fontSize: 15.sp),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 236, 234, 250),
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(15.r),
                      hintStyle: TextStyle(fontSize: 15.sp),
                      labelStyle: TextStyle(fontSize: 15.sp),
                      border: const OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 13.sp),
                      hintText: "pincode_hint".tr,
                      label: Text('${"pincode".tr}:'),
                    ),
                    onChanged: (string) {
                      if (string.length == 6) {
                        c.currentBlock.value = "";
                        c.blocks.clear();
                        c.panchayats.clear();
                        c.villages.clear();
                        c.mohallas.clear();
                        c.supplierAddressController.clear();
                        c.fetchBlock(string);
                      }
                    },
                  ),
                ),
                Obx(() => c.blocks.isNotEmpty
                    ? SizedBox(height: 5.h)
                    : const SizedBox()),
                Obx(
                  () => c.blocks.isEmpty
                      ? const SizedBox()
                      : DropDownSearchField<String>(
                          allowCreation: false,
                          searchHint: "search_block_here".tr,
                          label: 'block'.tr,
                          notFoundText: 'no_block_found'.tr,
                          items: c.blocks.toList(),
                          itemAsString: (String? s) => s!,
                          onChanged: (String? value) {
                            c.currentBlock.value = value!;
                            controller.panchayats.clear();
                            controller.villages.clear();
                            controller.mohallas.clear();
                            c.supplierAddressController.clear();
                            controller.fetchPanchayats(value);
                          },
                          popupItemBuilder: (_, block, b) {
                            return ListTile(
                              title: AutoSizeText(
                                block,
                                stepGranularity: 1.sp,
                                minFontSize: 6.sp,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Color.fromARGB(255, 7, 1, 32),
                                ),
                              ),
                            );
                          }),
                ),
                Obx(() => c.panchayats.isNotEmpty
                    ? SizedBox(height: 10.h)
                    : const SizedBox()),
                Obx(
                  () => c.panchayats.isEmpty
                      ? const SizedBox.shrink()
                      : DropDownSearchField<String>(
                          allowCreation: false,
                          searchHint: "search_panchayat_here".tr,
                          label: 'panchayat'.tr,
                          notFoundText: 'no_panchayat_found'.tr,
                          items: c.panchayats.toList(),
                          itemAsString: (String? s) => s!,
                          onChanged: (String? value) {
                            c.currentPanchayat.value = value!;
                            controller.villages.clear();
                            controller.mohallas.clear();
                            c.supplierAddressController.clear();
                            controller.fetchVillages(value);
                          },
                          popupItemBuilder: (_, panchayat, b) {
                            return ListTile(
                              title: AutoSizeText(
                                panchayat,
                                stepGranularity: 1.sp,
                                minFontSize: 6.sp,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Color.fromARGB(255, 7, 1, 32),
                                ),
                              ),
                            );
                          }),
                ),
                Obx(() => c.villages.isNotEmpty
                    ? SizedBox(height: 10.h)
                    : const SizedBox()),
                Obx(
                  () => c.villages.isEmpty
                      ? const SizedBox()
                      : DropDownSearchField<String>(
                          allowCreation: false,
                          searchHint: "search_village_here".tr,
                          label: 'village'.tr,
                          notFoundText: 'no_village_found'.tr,
                          items: c.villages.toList(),
                          itemAsString: (String? s) => s!,
                          onChanged: (String? value) {
                            c.currentVillage.value = value!;
                            controller.mohallas.clear();
                            c.supplierAddressController.clear();
                            controller.fetchMohallas(value);
                          },
                          popupItemBuilder: (_, village, b) {
                            return ListTile(
                              title: AutoSizeText(
                                village,
                                stepGranularity: 1.sp,
                                minFontSize: 6.sp,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Color.fromARGB(255, 7, 1, 32),
                                ),
                              ),
                            );
                          }),
                ),
                Obx(() => c.mohallas.isNotEmpty
                    ? SizedBox(height: 10.h)
                    : const SizedBox()),
                Obx(
                  () => c.mohallas.isEmpty
                      ? const SizedBox.shrink()
                      : DropDownSearchField<String>(
                          allowCreation: false,
                          searchHint: "search_mohalla_here".tr,
                          label: 'mohalla'.tr,
                          notFoundText: 'no_mohalla_found'.tr,
                          items: c.mohallas.toList(),
                          itemAsString: (String? s) => s!,
                          onChanged: (String? value) {
                            c.currentMohalla.value = value!;
                            c.supplierAddressController.clear();
                            controller.assignLocationId(value);
                          },
                          popupItemBuilder: (_, village, b) {
                            return ListTile(
                              title: AutoSizeText(
                                village,
                                stepGranularity: 1.sp,
                                minFontSize: 6.sp,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Color.fromARGB(255, 7, 1, 32),
                                ),
                              ),
                            );
                          }),
                ),
                Obx(() => c.mohallas.isNotEmpty
                    ? SizedBox(height: 5.h)
                    : const SizedBox()),
                Obx(() => TextFieldWidget(
                      maxline: 2,
                      isDeviceConnected:
                          networkController.connectionStatus.value,
                      textEditingController: c.supplierAddressController,
                      labelText: '${'supplier_address'.tr}:',
                      hint: 'supplier_address_hint'.tr,
                    )),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return TextFieldWidget(
                              textEditingController: c.accountList[index],
                              labelText: c.accountList.length == 1
                                  ? '${'supplier_account_number'.tr}:'
                                  : '${'supplier_account_number'.tr}${index + 1}:',
                              isDeviceConnected:
                                  networkController.connectionStatus.value,
                              hint: 'supplier_account_hint'.tr,
                              validator: c.accountList.length == 1
                                  ? null
                                  : (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'supplier_account_hint'.tr;
                                      }
                                      return null;
                                    },
                              suffixIcon: MinusButton(
                                onPressed: c.accountList.length > 1
                                    ? () {
                                        c.accountList.removeAt(index);
                                      }
                                    : null,
                              ),
                            );
                          },
                          itemCount: c.accountList.length)),
                    ),
                    PlusButton(
                        onPressed: () =>
                            c.accountList.add(TextEditingController()))
                  ],
                ),
                SizedBox(
                  height: 15.h,
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
                                c.addSupplier();
                              }
                            },
                          )
                        : AddButton(
                            onAddPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addSupplier();
                              }
                            },
                            onAddMorePressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = true;
                                c.addSupplier();
                              }
                            },
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
