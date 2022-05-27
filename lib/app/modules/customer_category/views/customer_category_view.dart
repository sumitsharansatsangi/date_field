import 'package:app/app/utils/network.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/app/widgets/overlay_searchfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/customer_category_controller.dart';

class CustomerCategoryView extends GetView<CustomerCategoryController> {
  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize * 1.5,
        child: SafeArea(
            child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomBack(),
              SearchField(
                controller: c.searchController,
                hint: "search_customer_category_here".tr,
                isDeviceConnected: networkController.connectionStatus.value,
                itemBuilder: (context, CustomerCategory suggestion) {
                  return ListTile(
                    title: AutoSizeText(suggestion.name ?? " ",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleLarge),
                  );
                },
                noItemText: "no_customer_category_found".tr,
                onSuggestionSelected: (CustomerCategory suggestion) async {
                  c.searchController.clear();
                  c.addSearchedCategory(suggestion);
                  c.openBottomSheet(suggestion);
                },
                suggestionsCallback: (pattern) {
                  return c.searchCategories(pattern);
                },
              ),
            ],
          ),
        )),
      ),
      body: Obx(() => c.searchedCategoryList.isEmpty
          ?
          // Column(
          //     children: [
          //       Container(
          //         color: Colors.deepPurple,
          //         child: Text("The quick brown fox jumps over the lazy dog",
          //             style: Get.textTheme.headlineLarge),
          //       ),
          //       Text("The quick brown fox jumps over the lazy dog",
          //           style: Get.textTheme.titleLarge),
          //       Text("The quick brown fox jumps over the lazy dog",
          //           style: Get.textTheme.labelLarge),
          //       Text("The quick brown fox jumps over the lazy dog",
          //           style: Get.textTheme.headlineMedium),
          //       Text("The quick brown fox jumps over the lazy dog",
          //           style: Get.textTheme.titleMedium),
          //       Text("The quick brown fox jumps over the lazy dog",
          //           style: Get.textTheme.labelMedium),
          //       Text("The quick brown fox jumps over the lazy dog",
          //           style: Get.textTheme.headlineSmall),
          //       Text("The quick brown fox jumps over the lazy dog",
          //           style: Get.textTheme.titleSmall),
          //       Text("The quick brown fox jumps over the lazy dog",
          //           style: Get.textTheme.labelSmall),
          //     ],
          //   )
          // Column(
          //     children: [
          //       FittedBox(
          //         fit: BoxFit.scaleDown,
          //         child: Container(
          //           color: Colors.deepPurple,
          //           child: Text("Mandy Muse is the best",
          //               // stepGranularity: 1.sp,
          //               // minFontSize: 8.sp,
          //               style: Get.textTheme.headlineLarge),
          //         ),
          //       ),
          //       FittedBox(
          //         fit: BoxFit.scaleDown,
          //         child: Text("Lana Rhoades is the most sexiest",
          //             // stepGranularity: 1.sp,
          //             // minFontSize: 8.sp,
          //             style: Get.textTheme.titleLarge),
          //       ),
          //       FittedBox(
          //         fit: BoxFit.scaleDown,
          //         child: Text("Mia Malkova is the Most Flexible.",
          //             // stepGranularity: 1.sp,
          //             // minFontSize: 8.sp,
          //             style: Get.textTheme.labelLarge),
          //       ),
          //       FittedBox(
          //         fit: BoxFit.scaleDown,
          //         child: Text("Natasha nice is chubby.",
          //             // stepGranularity: 1.sp,
          //             // minFontSize: 8.sp,
          //             style: Get.textTheme.headlineMedium),
          //       ),
          //       FittedBox(
          //         fit: BoxFit.scaleDown,
          //         child: Text("Emy Willis is the Skinniest.",
          //             // stepGranularity: 1.sp,
          //             // minFontSize: 8.sp,
          //             style: Get.textTheme.titleMedium),
          //       ),
          //       FittedBox(
          //         fit: BoxFit.scaleDown,
          //         child: Text("Angela White is a hunk Milf body.",
          //             // stepGranularity: 1.sp,
          //             // minFontSize: 8.sp,
          //             style: Get.textTheme.labelMedium),
          //       ),
          //       FittedBox(
          //         fit: BoxFit.scaleDown,
          //         child: Text("Abella Danger is gorgeous.",
          //             // stepGranularity: 1.sp,
          //             // minFontSize: 8.sp,
          //             style: Get.textTheme.headlineSmall),
          //       ),
          //       FittedBox(
          //         fit: BoxFit.scaleDown,
          //         child:
          //             Text("Adriana Chechik is a fucking girl and loves anal.",
          //                 // stepGranularity: 1.sp,
          //                 // minFontSize: 8.sp,
          //                 style: Get.textTheme.titleSmall),
          //       ),
          //       FittedBox(
          //         fit: BoxFit.scaleDown,
          //         child: Text("Shasha Grey is a beautipie.",
          //             // stepGranularity: 1.sp,
          //             // minFontSize: 8.sp,
          //             style: Get.textTheme.labelSmall),
          //       ),
          //     ],
          //   )
          SearchWidget(
              text: 'start_searching_customer_category'.tr,
            )
          : ListView.builder(
              itemCount: c.searchedCategoryList.length,
              itemBuilder: (_, index) {
                final DateTime dateTime =
                    c.searchedCategoryList[index].datetime;
                final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                final String formattedDate = formatter.format(dateTime);
                return ListContainer(
                  child: ListTile(
                      title: AutoSizeText(
                        c.searchedCategoryList[index].searchedCategory.target!
                                .name ??
                            "",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Get.textTheme.titleLarge,
                      ),
                      subtitle: AutoSizeText(formattedDate,
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: Get.textTheme.titleSmall),
                      trailing: DeleteButton(
                        onDelete: () {
                          c.deleteSearchedCustomerCategory(
                              c.searchedCategoryList[index].id!);
                          c.fetchSearchedCustomerCategory();
                        },
                      ),
                      onLongPress: () async {
                        await Get.toNamed(Routes.CREATE_CUSTOMER_CATEGORY,
                            arguments: [
                              true,
                              c.searchedCategoryList[index].searchedCategory
                                  .target!,
                            ]);
                        c.fetchSearchedCustomerCategory();
                      },
                      onTap: () => c.openBottomSheet(
                            c.searchedCategoryList[index].searchedCategory
                                .target!,
                          )),
                );
              })),
      floatingActionButton: Column(
        children: [
          Spacer(),
          FloatingButton(
              heroTag: 'list',
              onPressed: () async {
                await Get.toNamed(Routes.LIST_CUSTOMER_CATEGORY);
                c.fetchSearchedCustomerCategory();
              },
              text: "view_customer_category_n".tr,
              icon: Icons.menu),
          SizedBox(height: 20.h),
          FloatingButton(
              heroTag: 'add',
              onPressed: () {
                Get.toNamed(Routes.CREATE_CUSTOMER_CATEGORY,
                    arguments: [false]);
              },
              text: "add_customer_category_n".tr,
              icon: Icons.add),
        ],
      ),
    );
  }
}
