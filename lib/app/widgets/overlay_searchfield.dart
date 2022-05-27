import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:transliteration/response/transliteration_response.dart';
import 'package:transliteration/transliteration.dart';

class SearchField<T> extends StatefulWidget {
  SearchField(
      {Key? key,
      required this.hint,
      required this.isDeviceConnected,
      required this.suggestionsCallback,
      required this.itemBuilder,
      required this.onSuggestionSelected,
      required this.controller,
      required this.noItemText})
      : super(key: key);
  final String hint;
  final bool isDeviceConnected;
  final ItemBuilder<T> itemBuilder;
  final SuggestionsCallback<T> suggestionsCallback;
  final SuggestionSelectionCallback<T> onSuggestionSelected;
  final TextEditingController controller;
  final String noItemText;
  @override
  SearchFieldState<T> createState() => SearchFieldState<T>();
}

class SearchFieldState<T> extends State<SearchField<T>> {
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
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6400FF),
              Color(0xFF7700FF),
            ],
          ),
          // color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(30), //border corner radius
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.5), //color of shadow
              spreadRadius: 5.sp, //spread radius
              blurRadius: 7.sp, // blur radius
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        width: 1.sh > 1.sw ? 0.75.sw : 0.75.sh,
        child: CompositedTransformTarget(
            link: layerLink,
            child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    onEditingComplete: () async {
                      if (widget.isDeviceConnected) {
                        hideOverlay();
                        try {
                          TransliterationResponse? response =
                              await Transliteration.transliterate(
                                  widget.controller.text, Languages.HINDI);
                          final List<String> suggestion =
                              response!.transliterationSuggestions;
                          showOverlay(suggestion);
                        } on Exception {
                          Get.snackbar(
                              "no_internet_title".tr, "no_internet_msg".tr,
                              colorText: Colors.white,
                              backgroundGradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 0, 0),
                                  Color.fromARGB(255, 253, 72, 0),
                                ],
                              ));
                        }
                      } else {
                        Get.snackbar(
                            "no_internet_title".tr, "no_internet_msg".tr,
                            colorText: Colors.white,
                            backgroundGradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 0, 0),
                                Color.fromARGB(255, 253, 72, 0),
                              ],
                            ));
                      }
                    },
                    controller: widget.controller,
                    autocorrect: true,
                    autofocus: false,
                    cursorColor: Color.fromARGB(255, 234, 232, 238),
                    style: TextStyle(
                        color: Color.fromARGB(255, 236, 235, 240),
                        fontSize: 14.sp),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10.w, right: 5.w),
                      hintStyle: TextStyle(
                          overflow: TextOverflow.visible,
                          color: Colors.deepPurple.shade100,
                          fontSize: 16.sp),
                      hintText: widget.hint,
                      suffixIcon: Icon(
                        Icons.search,
                        size: 24.sp,
                        color: Colors.deepPurple.shade50,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple.shade200),
                          borderRadius: BorderRadius.circular(30)),
                    )),
                errorBuilder: (_, err) {
                  return Padding(
                    padding: EdgeInsets.all(8.r),
                    child: AutoSizeText("error_msg".tr,
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: TextStyle(fontSize: 13.sp)),
                  );
                },
                suggestionsCallback: widget.suggestionsCallback,
                itemBuilder: widget.itemBuilder,
                noItemsFoundBuilder: (_) => Padding(
                      padding: EdgeInsets.all(8.r),
                      child: AutoSizeText(
                        widget.noItemText,
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                onSuggestionSelected: widget.onSuggestionSelected)),
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
            child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return ListTile(
                      title: AutoSizeText(suggestion[index],
                          stepGranularity: 1.sp,
                          minFontSize: 8.sp,
                          style: TextStyle(fontSize: 13.sp)),
                      onTap: () {
                        widget.controller.text = suggestion[index];
                        hideOverlay();
                        focusNode.unfocus();
                      });
                },
                itemCount: suggestion.length)),
      ));
}
