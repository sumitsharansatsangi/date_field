import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_textfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/create_customer_controller.dart';

class CreateCustomerView extends GetView<CreateCustomerController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();
    return Scaffold(
      appBar: customAppBar(
        titleText: c.appBarText,
        actions: [
          SizedBox(
            height: 35.r,
            width: 55.r,
            child: DropDownSearchField<Contact>(
                isIconBased: true,
                icon: Icon(Icons.contacts,
                    color: Colors.deepPurple.shade50, size: 22.sp),
                searchHint: "search_contact_here".tr,
                popupTitle: 'contact'.tr,
                notFoundText: 'no_contact_found'.tr,
                itemAsString: (Contact? contact) {
                  return contact!.displayName;
                },
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

                    c.customerNameController.text = fullContact.displayName;
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
      ),
      body: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              width: 1.sh > 1.sw ? 0.95.sw : 0.95.sh,
              child: ListView(
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return PhoneWidget(
                                initialValue: c.phoneList[index],
                                labelText: c.phoneList.length == 1
                                    ? '${'customer_mobile_number'.tr}:'
                                    : "${'customer_mobile_number'.tr}${index + 1}:",
                                hint: 'customer_mobile_number_hint'.tr,
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
                      textEditingController: c.customerNameController,
                      labelText: '${'customer_name'.tr}:',
                      isDeviceConnected:
                          networkController.connectionStatus.value,
                      hint: "customer_name_hint".tr,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'customer_name_hint'.tr;
                        } else if (value.removeAllWhitespace.isEmpty) {
                          c.customerNameController.clear();
                          return 'customer_name_hint'.tr;
                        }
                        return null;
                      }),
                  TextFieldWidget(
                      textEditingController: c.customerNickNameController,
                      labelText: '${'customer_nick_name'.tr}:',
                      isDeviceConnected:
                          networkController.connectionStatus.value,
                      hint: "customer_nick_name_hint".tr,
                      validator: (value) {
                        if (value != null &&
                            value.removeAllWhitespace.isEmpty) {
                          c.customerNickNameController.clear();
                        }
                        return null;
                      }),
                  Obx(() => c.customerCategories.isEmpty
                      ? const SizedBox()
                      : DropDownSearchField<CustomerCategory>(
                          onPressed: () async {
                            await Get.toNamed(Routes.CREATE_CUSTOMER_CATEGORY,
                                arguments: [false]);
                            c.customerCategories.value = c
                                .objectBoxController.customerCategoryBox
                                .getAll();
                            Get.back();
                          },
                          selectedItem: c.currentCategory.value,
                          items: c.customerCategories,
                          searchHint: 'search_customer_category_here'.tr,
                          notFoundText: 'no_customer_category_found'.tr,
                          itemAsString: (customerCategory) {
                            if (customerCategory != null) {
                              return customerCategory.name ?? "";
                            }
                            return "";
                          },
                          onChanged: (CustomerCategory? value) {
                            c.customerCategoryController.text =
                                value!.name ?? " ";
                            c.currentCategory.value = value;
                          },
                          popupItemBuilder: (_, customerCategory, b) {
                            return ListTile(
                              title: AutoSizeText(customerCategory.name ?? ""),
                            );
                          })),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 150.w,
                        child: ListTile(
                          title: Wrap(
                            children: [
                              Text(
                                'male'.tr,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 100, 58, 172),
                                    fontSize: 13.sp),
                              ),
                            ],
                          ),
                          leading: Obx(() => Radio(
                              value: "male".tr,
                              groupValue: c.gender.value,
                              onChanged: (String? value) {
                                c.gender.value = value!;
                              })),
                        ),
                      ),
                      SizedBox(
                        width: 170.w,
                        child: ListTile(
                          title: Text('female'.tr,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 100, 58, 172),
                                  fontSize: 13.sp)),
                          leading: Obx(() => Radio(
                              value: "female".tr,
                              groupValue: c.gender.value,
                              onChanged: (String? value) {
                                c.gender.value = value!;
                              })),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    width: 1.sh > 1.sw ? 0.95.sw : 0.95.sh,
                    child: TextField(
                      style: TextStyle(fontSize: 15.sp),
                      keyboardType: TextInputType.number,
                      controller: c.customerPincodeController,
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
                        label: AutoSizeText("pincode".tr),
                      ),
                      onChanged: (string) {
                        if (string.length == 6) {
                          c.currentBlock.value = "";
                          c.blocks.clear();
                          c.panchayats.clear();
                          c.villages.clear();
                          c.mohallas.clear();
                          c.customerAddressController.clear();
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
                              c.customerAddressController.clear();
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
                              c.customerAddressController.clear();
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
                              c.customerAddressController.clear();
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
                              c.customerAddressController.clear();
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
                        textEditingController: c.customerAddressController,
                        labelText: '${'customer_address'.tr}:',
                        hint: 'customer_address_hint'.tr,
                        isDeviceConnected:
                            networkController.connectionStatus.value,
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => ListView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(), // <= This was the key for me
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return TextFieldWidget(
                                keyboardType: TextInputType.number,
                                textEditingController: c.accountList[index],
                                labelText: c.accountList.length == 1
                                    ? '${'customer_account_number'.tr}:'
                                    : '${'customer_account_number'.tr} ${index + 1}:',
                                isDeviceConnected:
                                    networkController.connectionStatus.value,
                                hint: 'customer_account_hint'.tr,
                                validator: c.accountList.length == 1
                                    ? null
                                    : (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'customer_account_hint'.tr;
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
                  Obx(() => c.isLoading.value
                      ? Center(child: const CircularProgressIndicator())
                      : c.isUpdating.value
                          ? UpdateButton(onPressed: () {
                              _formKey.currentState!.save;
                              if (_formKey.currentState!.validate()) {
                                c.isLoading.value = true;
                                c.isAddMore.value = false;
                                c.addCustomer();
                              }
                            })
                          : AddButton(
                              onAddPressed: () {
                                _formKey.currentState!.save;
                                if (_formKey.currentState!.validate()) {
                                  c.isLoading.value = true;
                                  c.isAddMore.value = false;
                                  c.addCustomer();
                                }
                              },
                              onAddMorePressed: () {
                                _formKey.currentState!.save;
                                if (_formKey.currentState!.validate()) {
                                  c.isLoading.value = true;
                                  c.isAddMore.value = true;
                                  c.addCustomer();
                                }
                              },
                            )),
                ],
              ),
            ),
          )),
    );
  }
}
