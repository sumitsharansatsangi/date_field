import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:phone_number/phone_number.dart' as libphone;

class CreateSupplierController extends GetxController {
  final appBarText = 'add_supplier'.tr.obs;
  final isUpdating = false.obs;
  Supplier? updatingSupplier;
  final isFromContact = false.obs;
  final permissionDenied = false.obs;
  final currentContact = Contact().obs;
  final contacts = <Contact>[].obs;
  final gender = "".obs;
  final isLoading = false.obs;
  final isAddMore = false.obs;
  final phoneList = <PhoneNumber>[PhoneNumber(isoCode: 'IN')].obs;
  final accountList = <TextEditingController>[TextEditingController()].obs;
  final supplierNameController = TextEditingController();
  final supplierNickNameController = TextEditingController();
  final supplierShopOrBusinessNameController = TextEditingController();
  final supplierAddressController = TextEditingController();
  final objectBoxController = Get.find<ObjectBoxController>();
  final currentLocationID = 0.obs;
  final locations = <Location>[].obs;
  final panchayats = <String>{}.obs;
  final blocks = <String>{}.obs;
  final villages = <String>{}.obs;
  final mohallas = <String>{}.obs;
  final currentBlock = "".obs;
  final currentPanchayat = "".obs;
  final currentVillage = "".obs;
  final currentMohalla = "".obs;

  void fetchBlock(string) {
    QueryBuilder<Location> builder = objectBoxController.locationBox.query();
    builder.link(Location_.pin, Pincode_.pincode.equals(string));
    Query<Location> query = builder.build();
    locations.value = query.find();
    if (locations.isNotEmpty) {
      currentBlock.value = locations[0].block ?? " ";
      final list = [for (final location in locations) location.block!];
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
        panchayatSet.add(location.panchayat!);
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
    Set<String> mohallaSet = <String>{};
    int i = 0;
    for (final location in locations) {
      if (location.village == string &&
          i == 0 &&
          location.area != null &&
          location.panchayat == currentPanchayat.value &&
          location.block == currentBlock.value) {
        i = 1;
        currentMohalla.value = location.area!;
      }
      if (location.village == string &&
          location.panchayat == currentPanchayat.value &&
          location.block == currentBlock.value &&
          location.area != null) {
        mohallaSet.add(location.area!);
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
        supplierAddressController.text = cLocation.join(',');
      }
    }
    List<String> areaList = mohallaSet.toList();
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
          location.pin.target!.country
        };
        supplierAddressController.text = cLocation.join(',');
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    isUpdating.value = Get.arguments[0];
  }

  @override
  void onReady() async {
    super.onReady();
    if (isUpdating.value) {
      appBarText.value = 'update_supplier'.tr;
      updatingSupplier = Get.arguments[1];
      supplierNameController.text = updatingSupplier!.name!;
      if (updatingSupplier!.nickName != null) {
        supplierNickNameController.text = updatingSupplier!.nickName!;
      }
      if (updatingSupplier!.phone != null) {
        final phoneNumber = await libphone.PhoneNumberUtil()
            .parse(updatingSupplier!.phone ?? "");
        final isoCode = "+${phoneNumber.countryCode}";
        phoneList.first = PhoneNumber(
            phoneNumber: updatingSupplier!.phone ?? "", isoCode: isoCode);
      }
      if (updatingSupplier!.otherPhone != null &&
          updatingSupplier!.otherPhone!.isNotEmpty) {
        for (final phone in updatingSupplier!.otherPhone!) {
          final phoneNumber = await libphone.PhoneNumberUtil().parse(phone);
          final isoCode = "+${phoneNumber.countryCode}";
          phoneList.add(PhoneNumber(phoneNumber: phone, isoCode: isoCode));
        }
      }
      if (updatingSupplier!.account != null &&
          updatingSupplier!.account!.isNotEmpty) {
        for (final account in updatingSupplier!.account!) {
          accountList.add(TextEditingController(text: account));
        }
      }

      if (updatingSupplier!.address != null) {
        supplierAddressController.text = updatingSupplier!.address!;
      }
      if (updatingSupplier!.shopOrBusinessName != null) {
        supplierShopOrBusinessNameController.text =
            updatingSupplier!.shopOrBusinessName!;
      }

      currentLocationID.value = updatingSupplier!.location.targetId;
    }
  }

