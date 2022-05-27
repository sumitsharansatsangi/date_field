import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiaryController extends GetxController {
  final objectBoxController = Get.find<ObjectBoxController>();
  final diaryList = <Diary>[].obs;
  final appBarText = 'diary'.tr.obs;
  final dateRange = DateTimeRange(
          start: DateTime.now(),
          end: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 6))
      .obs;

  @override
  void onReady() {
    super.onReady();
    diaryList.value = objectBoxController.diaryBox.getAll();
  }

  chooseDateRangePicker() async {
    DateTimeRange? picked = await showDateRangePicker(
        context: Get.context!,
        firstDate: DateTime(DateTime.now().year - 20),
        lastDate: DateTime(DateTime.now().year + 20),
        initialDateRange: DateTimeRange(
            start: DateTime.now(),
            end: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 6)));
    if (picked != null && picked != dateRange.value) {
      dateRange.value = picked;
    }
  }
}
