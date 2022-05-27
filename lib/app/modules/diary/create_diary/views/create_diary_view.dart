import 'package:app/app/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:speed_up_get/speed_up_get.dart';
import '../controllers/create_diary_controller.dart';

class CreateDiaryView extends GetView<CreateDiaryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(titleText: c.appBarText, actions: [
        IconButton(
            icon: Icon(Icons.save, size: 20.sp),
            onPressed: () {
              c.addDiary();
            })
      ]),
      body: Center(
          child: Column(
        children: [
          quill.QuillToolbar.basic(controller: c.contentController),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                Text(
                  "title",
                  style: TextStyle(fontSize: 13.sp),
                ),
                SizedBox(
                  height: 25.h,
                  child: quill.QuillEditor.basic(
                    controller: c.titleController,
                    readOnly: false, // true for view only mode
                  ),
                ),
                Divider(),
                Text(
                  "content",
                  style: TextStyle(fontSize: 13.sp),
                ),
                quill.QuillEditor.basic(
                  controller: c.contentController,
                  readOnly: false, // true for view only mode
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
