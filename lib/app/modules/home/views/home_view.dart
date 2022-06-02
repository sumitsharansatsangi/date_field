import 'dart:math';

import 'package:app/app/data/model.dart';
import 'package:app/app/modules/calc/controllers/calc_controller.dart';
import 'package:app/app/modules/calc/views/calc_view.dart';
import 'package:app/app/routes/app_pages.dart';
// import 'package:app/app/utils/network.dart';
import 'package:app/app/utils/pdf_api_service.dart';
import 'package:app/app/widgets/autosize_textfield.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as a;
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final gradient = LinearGradient(
    colors: [
      Color(0xFF6400FF),
      Color(0xFF7700FF),
    ],
  );
  @override
  Widget build(BuildContext context) {
    // final networkController = Get.find<NetworkController>();
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('exit_app_msg'.tr),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('no'.tr),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('yes'.tr),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(gradient: gradient),
              ),
              actions: [
                // IconButton(
                //     onPressed: () {
                //       String address = "भविष्य की तिथि";
                //       for (int i = 0; i < address.length; i++) {
                //         print(address[i]);
                //         if (address[i] == "ि") {
                //           print("matched");
                //         }
                //       }
                //     },
                //     icon: Icon(Icons.view_agenda_outlined)),
                IconButton(
                  onPressed: () {
                    Get.put(
                      CalcController(),
                    );
                    Get.defaultDialog(
                        title: "Calculator",
                        contentPadding: EdgeInsets.zero,
                        content: CalcView(),
                        barrierDismissible: false);
                  },
                  icon: Icon(UniconsLine.calculator),
                ),
                IconButton(
                  icon: Icon(Icons.save_sharp),
                  onPressed: () async {
                    if (c.receiptItemList.isNotEmpty) {
                      Receipt receipt = await c.addReceipt();
                      final pdfFile = await PdfReceiptApi().generate(receipt);
                      c.updateItems();
                      await Get.toNamed(Routes.PDF, arguments: [
                        "Receipt",
                        pdfFile.path,
                        c.currentCustomer.value!.phone ?? "9931265823",
                        "thank_msg".tr
                      ]);
                      c.total.value = 0.0;
                      c.receiptItemList.value = [];
                      c.isCustomerEditing.value = true;
                      c.currentCustomer.value = null;
                      c.currentItem.value = null;
                      c.quantityUnit.value = null;
                      // PdfApi.openFile(pdfFile);
                    }
                  },
                ),
                IconButton(
                  onPressed: () async {
                    if (c.receiptItemList.isNotEmpty) {
                      final box = context.findRenderObject() as RenderBox?;
                      Receipt receipt = await c.addReceipt();
                      final pdfFile = await PdfReceiptApi().generate(receipt);
                      await Share.shareFilesWithResult([pdfFile.path],
                          subject: "receipt_share_subject",
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size);
                      c.total.value = 0.0;
                      c.receiptItemList.value = [];
                      c.isCustomerEditing.value = true;
                      c.currentCustomer.value = null;
                      c.currentItem.value = null;
                      c.quantityUnit.value = null;
                      // c.chooseDateRangePicker();
                    }
                  },
                  icon: Icon(Icons.send),
                )
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    margin: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('user name',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Color.fromARGB(255, 232, 232, 233))),
                            Text('user@userid.com',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Color.fromARGB(255, 232, 232, 233),
                                ))
                          ],
                        ),
                        FlutterSwitch(
                          width: 90.w,
                          height: 40.h,
                          toggleSize: 45.sp,
                          value: Get.isDarkMode,
                          borderRadius: 30.r,
                          padding: 2.r,
                          activeToggleColor: Color(0xFF6E40C9),
                          inactiveToggleColor: Color(0xFF2F363D),
                          activeSwitchBorder: Border.all(
                            color: Color(0xFF3C1E70),
                            width: 6.0,
                          ),
                          inactiveSwitchBorder: Border.all(
                            color: Color(0xFFD1D5DA),
                            width: 6.0,
                          ),
                          activeColor: Color(0xFF271052),
                          inactiveColor: Colors.white,
                          activeIcon: Icon(
                            Icons.nightlight_round,
                            color: Color(0xFFF8E3A1),
                          ),
                          inactiveIcon: Icon(
                            Icons.wb_sunny,
                            color: Color(0xFFFFDF5D),
                          ),
                          onToggle: (val) {
                            final box = GetStorage();
                            Get.changeThemeMode(
                              Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                            );
                            box.write('darkMode', val);
                          },
                        ),
                        SizedBox(
                          width: 0.5.w,
                        )
                      ],
                    ),
                  ),
                  ObxValue(
                      (data) => FlutterSwitch(
                          valueFontSize: 12.sp,
                          width: 100.w,
                          showOnOff: true,
                          activeColor: Color.fromARGB(255, 118, 73, 243),
                          inactiveColor: Color.fromARGB(255, 235, 230, 243),
                          activeTextColor: Color.fromARGB(255, 235, 230, 243),
                          inactiveTextColor: Color.fromARGB(255, 118, 73, 243),
                          activeText: "Hindi",
                          inactiveText: "English",
                          value: c.isHindi.value,
                          onToggle: (value) async {
                            c.isHindi.value = value;
                            value
                                ? await Get.updateLocale(Locale('hi', 'IN'))
                                : await Get.updateLocale(Locale('en', 'US'));

                            final box = GetStorage();
                            box.write('isHindi', value);
                          }),
                      false.obs)
                ],
              ),
            ),
            body: Stack(
              children: [
                Center(
                  child: ListView(children: [
                    SizedBox(height: 10.h),
                    Center(
                      child: a.GradientText(
                        "receipt_header".tr,
                        gradient: gradient,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.r),
                        child: Obx(() => DropDownSearchField<Customer>(
                              selectedItem: c.currentCustomer.value,
                              allowDecoration: false,
                              onPressed: () async {
                                await Get.toNamed(Routes.CREATE_CUSTOMER,
                                    arguments: [false]);
                                c.customerList.value =
                                    c.objectBoxController.customerBox.getAll();
                              },
                              items: c.customerList,
                              label: "customer".tr,
                              searchHint: "search_customer_here".tr,
                              notFoundText: "no_customer_found".tr,
                              itemAsString: (customer) {
                                return customer != null
                                    ? customer.name ?? " "
                                    : " ";
                              },
                              onChanged: (customer) {
                                if (customer != null) {
                                  c.currentCustomer.value = customer;
                                }
                              },
                              popupItemBuilder: (context, customer, b) {
                                return SizedBox(
                                    child: ListTile(
                                  title: Text("${customer.name}",
                                      style: TextStyle(fontSize: 14.sp)),
                                  subtitle: Text(customer.nickName ?? " ",
                                      style: TextStyle(fontSize: 13.sp)),
                                ));
                              },
                            )),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Obx(() => c.total.value == 0.0
                        ? const Text("")
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                                SizedBox(
                                    width: 0.25 * Get.width,
                                    child: Text("item_name".tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp))),
                                SizedBox(
                                    width: 0.25 * Get.width,
                                    child: Text("quantity".tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp))),
                                SizedBox(
                                    width: 0.25 * Get.width,
                                    child: Text("price".tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp))),
                              ])),
                    Obx(
                      () {
                        return ListView.builder(
                          physics:
                              const NeverScrollableScrollPhysics(), // <= This was the key for me
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: Get.height * 0.05,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                      width: Get.width * 0.25,
                                      child: AutoSizeText(c
                                              .receiptItemList[index]
                                              .item
                                              .target!
                                              .purchasedItem
                                              .target!
                                              .item
                                              .target!
                                              .name ??
                                          " ")),
                                  SizedBox(
                                      width: Get.width * 0.25,
                                      child: AutoSizeText(
                                          "${c.receiptItemList[index].quantity.toString()} ${c.quantityList[index].shortName}")),
                                  SizedBox(
                                      width: Get.width * 0.25,
                                      child: AutoSizeText(
                                          (c.receiptItemList[index].soldPrice! *
                                                  c.receiptItemList[index]
                                                      .quantity!)
                                              .toString())),
                                ],
                              ),
                            );
                          },
                          itemCount: c.receiptItemList.length,
                        );
                      },
                    ),
                    Obx(
                      () => c.total.value == 0.0
                          ? const Text("")
                          : Divider(
                              color: Colors.black,
                              height: 20,
                              thickness: 2,
                              indent: 0.2 * Get.width,
                              endIndent: 0.2 * Get.width,
                            ),
                    ),
                    Obx(() => c.total.value == 0.0
                        ? const Text("")
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  width: Get.width * 0.25,
                                  child: const Text("")),
                              SizedBox(
                                  width: Get.width * 0.25,
                                  child: Text("${"total".tr}: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp))),
                              SizedBox(
                                  width: Get.width * 0.25,
                                  child: AutoSizeText(c.total.value.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp))),
                            ],
                          )),
                    Center(
                        child: Obx(() => DropDownSearchField<PurchasedItem>(
                              selectedItem: c.currentItem.value,
                              allowCreation: false,
                              items: c.itemList,
                              allowDecoration: false,
                              searchHint: "search_item_here".tr,
                              notFoundText: "no_item_found".tr,
                              label: "item".tr,
                              itemAsString: (item) {
                                return item != null
                                    ? item.purchasedItem.target!.item.target!
                                            .name ??
                                        ""
                                    : "";
                              },
                              onChanged: (item) {
                                if (item != null) {
                                  c.soldPriceController.text =
                                      item.sellingPrice.toString();
                                  c.currentItem.value = item;
                                }
                              },
                              popupItemBuilder: (context, item, b) {
                                return SizedBox(
                                    child: ListTile(
                                  title: Column(
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                            "${item.purchasedItem.target!.item.target!.company.target!.name} ${item.purchasedItem.target!.item.target!.name ?? " "}",
                                            style: TextStyle(fontSize: 11.sp)),
                                      ),
                                      SizedBox(height: 5.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'color'.tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.sp),
                                              ),
                                              Text(
                                                  item.purchasedItem.target!
                                                          .color ??
                                                      "",
                                                  style: TextStyle(
                                                      fontSize: 11.sp)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'size'.tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.sp),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                    item.purchasedItem.target!
                                                            .size ??
                                                        "",
                                                    style: TextStyle(
                                                        fontSize: 11.sp)),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'model'.tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.sp),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  item.purchasedItem.target!
                                                          .model ??
                                                      "",
                                                  style: TextStyle(
                                                      fontSize: 11.sp),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'TQ'.tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp),
                                          ),
                                          Text(
                                              "${item.purchasedQuantity.toString()} ${item.purchasedQuantityUnit.target!.shortName ?? " "}",
                                              style:
                                                  TextStyle(fontSize: 11.sp)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'CQ'.tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp),
                                          ),
                                          Text(
                                              "${item.currentQuantity.toString()} ${item.currentQuantityUnit.target!.shortName ?? " "}",
                                              style:
                                                  TextStyle(fontSize: 11.sp)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'PP'.tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp),
                                          ),
                                          AutoSizeText(
                                              "${item.purchasingPrice.toString()} / ${item.purchasingPriceUnit.target!.shortName ?? " "}",
                                              stepGranularity: 1.sp,
                                              minFontSize: 8.sp,
                                              style:
                                                  TextStyle(fontSize: 11.sp)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          AutoSizeText(
                                            'SP'.tr,
                                            stepGranularity: 1.sp,
                                            minFontSize: 8.sp,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp),
                                          ),
                                          AutoSizeText(
                                            "${item.sellingPrice.toString()} / ${item.sellingPriceUnit.target!.shortName ?? " "} ",
                                            stepGranularity: 1.sp,
                                            minFontSize: 8.sp,
                                            style: TextStyle(fontSize: 11.sp),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ));
                              },
                            ))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 0.01 * Get.width,
                        ),
                        SizedBox(
                          width: 0.2 * Get.width,
                          child: AutoSizeTextField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.deepPurple,
                                fontStyle: FontStyle.italic,
                              ),
                              controller: c.soldPriceController,
                              decoration: InputDecoration(
                                hintText: "100.00",
                                hintStyle: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.deepPurple.shade200),
                              )),
                        ),
                        SizedBox(
                          width: 0.01 * Get.width,
                        ),
                        SizedBox(
                          width: 0.2 * Get.width,
                          child: AutoSizeTextField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.deepPurple,
                                fontStyle: FontStyle.italic,
                              ),
                              controller: c.quantityController,
                              decoration: InputDecoration(
                                hintText: "quantity".tr,
                                hintStyle: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.deepPurple.shade200),
                              )),
                        ),
                        SizedBox(
                          width: 0.01 * Get.width,
                        ),
                        SizedBox(
                            width: 0.4 * Get.width,
                            child: Obx(() => DropDownSearchField<Unit>(
                                selectedItem: c.quantityUnit.value,
                                items: c.unitList,
                                hint: "unit".tr,
                                popupTitle: "unit".tr,
                                onPressed: () async {
                                  await Get.toNamed(Routes.CREATE_UNIT,
                                      arguments: [false]);
                                  c.unitList.value =
                                      c.objectBoxController.unitBox.getAll();
                                },
                                allowDecoration: false,
                                searchHint: "search_unit_here".tr,
                                notFoundText: "no_unit_found".tr,
                                itemAsString: (unit) {
                                  return unit != null
                                      ? unit.fullName ?? ""
                                      : "";
                                },
                                onChanged: (unit) {
                                  if (unit != null) {
                                    c.quantityUnit.value = unit;
                                  }
                                },
                                popupItemBuilder: (_, unit, b) {
                                  return ListTile(
                                    title: AutoSizeText(unit.fullName ?? ""),
                                    trailing:
                                        AutoSizeText(unit.shortName ?? ""),
                                  );
                                }))),
                        SizedBox(
                          width: 0.01 * Get.width,
                        ),
                        SizedBox(
                            width: 0.05 * Get.width,
                            child: IconButton(
                              icon: Icon(CupertinoIcons.check_mark_circled,
                                  color: Colors.green, size: 20.sp),
                              onPressed: () {
                                if (c.currentItem.value == null) {
                                  customSnackBar(
                                      "error".tr,
                                      "no_item".tr,
                                      Colors.red.shade100,
                                      Color.fromARGB(255, 245, 178, 172),
                                      Colors.red.shade700);
                                } else if (c.quantityController.text.isEmpty) {
                                  customSnackBar(
                                      "error".tr,
                                      "no_quantity".tr,
                                      Colors.red.shade100,
                                      Color.fromARGB(255, 245, 178, 172),
                                      Colors.red.shade700);
                                } else if (c.quantityUnit.value == null) {
                                  customSnackBar(
                                      "error".tr,
                                      "no_unit".tr,
                                      Colors.red.shade100,
                                      Color.fromARGB(255, 245, 178, 172),
                                      Colors.red.shade700);
                                } else {
                                  c.addToReceipt();
                                  c.quantityController.clear();
                                  c.soldPriceController.clear();
                                }
                              },
                            )),
                        SizedBox(
                          width: 0.025 * Get.width,
                        ),
                      ],
                    ),
                    // Obx(() => Text("Start: " +
                    //     DateFormat("dd-MM-yyyy")
                    //         .format(c.dateRange.value.start)
                    //         .toString())),
                    // Obx(() => Text("end: " +
                    //     DateFormat("dd-MM-yyyy")
                    //         .format(c.dateRange.value.end)
                    //         .toString())),
                    SizedBox(height: 0.7 * Get.height),
                  ]),
                ),
                DraggableScrollableSheet(
                  builder: (BuildContext buildContext,
                      ScrollController scrollController) {
                    return Center(
                      child: Container(
                        width: min(65.r * 4, 0.9.sw),
                        child: GridView.extent(
                          shrinkWrap: true,
                          children: [
                            Button(Routes.ITEM, CupertinoIcons.cube_box,
                                "item".tr),
                            Button(
                                Routes.ITEM_VARIANT,
                                CupertinoIcons.rectangle_3_offgrid,
                                "item_variant_n".tr),
                            Button(Routes.ITEM_CATEGORY, Icons.category,
                                "item_category_n".tr),
                            Button(Routes.CUSTOMER, CupertinoIcons.person_solid,
                                "customer".tr),
                            Button(
                                Routes.CUSTOMER_CATEGORY,
                                CupertinoIcons.person_3_fill,
                                "customer_category_n".tr),
                            Button(Routes.SUPPLIER, CupertinoIcons.person_alt,
                                "supplier".tr),
                            Button(
                                Routes.COMPANY, Icons.business, "company".tr),
                            Button(
                                Routes.GODOWN, Icons.home_filled, "godown".tr),
                            Button(Routes.STORE_ROOM, Icons.meeting_room,
                                'store_room_n'.tr),
                            Button(
                                Routes.ALMIRAH,
                                CupertinoIcons.rectangle_split_3x3,
                                "almirah".tr),
                            Button(Routes.PURCHASED_ITEM, CupertinoIcons.gift,
                                "purchased_item_n".tr),
                            Button(Routes.UNIT, Icons.all_inbox_outlined,
                                "unit".tr),
                            // Button(Routes.RECEIPT, Icons.library_books_rounded,
                            //     "receipt".tr),
                            Button(
                                Routes.DIARY, CupertinoIcons.book, "diary".tr),
                            // Button(
                            //     Routes.ANALYTICS, Icons.analytics, "analytics".tr),
                            // Button(
                            //     Routes.REPORTS, Icons.picture_as_pdf, "report".tr),
                            Button(Routes.PURCHASE_ORDER, Icons.checklist_rtl,
                                "purchase_order_n".tr),
                            // Button(Routes.SALES_ORDER, Icons.checklist,
                            //     "sales_order_n".tr),
                          ],
                          controller: scrollController,
                          maxCrossAxisExtent: 70.h,
                          padding: EdgeInsets.all(8.r),
                        ),
                      ),
                    );
                  },
                  initialChildSize: 0.1,
                  minChildSize: 0.1,
                  maxChildSize: 0.2,
                ),
              ],
            )));
  }
}
