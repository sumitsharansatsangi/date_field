import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:phone_number/phone_number.dart' as libphone;

class CreateCustomerController extends GetxController {
  final appBarText = 'add_customer'.tr.obs;
  final isUpdating = false.obs;
  Customer? updatingCustomer;
  final isFromContact = false.obs;
  final permissionDenied = false.obs;
  final currentContact = Contact().obs;
  final contacts = <Contact>[].obs;
  final gender = "male".obs;
  final isLoading = false.obs;
  final isAddMore = false.obs;
  final phoneList = <PhoneNumber>[PhoneNumber(isoCode: 'IN')].obs;
  final accountList = <TextEditingController>[TextEditingController()].obs;
  final customerNameController = TextEditingController();
  final customerNickNameController = TextEditingController();
  final customerAddressController = TextEditingController();
  final customerPincodeController = TextEditingController();
  final customerCategoryController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final currentLocationID = 0.obs;
  final customerCategories = <CustomerCategory>[].obs;
  final currentCategory = CustomerCategory().obs;
  final locations = <Location>[].obs;
  final panchayats = <String>{}.obs;
  final blocks = <String>{}.obs;
  final villages = <String>{}.obs;
  final mohallas = <String>{}.obs;
  final currentBlock = "".obs;
  final currentPanchayat = "".obs;
  final currentVillage = "".obs;
  final currentMohalla = "".obs;

  @override
  void onReady() async {
    super.onReady();
    customerCategories.value = objectBoxController.customerCategoryBox.getAll();
    if (customerCategories.isNotEmpty) {
      currentCategory.value = customerCategories.first;
    }
    isUpdating.value = Get.arguments[0];
    if (isUpdating.value) {
      appBarText.value = 'update_customer'.tr;
      updatingCustomer = Get.arguments[1];
      if (updatingCustomer!.name != null) {
        customerNameController.text = updatingCustomer!.name ?? " ";
      }
      if (updatingCustomer!.nickName != null) {
        customerNickNameController.text = updatingCustomer!.nickName!;
      }
      if (updatingCustomer!.phone != null) {
        final phoneNumber = await libphone.PhoneNumberUtil()
            .parse(updatingCustomer!.phone ?? "");
        final isoCode = "+${phoneNumber.countryCode}";
        phoneList.first = PhoneNumber(
            phoneNumber: updatingCustomer!.phone ?? "", isoCode: isoCode);
      }
      if (updatingCustomer!.otherPhone != null &&
          updatingCustomer!.otherPhone!.isNotEmpty) {
        for (final phone in updatingCustomer!.otherPhone!) {
          final phoneNumber = await libphone.PhoneNumberUtil().parse(phone);
          final isoCode = "+${phoneNumber.countryCode}";
          phoneList.add(PhoneNumber(phoneNumber: phone, isoCode: isoCode));
        }
      }
      if (updatingCustomer!.account != null &&
          updatingCustomer!.account!.isNotEmpty) {
        for (final account in updatingCustomer!.account!) {
          accountList.add(TextEditingController(text: account));
        }
      }
      if (updatingCustomer!.address != null) {
        customerAddressController.text = updatingCustomer!.address!;
      }
      if (updatingCustomer!.gender != null) {
        gender.value = updatingCustomer!.gender!;
      }
      if (updatingCustomer!.location.target != null) {
        customerPincodeController.text =
            updatingCustomer!.location.target!.pin.target!.pincode ?? "";
        currentLocationID.value = updatingCustomer!.location.targetId;
      }
    }
  }

  void fetchBlock(string) {
    QueryBuilder<Location> builder = objectBoxController.locationBox.query();
    builder.link(Location_.pin, Pincode_.pincode.equals(string));
    Query<Location> query = builder.build();
    locations.value = query.find();
    if (locations.isNotEmpty) {
      currentBlock.value = locations[0].block ?? " ";
      final list = locations.toList().map((e) => e.block!).toList();
      list.sort();
      blocks.addAll(list);
    }
  }

  void fetchPanchayats(string) {
    Set<String> panchayatSet = <String>{};
    int i = 0;
    for (final location in locations) {
      if (location.block == string && i == 0) {
        i = 1;
        currentPanchayat.value = location.panchayat!;
      }
      if (location.block == string) {
        panchayats.add(location.panchayat!);
      }
    }
    List<String> panchayatList = panchayatSet.toList();
    panchayatList.sort();
    panchayats.addAll(panchayatList);
  }

  void fetchVillages(string) {
    Set<String> villageSet = <String>{};
    int i = 0;
    for (final location in locations) {
      if (location.panchayat == string &&
          i == 0 &&
          location.block == currentBlock.value) {
        i = 1;
        currentVillage.value = location.village!;
      }
      if (location.panchayat == string &&
          location.block == currentBlock.value) {
        villageSet.add(location.village!);
      }
    }
    List<String> villageList = villageSet.toList();
    villageList.sort();
    villages.addAll(villageList);
  }

  void fetchMohallas(string) {
    Set<String> areaSet = <String>{};
    int i = 0;
    for (final location in locations) {
      if (location.village == string &&
          i == 0 &&
          location.panchayat == currentPanchayat.value &&
          location.block == currentBlock.value &&
          location.area != null) {
        i = 1;
        currentMohalla.value = location.area!;
      }
      if (location.village == string &&
          location.panchayat == currentPanchayat.value &&
          location.block == currentBlock.value &&
          location.area != null) {
        areaSet.add(location.area!);
      } else if (location.village == string) {
        currentLocationID.value = location.id!;
        final cLocation = {
          location.village,
          location.panchayat,
          location.block,
          location.pin.target!.district,
          location.pin.target!.state,
          location.pin.target!.country,
          location.pin.target!.pincode
        };
        customerAddressController.text = cLocation.join(',');
      }
    }
    List<String> areaList = areaSet.toList();
    areaList.sort();
    mohallas.addAll(areaList);
  }