  addSupplier() async {
    try {
      isLoading.value = true;
      final supplier = Supplier()
        ..phone = phoneList[0].phoneNumber
        ..nickName = supplierNickNameController.text.trim().capitalizeFirst
        ..shopOrBusinessName = supplierShopOrBusinessNameController.text
        ..otherPhone = [
          for (final phone in phoneList.sublist(1)) phone.phoneNumber ?? ""
        ]
        ..account = [for (final account in accountList) account.text]
        ..name = supplierNameController.text.trim().capitalizeFirst
        ..address = supplierAddressController.text
        ..location.targetId = currentLocationID.value;
      if (isUpdating.value) {
        supplier.id = updatingSupplier!.id;
      }
      int id = objectBoxController.supplierBox.put(supplier);
      final names = supplierNameController.text.trim().split(" ");
      final phoneJsonList = [
        for (final phone in phoneList)
          {"number": phone.phoneNumber, "label": "mobile"}
      ];
      if (isUpdating.value && updatingSupplier!.contactListId != null) {
        if (names.length == 1) {
          currentContact.value = Contact.fromJson({
            "id": updatingSupplier!.contactListId,
            "displayName": supplierNameController.text.trim().capitalizeFirst,
            "name": {
              "first": names[0].trim().capitalizeFirst,
            },
            "phones": phoneJsonList
          });
        } else if (names.length == 2) {
          currentContact.value = Contact.fromJson({
            "id": updatingSupplier!.contactListId,
            "displayName": supplierNameController.text.trim().capitalizeFirst,
            "name": {
              "first": names[0].trim().capitalizeFirst,
              "last": names[1].trim().capitalizeFirst,
            },
            "phones": phoneJsonList
          });
        } else if (names.length == 3) {
          currentContact.value = Contact.fromJson({
            "id": updatingSupplier!.contactListId,
            "displayName": supplierNameController.text.trim().capitalizeFirst,
            "name": {
              "first": names[0].trim().capitalizeFirst,
              "middle": names[1].trim().capitalizeFirst,
              "last": names[2].trim().capitalizeFirst,
            },
            "phones": phoneJsonList
          });
        } else {
          currentContact.value = Contact.fromJson({
            "id": updatingSupplier!.contactListId,
            "displayName": supplierNameController.text.trim().capitalizeFirst,
            "phones": phoneJsonList
          });
        }
      } else {
        if (names.length == 1) {
          currentContact.value = Contact.fromJson({
            "displayName": supplierNameController.text.trim().capitalizeFirst,
            "name": {
              "first": names[0].trim().capitalizeFirst,
            },
            "phones": phoneJsonList
          });
        } else if (names.length == 2) {
          currentContact.value = Contact.fromJson({
            "displayName": supplierNameController.text.trim().capitalizeFirst,
            "name": {
              "first": names[0].trim().capitalizeFirst,
              "last": names[1].trim().capitalizeFirst,
            },
            "phones": phoneJsonList
          });
        } else if (names.length == 3) {
          currentContact.value = Contact.fromJson({
            "displayName": supplierNameController.text.trim().capitalizeFirst,
            "name": {
              "first": names[0].trim().capitalizeFirst,
              "middle": names[1].trim().capitalizeFirst,
              "last": names[2].trim().capitalizeFirst,
            },
            "phones": phoneJsonList
          });
        } else {
          currentContact.value = Contact.fromJson({
            "displayName": supplierNameController.text.trim().capitalizeFirst,
            "phones": phoneJsonList
          });
        }
      }
      final bool permissionGranted = await FlutterContacts.requestPermission();
      if (!isFromContact.value &&
          !permissionDenied.value &&
          permissionGranted &&
          isUpdating.value &&
          updatingSupplier!.contactListId != null) {
        await FlutterContacts.updateContact(currentContact.value);
      } else {
        final contact =
            await FlutterContacts.insertContact(currentContact.value);
        objectBoxController.supplierBox
            .put(supplier..contactListId = contact.id);
      }
      if (id != -1) {
        isLoading.value = false;
        if (!isAddMore.value) {
          Get.back();
          if (isUpdating.value) {
            successSnackBar(
              "supplier_updated_success_msg".tr,
            );
          } else {
            successSnackBar(
              "supplier_success_msg".tr,
            );
          }
        } else {
          supplierNameController.clear();
          supplierNickNameController.clear();
          supplierAddressController.clear();
          phoneList.value = [PhoneNumber(isoCode: 'IN')];
          accountList.value = [TextEditingController()];
          successSnackBar("supplier_success_msg".tr);
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
