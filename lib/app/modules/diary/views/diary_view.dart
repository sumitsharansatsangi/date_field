import 'package:app/app/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:speed_up_get/speed_up_get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/diary_controller.dart';

class DiaryView extends GetView<DiaryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(titleText: c.appBarText, actions: [
        IconButton(
            onPressed: () => c.chooseDateRangePicker(),
            icon: Icon(Icons.date_range_rounded))
      ]),
      body: Obx(() => c.diaryList.isEmpty
          ? NoItemWidget(
              noText: "no_diary".tr,
              addText: "add_no_diary".tr,
              onPressed: () async {
                await Get.toNamed(Routes.CREATE_DIARY, arguments: [false]);
                c.diaryList.value = c.objectBoxController.diaryBox.getAll();
              },
            )
          : ListView.builder(
              itemCount: c.diaryList.length,
              itemBuilder: (_, index) {
                final DateTime dateOfCreation =
                    c.diaryList[index].dateOfCreation;
                final DateTime dateOfUpdation =
                    c.diaryList[index].dateOfUpdation!;
                final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm:a');
                final String formattedDateOfCreation =
                    formatter.format(dateOfCreation);
                final String formattedDateOfUpdation =
                    formatter.format(dateOfUpdation);
                return Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(bottom: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.5),
                        spreadRadius: 5.sp,
                        blurRadius: 7.sp,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(c.diaryList[index].title ?? " "),
                    trailing: IconButton(
                        onPressed: () => c.objectBoxController.diaryBox
                            .remove(c.diaryList[index].id!),
                        icon: Icon(Icons.delete)),
                    onTap: () {
                      Get.toNamed(Routes.CREATE_DIARY,
                          arguments: [true, c.diaryList[index]]);
                      c.diaryList.value =
                          c.objectBoxController.diaryBox.getAll();
                    },
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text('${"updated_at".tr}: '),
                            Text(formattedDateOfUpdation),
                          ],
                        ),
                        Row(
                          children: [
                            Text('${"created_at".tr}: '),
                            Text(formattedDateOfCreation),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              })),
      floatingActionButton: FloatingButton(
          heroTag: 'add',
          onPressed: () async {
            await Get.toNamed(Routes.CREATE_DIARY, arguments: [false]);
            c.diaryList.value = c.objectBoxController.diaryBox.getAll();
          },
          text: "write_diary".tr,
          icon: Icons.create_outlined),
    );
  }
}
