import 'package:app/app/data/model.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/alphabets_scroll.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:speed_up_get/speed_up_get.dart';
import '../controllers/receipt_controller.dart';

class ReceiptView extends GetView<ReceiptController> {
  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize * 1.2,
          child: SafeArea(
              child: Center(
            child: Row(
              children: [
                CustomBack(),
                SearchField<Receipt>(
                  controller: c.searchController,
                  hint: "search_receipt_here".tr,
                  isDeviceConnected: networkController.connectionStatus.value,
                  itemBuilder: (context, Receipt suggestion) {
                    return ListTile(
                      title:
                          AutoSizeText("${suggestion.customer.target!.name}"),
                    );
                  },
                  noItemText: "no_store_room_found".tr,
                  onSuggestionSelected: (Receipt suggestion) {
                    c.searchController.clear();
                    c.addSearchedReceipt(suggestion);
                    Get.toNamed(Routes.UPDATE_RECEIPT,
                        arguments: [suggestion, true]);
                  },
                  suggestionsCallback: (pattern) {
                    return c.searchReceiptWithCustomerName(pattern);
                  },
                ),
                Container(
                  width: 1.sh > 1.sw ? 0.85.sw : 0.85.sh,
                  padding: EdgeInsets.only(top: Get.height * 0.01),
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: c.searchController,
                        cursorColor: Colors.deepPurple.shade100,
                        autocorrect: true,
                        autofocus: true,
                        style: TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                          fontSize: 16.sp,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepPurple,
                          hintStyle: TextStyle(
                              color: Colors.deepPurple.shade100,
                              fontSize: 16.sp),
                          hintText: "search_receipt_here".tr,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.deepPurple.shade50,
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurple.shade200),
                              borderRadius: BorderRadius.circular(30)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurple.shade200),
                              borderRadius: BorderRadius.circular(30)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurple.shade200),
                              borderRadius: BorderRadius.circular(30)),
                        )),
                    suggestionsCallback: (pattern) {
                      return c.searchReceiptWithCustomerName(pattern);
                    },
                    itemBuilder: (context, Receipt suggestion) {
                      return ListTile(
                        title:
                            AutoSizeText("${suggestion.customer.target!.name}"),
                      );
                    },
                    onSuggestionSelected: (Receipt suggestion) {
                      c.searchController.clear();
                      c.addSearchedReceipt(suggestion);
                      Get.toNamed(Routes.UPDATE_RECEIPT,
                          arguments: [suggestion, true]);
                    },
                  ),
                ),
              ],
            ),
          )),
        ),
        body: Obx(
          () => c.searchedReceiptList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome_motion_outlined, size: 30.sp),
                      AutoSizeText("no_receipt".tr,
                          style: TextStyle(fontSize: 16.sp)),
                      ElevatedButton.icon(
                          onPressed: () => Get.toNamed(Routes.CREATE_COMPANY),
                          icon: Icon(Icons.add),
                          label: AutoSizeText("add_no_receipt".tr)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: AlphabetScrollView(
                        list: c.searchedReceiptList
                            .map((e) =>
                                AlphaModel(e, "${e.customer.target!.name}"))
                            .toList(),
                        itemBuilder: (_, k, e) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: ListTile(
                              onTap: () {
                                Get.toNamed(Routes.UPDATE_RECEIPT,
                                    arguments: [e, true]);
                              },
                              title: Text(e.name),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
        ));
  }
}
