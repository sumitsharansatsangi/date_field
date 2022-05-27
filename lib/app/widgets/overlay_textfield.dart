// import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:transliteration/response/transliteration_response.dart';
import 'package:transliteration/transliteration.dart';

import 'autosize_textfield.dart';

class TextFieldWidget extends StatefulWidget {
  TextFieldWidget(
      {Key? key,
      this.keyboardType = TextInputType.text,
      this.validator,
      required this.labelText,
      this.hint,
      required this.textEditingController,
      required this.isDeviceConnected,
      this.maxline = 1,
      this.suffixIcon})
      : super(key: key);
  final String labelText;
  final String? hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final bool isDeviceConnected;
  final int maxline;
  final Widget? suffixIcon;
  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final focusNode = FocusNode();
  final layerLink = LayerLink();
  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        hideOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: CompositedTransformTarget(
          link: layerLink,
          child: AutoSizeTextField(
            stepGranularity: 1.sp,
            minFontSize: 8.sp,
            maxLines: widget.maxline,
            style:
                TextStyle(fontSize: 15.sp, color: Colors.deepPurple.shade500),
            autofocus: false,
            onEditingComplete: () async {
              if (widget.isDeviceConnected) {
                hideOverlay();
                try {
                  TransliterationResponse? response =
                      await Transliteration.transliterate(
                          widget.textEditingController.text, Languages.HINDI);
                  final List<String> suggestion =
                      response!.transliterationSuggestions;
                  showOverlay(suggestion);
                } on Exception {
                  Get.snackbar("no_internet_title".tr, "no_internet_msg".tr,
                      colorText: Colors.white,
                      backgroundGradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 0, 0),
                          Color.fromARGB(255, 253, 72, 0),
                        ],
                      ));
                }
              } else {
                Get.snackbar("no_internet_title".tr, "no_internet_msg".tr,
                    colorText: Colors.white,
                    backgroundGradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 0, 0),
                        Color.fromARGB(255, 253, 72, 0),
                      ],
                    ));
              }
            },
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            focusNode: focusNode,
            controller: widget.textEditingController,
            decoration: InputDecoration(
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: Color.fromARGB(255, 236, 234, 250),
              isDense: true, // Added this
              contentPadding: EdgeInsets.all(15.r),
              hintStyle: TextStyle(fontSize: 15.sp),
              border: const OutlineInputBorder(),
              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 13.sp),
              hintText: widget.hint,
              label: Text(widget.labelText, style: TextStyle(fontSize: 15.sp)),
            ),
          ),
        ),
      ),
    );
  }

  void showOverlay(suggestion) {
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    entry = OverlayEntry(
        builder: (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 8),
                link: layerLink,
                child: buildOverlay(suggestion))));
    overlay.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  Widget buildOverlay(List<String> suggestion) => Material(
      elevation: 8,
      child: Center(
        child: Container(
            // color: Colors.red.shade50,
            child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return ListTile(
                      title: Text(suggestion[index]),
                      onTap: () {
                        widget.textEditingController.text = suggestion[index];
                        hideOverlay();
                        focusNode.unfocus();
                      });
                },
                itemCount: suggestion.length)),
      ));
}
