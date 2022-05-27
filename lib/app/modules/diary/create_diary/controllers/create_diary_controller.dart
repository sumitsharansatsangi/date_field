import 'dart:convert';

import 'package:app/app/data/model.dart';
import 'package:app/app/utils/objectbox.dart';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class CreateDiaryController extends GetxController {
  final appBarText = 'diary'.tr.obs;
  Diary? updatingDiary;
  QuillController titleController = QuillController.basic();
  QuillController contentController = QuillController.basic();
  final objectBoxController = Get.find<ObjectBoxController>();
  final isLoading = false.obs;
  final isUpdating = false.obs;

  @override
  void onReady() {
    super.onReady();
    isUpdating.value = Get.arguments[0];
    if (isUpdating.value) {
      appBarText.value = 'update_diary'.tr;
      updatingDiary = Get.arguments[1];
      final title = jsonDecode(updatingDiary!.title ?? "");
      titleController = QuillController(
          document: Document.fromJson(title),
          selection: TextSelection.collapsed(offset: 0));
      final content = jsonDecode(updatingDiary!.content ?? "");
      contentController = QuillController(
          document: Document.fromJson(content),
          selection: TextSelection.collapsed(offset: 0));
    }
  }

  addDiary() {
    try {
      isLoading.value = true;
      final title = jsonEncode(titleController.document.toDelta().toJson());
      final content = jsonEncode(contentController.document.toDelta().toJson());
      final diary = Diary()
        ..title = title
        ..content = content;
      if (isUpdating.value) {
        diary.id = updatingDiary!.id!;
      }
      int id = objectBoxController.diaryBox.put(diary);
      if (id != -1) {
        isLoading.value = false;
        Get.back();
        if (isUpdating.value) {
          successSnackBar("diary_success_msg".tr);
        } else {
          successSnackBar("diary_updated_success_msg".tr);
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