  void assignLocationId(string) {
    for (final location in locations) {
      if (location.area == string &&
          location.village == currentVillage.value &&
          location.panchayat == currentPanchayat.value &&
          location.block == currentBlock.value &&
          location.area != null) {
        currentLocationID.value = location.id!;
        final cLocation = {
          location.area,
          location.village,
          location.panchayat,
          location.block,
          location.pin.target!.district,
          location.pin.target!.state,
          location.pin.target!.country,
          location.pin.target!.pincode
        };
        customerAddressController.text = cLocation.join(',');
      }
    }
  }

  addCustomer() async {
    try {
      isLoading.value = true;
      final customer = Customer()
        ..nickName = customerNickNameController.text.trim().capitalizeFirst
        ..phone = phoneList[0].phoneNumber
        ..otherPhone = [
          for (final phone in phoneList.sublist(1)) phone.phoneNumber ?? " "
        ]
        ..account = [for (final account in accountList) account.text]
        ..name = customerNameController.text.trim().capitalizeFirst
        ..category.target = currentCategory.value
        ..gender = gender.value
        ..location.targetId = currentLocationID.value
        ..address = customerAddressController.text;
      if (isUpdating.value) {
        customer.id = updatingCustomer!.id;
      }
      int id = objectBoxController.customerBox.put(customer);
      final names = customerNameController.text.trim().split(" ");
      final phoneJsonList = [
        for (final phone in phoneList)
          {"number": phone.phoneNumber, "label": "mobile"}
      ];

      if (isUpdating.value && updatingCustomer!.contactListId != null) {
        if (names.length == 1) {
          currentContact.value = Contact.fromJson({
            "id": updatingCustomer!.contactListId,
            "displayName": customerNameController.text.trim().capitalizeFirst,
            "name": {
              "first": names[0].trim().capitalizeFirst,
            },
            "phones": phoneJsonList
          });
        } else if (names.length == 2) {
          currentContact.value = Contact.fromJson({
            "id": updatingCustomer!.contactListId,
            "displayName": customerNameController.text.trim().capitalizeFirst,
            "name": {
              "first": names[0].trim().capitalizeFirst,
              "last": names[1].trim().capitalizeFirst,
            },
            "phones": phoneJsonList
          });
        } else if (names.length == 3) {
          currentContact.value = Contact.fromJson({
            "id": updatingCustomer!.contactListId,
            "displayName": customerNameController.text.trim().capitalizeFirst,
            "name": {
              "first": names[0].trim().capitalizeFirst,
              "middle": names[1].trim().capitalizeFirst,
              "last": names[2].trim().capitalizeFirst,
            },
            "phones": phoneJsonList
          });
        } else {
          currentContact.value = Contact.fromJson({
            "id": updatingCustomer!.contactListId,
            "displayName": customerNameController.text,
            "phones": phoneJsonList
          });
        }
      } else {
        if (names.length == 1) {
          currentContact.value = Contact.fromJson({
            "displayName": customerNameController.text.trim().capitalizeFirst,
            "name": {
              "first": names[0].trim().capitalizeFirst,
            },
            "phones": phoneJsonList
          });
          // print(currentContact.value);
        } else if (names.length == 2) {
          currentContact.value = Contact.fromJson({
            "displayName": customerNameController.text.trim().capitalize,
            "name": {
              "first": names[0].trim().capitalizeFirst,
              "last": names[1].trim().capitalizeFirst,
            },
            "phones": phoneJsonList
          });
          // print(currentContact.value);
        } else if (names.length == 3) {
          currentContact.value = Contact.fromJson({
            "displayName": customerNameController.text.trim().capitalize,
            "name": {
              "first": names[0].trim().capitalizeFirst,
              "middle": names[1].trim().capitalizeFirst,
              "last": names[2].trim().capitalizeFirst,
            },
            "phones": phoneJsonList
          });
          // print(currentContact.value);
        } else {
          currentContact.value = Contact.fromJson({
            "displayName": customerNameController.text.trim().capitalize,
            "name": {"first": customerNameController.text.trim().capitalize},
            "phones": phoneJsonList
          });
        }
      }
      final bool permissionGranted = await FlutterContacts.requestPermission();
      if (!isFromContact.value &&
          !permissionDenied.value &&
          permissionGranted &&
          isUpdating.value &&
          updatingCustomer!.contactListId != null) {
        await FlutterContacts.updateContact(currentContact.value);
      } else {
        final contact =
            await FlutterContacts.insertContact(currentContact.value);
        // print(contact.toJson());
        objectBoxController.customerBox
            .put(customer..contactListId = contact.id);
      }
      if (id != -1) {
        isLoading.value = false;
        if (!isAddMore.value) {
          Get.back();
          if (isUpdating.value) {
            successSnackBar("customer_updated_success_msg".tr);
          } else {
            successSnackBar("customer_success_msg".tr);
          }
        } else {
          customerNameController.clear();
          customerNickNameController.clear();
          customerAddressController.clear();
          phoneList.value = [PhoneNumber(isoCode: "IN")];
          accountList.value = [TextEditingController()];
          successSnackBar("customer_success_msg".tr);
        }
      } else {
        isLoading.value = false;
        errorSnackBar();
      }
    } on UniqueViolationException {
      isLoading.value = false;
      alertSnackBar();
    } on Exception {
      isLoading.value = false;
      errorSnackBar();
    }
  }
}
