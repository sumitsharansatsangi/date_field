import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as a;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'autosize_textfield.dart';

class NoItemWidget extends StatelessWidget {
  final String noText;
  final String addText;
  final void Function() onPressed;
  const NoItemWidget(
      {Key? key,
      required this.noText,
      required this.addText,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome_motion_outlined, size: 25.sp),
          AutoSizeText(noText,
              stepGranularity: 1.sp,
              minFontSize: 8.sp,
              style: TextStyle(fontSize: 18.sp)),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6400FF),
                    Color(0xFF7700FF),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.5),
                    spreadRadius: 1.sp,
                    blurRadius: 3.sp,
                    offset: Offset(4.sp, 4.sp),
                  ),
                ],
                border:
                    Border.all(width: 1.w, color: Colors.deepPurple.shade700),
                borderRadius: BorderRadius.circular(20.r)),
            child: TextButton.icon(
                onPressed: onPressed,
                icon: Icon(Icons.add, size: 20.sp, color: Colors.white),
                label: AutoSizeText(addText,
                    stepGranularity: 1.sp,
                    minFontSize: 8.sp,
                    style: TextStyle(fontSize: 15.sp, color: Colors.white))),
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String route;
  final IconData icon;
  final String buttonName;
  Button(this.route, this.icon, this.buttonName);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Get.toNamed(route),
        child: Center(
          child: Container(
            width: 70.r,
            height: 70.r,
            margin: EdgeInsets.all(2.r),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6400FF),
                    Color(0xFF7700FF),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.5), //color of shadow
                    spreadRadius: 1.sp, //spread radius
                    blurRadius: 3.sp, // blur radius
                    offset: Offset(4.sp, 4.sp), // changes position of shadow
                  ),
                  //you can set more BoxShadow() here
                ],
                border:
                    Border.all(width: 1.w, color: Colors.deepPurple.shade700),
                borderRadius: BorderRadius.circular(20.r)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18.sp, color: Colors.deepPurple.shade50),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    buttonName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10.sp, color: Colors.deepPurple.shade50),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class CustomBack extends StatelessWidget {
  const CustomBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6400FF),
            Color(0xFF7700FF),
          ],
        ),
        borderRadius: BorderRadius.circular(30.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.4), //color of shadow
            spreadRadius: 6.sp, //spread radius
            blurRadius: 4.sp, // blur radius
            offset: Offset(0, 4), // changes position of shadow
          )
        ],
      ),
      child: IconButton(
          // buttonBoxShadow: true,

          // size: GFSize.LARGE,
          padding: EdgeInsets.all(0),
          // shape: GFIconButtonShape.circle,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 20.sp,
            color: Color.fromARGB(255, 236, 235, 240),
          ),
          onPressed: () => Get.back()),
    );
  }
}

class MinusButton extends StatelessWidget {
  const MinusButton({Key? key, required this.onPressed}) : super(key: key);
  final Function()? onPressed;
  final Gradient g1 = const LinearGradient(
    colors: [
      Color(0xFF6400FF),
      Color(0xFF7700FF),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return a.GradientIconButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: Icon(
        CupertinoIcons.minus_circle_fill,
        size: 20.sp,
      ),
      gradient: g1,
    );
  }
}

class PlusButton extends StatelessWidget {
  const PlusButton({Key? key, required this.onPressed}) : super(key: key);
  final Function()? onPressed;
  final Gradient g1 = const LinearGradient(
    colors: [
      Color(0xFF6400FF),
      Color(0xFF7700FF),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.r,
      height: 20.r,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.5), //color of shadow
              spreadRadius: 3.w, //spread radius
              blurRadius: 5.w, // blur radius
              offset: Offset(0, 3), // changes position of shadow
            )
          ],
          gradient: g1),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(Icons.add, size: 15.sp, color: Colors.white),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  final void Function() onDelete;
  const DeleteButton({Key? key, required this.onDelete}) : super(key: key);
  final Gradient g1 = const LinearGradient(
    colors: [
      Color(0xFF6400FF),
      Color(0xFF7700FF),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.r,
      width: 30.r,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
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
      child: a.GradientIconButton(
          padding: EdgeInsets.zero,
          gradient: g1,
          icon: Icon(
            Icons.delete,
            size: 22.sp,
          ),
          onPressed: onDelete),
    );
  }
}

class CreateButton extends StatelessWidget {
  final void Function()? onPressed;
  const CreateButton({Key? key, this.onPressed}) : super(key: key);
  final Gradient g1 = const LinearGradient(
    colors: [
      Color(0xFF6400FF),
      Color(0xFF7700FF),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.r,
      width: 20.r,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(30), //border corner radius
        // boxShadow: [
        //   BoxShadow(
        //     color: Color.fromARGB(255, 255, 255, 255)
        //         .withOpacity(0.5), //color of shadow
        //     spreadRadius: 3.sp, //spread radius
        //     blurRadius: 5.sp, // blur radius
        //     offset: const Offset(0, 2), // changes position of shadow
        //   ),
        // ],
      ),
      child: a.GradientIconButton(
          padding: EdgeInsets.zero,
          gradient: g1,
          icon: Icon(
            Icons.add,
            size: 16.sp,
            color: Color(0xFF6400FF),
          ),
          onPressed: onPressed),
    );
  }
}

class FloatingButton extends StatelessWidget {
  const FloatingButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.icon,
      required this.heroTag})
      : super(key: key);
  final void Function() onPressed;
  final String text;
  final IconData icon;
  final String heroTag;
  final Gradient g1 = const LinearGradient(
    colors: [
      Color(0xFF6400FF),
      Color(0xFF7700FF),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: a.GradientFloatingActionButton.extended(
        elevation: 8.sp,
        heroTag: heroTag,
        label: AutoSizeText(text,
            textAlign: TextAlign.center,
            stepGranularity: 1.sp,
            minFontSize: 8.sp,
            style: TextStyle(fontSize: 13.sp)),
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20.sp,
        ),
        shape: StadiumBorder(),
        gradient: g1,
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton(
      {Key? key, required this.onAddPressed, required this.onAddMorePressed})
      : super(key: key);
  final void Function() onAddPressed;
  final void Function() onAddMorePressed;
  final Gradient g1 = const LinearGradient(
    colors: [
      Color(0xFF6400FF),
      Color(0xFF7700FF),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 35.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.5), //color of shadow
                  spreadRadius: 5, //spread radius
                  blurRadius: 7, // blur radius
                  offset: Offset(0, 3), // changes position of shadow
                )
              ],
              gradient: g1),
          child: TextButton(
            onPressed: onAddPressed,
            child: AutoSizeText(
              'add'.tr,
              stepGranularity: 1.sp,
              minFontSize: 8.sp,
              style: TextStyle(fontSize: 15.sp, color: Colors.white),
            ),
          ),
        ),
        Container(
          height: 35.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.5), //color of shadow
                  spreadRadius: 5, //spread radius
                  blurRadius: 7, // blur radius
                  offset: Offset(0, 3), // changes position of shadow
                )
              ],
              gradient: g1),
          child: TextButton(
            onPressed: onAddMorePressed,
            child: AutoSizeText(
              'add_more'.tr,
              stepGranularity: 1.sp,
              minFontSize: 8.sp,
              style: TextStyle(fontSize: 15.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class UpdateButton extends StatelessWidget {
  const UpdateButton({Key? key, required this.onPressed}) : super(key: key);
  final void Function() onPressed;
  final Gradient g1 = const LinearGradient(
    colors: [
      Color(0xFF6400FF),
      Color(0xFF7700FF),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 30.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.5), //color of shadow
                spreadRadius: 5, //spread radius
                blurRadius: 7, // blur radius
                offset: Offset(0, 3), // changes position of shadow
              )
            ],
            gradient: g1),
        child: TextButton(
          onPressed: onPressed,
          child: AutoSizeText(
            'update'.tr,
            stepGranularity: 1.sp,
            minFontSize: 8.sp,
            style: TextStyle(fontSize: 11.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  final String text;
  const SearchWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.deepPurpleAccent,
            size: 40.sp,
          ),
          SizedBox(height: 25.h),
          SizedBox(
            width: Get.width / 2,
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6400FF),
              ),
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  FadeAnimatedText('start_searching'.tr,
                      textAlign: TextAlign.center),
                  FadeAnimatedText('$text !!', textAlign: TextAlign.center),
                  FadeAnimatedText('start_now'.tr, textAlign: TextAlign.center),
                ],
              ),
            ),
            // AutoSizeText(
            //   text,
            //   textAlign: TextAlign.center,
            //   stepGranularity: 1.sp,
            //   minFontSize: 8.sp,
            //   style:
            //       TextStyle(color: Colors.deepPurple.shade900, fontSize: 20.sp),
            // ),
          )
        ],
      ),
    );
  }
}

class BottomSheetRow extends StatelessWidget {
  final void Function() onDelete;
  final Gradient g1 = const LinearGradient(
    colors: [
      Color(0xFF6400FF),
      Color(0xFF7700FF),
    ],
  );
  const BottomSheetRow({Key? key, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 30.r,
          width: 30.r,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
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
          child: a.GradientIconButton(
              padding: EdgeInsets.zero,
              gradient: g1,
              icon: Icon(
                Icons.delete,
                size: 22.sp,
              ),
              onPressed: onDelete),
        ),
        Container(
          height: 30.r,
          width: 30.r,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
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
          child: a.GradientIconButton(
              padding: EdgeInsets.zero,
              gradient: g1,
              icon: Icon(
                Icons.close,
                size: 22.sp,
              ),
              onPressed: () {
                Get.back();
              }),
        ),
      ],
    );
  }
}

class Heading extends StatelessWidget {
  final String text;
  Heading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: TextStyle(
              overflow: TextOverflow.clip,
              fontSize: 14.sp,
              color: Color.fromARGB(255, 97, 32, 128),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final String text;
  Content(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: AutoSizeText(
        text,
        maxLines: 3,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: Color.fromARGB(255, 124, 50, 158),
        ),
      ),
    );
  }
}

customAppBar({Key? key, List<Widget>? actions, required RxString titleText}) {
  final gradient = const LinearGradient(
    colors: [
      Color(0xFF6400FF),
      Color(0xFF7700FF),
    ],
  );
  return AppBar(
    flexibleSpace: Container(
      decoration: BoxDecoration(gradient: gradient),
    ),
    title: Obx(() => FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(titleText.value, style: Get.textTheme.headlineLarge),
        )),
    centerTitle: true,
    actions: actions,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
      onPressed: () => Get.back(),
    ),
  );
}

class PhoneWidget extends StatelessWidget {
  final void Function(PhoneNumber) onChanged;
  final String labelText;
  final String hint;
  final PhoneNumber initialValue;
  final Widget suffixIcon;
  const PhoneWidget(
      {Key? key,
      required this.onChanged,
      required this.labelText,
      required this.hint,
      required this.initialValue,
      required this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      hintText: hint,
      inputDecoration: InputDecoration(
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Color.fromARGB(87, 236, 234, 250),
        isDense: true,
        contentPadding: EdgeInsets.all(15.r),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 15.sp),
        label: AutoSizeText(labelText,
            stepGranularity: 1.sp,
            minFontSize: 8.sp,
            style: TextStyle(fontSize: 13.sp)),
        border: const OutlineInputBorder(),
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 13.sp),
      ),
      errorMessage: "Provide a valid number",
      onInputChanged: onChanged,
      locale: Get.locale!.languageCode,
      selectorConfig: SelectorConfig(
        useEmoji: true,
        leadingPadding: 3,
        setSelectorButtonAsPrefixIcon: true,
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      selectorTextStyle: TextStyle(color: Colors.black),
      initialValue: initialValue,
      formatInput: true,
      keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: true),
      inputBorder: OutlineInputBorder(),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool allowDecoration;
  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.allowDecoration = true,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: AutoSizeTextField(
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(fontSize: 15.sp),
            autofocus: false,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              filled: true,
              fillColor: Color.fromARGB(87, 236, 234, 250),
              isDense: true, // Added this
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.r, horizontal: 5.r),
              hintText: hint,
              hintStyle: TextStyle(fontSize: 15.sp),
              label: AutoSizeText(labelText,
                  stepGranularity: 1.sp,
                  minFontSize: 8.sp,
                  style: TextStyle(fontSize: 15.sp)),
              border: allowDecoration
                  ? const OutlineInputBorder(gapPadding: 4.0)
                  : OutlineInputBorder(
                      borderSide: BorderSide.none, gapPadding: 0),
              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 13.sp),
            ),
            controller: controller,
            validator: validator),
      ),
    );
  }
}

class CustomDateField extends StatelessWidget {
  final String labelText;
  final String hint;
  final DateTime? initialDate;
  final FormFieldValidator<DateTime>? validator;
  final void Function(DateTime)? onDateSelected;
  final DateTimeFieldPickerMode mode;
  const CustomDateField({
    Key? key,
    required this.labelText,
    required this.hint,
    this.initialDate,
    this.validator,
    this.mode = DateTimeFieldPickerMode.date,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: DateTimeFormField(
          initialDate: initialDate,
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 15.sp),
            errorStyle: TextStyle(color: Colors.redAccent),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Color.fromARGB(87, 236, 234, 250),
            suffixIcon: Icon(
              Icons.event_note,
              size: 20.sp,
              color: Color(0xFF6400FF),
            ),
            label: AutoSizeText(
              labelText,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
          mode: mode,
          autovalidateMode: AutovalidateMode.always,
          validator: validator,
          onDateSelected: onDateSelected),
    );
  }
}

class ListContainer extends StatelessWidget {
  const ListContainer({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(30), //border corner radius
          boxShadow: [
            BoxShadow(
              blurRadius: 7.sp, // blur radius
              color: Colors.deepPurple.withOpacity(0.5), //color of shadow
              offset: const Offset(0, 2), // changes position of shadow
              spreadRadius: 5.sp, //spread radius
            ),
          ],
        ),
        child: child);
  }
}

class DropDownSearchField<T> extends StatelessWidget {
  const DropDownSearchField(
      {Key? key,
      required this.searchHint,
      this.label,
      required this.notFoundText,
      this.items = const [],
      required this.itemAsString,
      required this.onChanged,
      this.onPressed,
      this.hint,
      required this.popupItemBuilder,
      this.allowCreation = true,
      this.allowDecoration = true,
      this.selectedItem,
      this.popupTitle,
      this.dropdownBuilder,
      this.isIconBased = false,
      this.icon,
      this.dropdownButtonProps,
      this.onFind})
      : super(key: key);
  final String searchHint;
  final String? label;
  final String? hint;
  final String? popupTitle;
  final String notFoundText;
  final List<T> items;
  final String Function(T?) itemAsString;
  final void Function(T?) onChanged;
  final void Function()? onPressed;
  final T? selectedItem;
  final DropdownSearchPopupItemBuilder<T>? popupItemBuilder;
  final bool allowCreation;
  final bool allowDecoration;
  final DropdownSearchOnFind<T>? onFind;
  final DropdownSearchBuilder<T>? dropdownBuilder;
  final IconButtonProps? dropdownButtonProps;
  final bool isIconBased;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      isIconBased: isIconBased,
      icon: icon,
      dropdownBuilder: dropdownBuilder,
      asyncItems: onFind,
      selectedItem: selectedItem,
      popupProps: PopupProps.bottomSheet(
        showSearchBox: true,
        itemBuilder: popupItemBuilder,
        emptyBuilder: (_, string) {
          return ListTile(
            title: AutoSizeText(
              notFoundText,
              stepGranularity: 1.sp,
              minFontSize: 8.sp,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        },
        title: Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: Color(0xFF6400FF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: allowCreation
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (allowCreation) SizedBox(),
                  AutoSizeText(
                    popupTitle ?? label ?? " ",
                    stepGranularity: 1.sp,
                    minFontSize: 8.sp,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (allowCreation) CreateButton(onPressed: onPressed)
                ],
              ),
            ),
          ),
        ),
        bottomSheetProps: BottomSheetProps(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
        ),
        searchFieldProps: TextFieldProps(
          autofocus: true,
          style: TextStyle(fontSize: 15.sp),
          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.search, size: 20.sp),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              labelText: searchHint),
        ),
      ),
      dropdownButtonProps: dropdownButtonProps,
      dropdownSearchDecoration: InputDecoration(
          hintText: hint,
          filled: allowDecoration ? true : null,
          contentPadding: EdgeInsets.symmetric(vertical: 15.r, horizontal: 5.r),
          fillColor: allowDecoration ? Color.fromARGB(87, 236, 234, 250) : null,
          border: allowDecoration
              ? const OutlineInputBorder()
              : OutlineInputBorder(borderSide: BorderSide.none),
          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 13.sp),
          label: label != null
              ? AutoSizeText(label ?? "",
                  stepGranularity: 1.sp,
                  minFontSize: 8.sp,
                  style: TextStyle(fontSize: 15.sp))
              : null),
      items: items,
      itemAsString: itemAsString,
      onChanged: onChanged,
    );
  }
}

class DropDownMultiSearchField<T> extends StatelessWidget {
  const DropDownMultiSearchField(
      {Key? key,
      required this.searchHint,
      this.label,
      required this.notFoundText,
      this.items = const [],
      required this.itemAsString,
      required this.onChanged,
      this.onPressed,
      required this.popupItemBuilder,
      this.allowCreation = true,
      this.allowDecoration = true,
      required this.selectedItems,
      required this.multiKey,
      this.popupTitle,
      this.dropdownBuilder,
      this.isIconBased = false,
      this.icon,
      this.dropdownButtonProps,
      this.onFind})
      : super(key: key);
  final Key multiKey;
  final String searchHint;
  final String? label;
  final String? popupTitle;
  final String notFoundText;
  final List<T> items;
  final String Function(T?) itemAsString;
  final void Function(List<T>?) onChanged;
  final void Function()? onPressed;
  final List<T> selectedItems;
  final DropdownSearchPopupItemBuilder<T>? popupItemBuilder;
  final bool allowCreation;
  final bool allowDecoration;
  final DropdownSearchOnFind<T>? onFind;
  final DropdownSearchBuilderMultiSelection<T>? dropdownBuilder;
  final IconButtonProps? dropdownButtonProps;
  final bool isIconBased;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: SizedBox(
        width: 150.w,
        child: DropdownSearch<T>.multiSelection(
          key: multiKey,
          isIconBased: isIconBased,
          icon: icon,
          dropdownBuilder: dropdownBuilder,
          asyncItems: onFind,
          selectedItems: selectedItems,
          popupProps: PopupPropsMultiSelection.bottomSheet(
            showSearchBox: true,
            itemBuilder: popupItemBuilder,
            emptyBuilder: (_, string) {
              return ListTile(
                title: AutoSizeText(
                  notFoundText,
                  stepGranularity: 1.sp,
                  minFontSize: 8.sp,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            },
            title: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Color(0xFF6400FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: allowCreation
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      if (allowCreation) SizedBox(),
                      AutoSizeText(
                        popupTitle ?? label ?? " ",
                        stepGranularity: 1.sp,
                        minFontSize: 8.sp,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (allowCreation) CreateButton(onPressed: onPressed)
                    ],
                  ),
                ),
              ),
            ),
            bottomSheetProps: BottomSheetProps(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
            ),
            searchFieldProps: TextFieldProps(
              autofocus: true,
              style: TextStyle(fontSize: 15.sp),
              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search, size: 20.sp),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                  labelText: searchHint),
            ),
          ),
          dropdownButtonProps: dropdownButtonProps,
          dropdownSearchDecoration: InputDecoration(
              filled: allowDecoration ? true : null,
              contentPadding: EdgeInsets.all(15.r),
              fillColor:
                  allowDecoration ? Color.fromARGB(87, 236, 234, 250) : null,
              border: allowDecoration
                  ? const OutlineInputBorder()
                  : InputBorder.none,
              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 13.sp),
              label: AutoSizeText(label ?? "",
                  stepGranularity: 1.sp,
                  minFontSize: 8.sp,
                  style: TextStyle(fontSize: 15.sp))),
          items: items,
          itemAsString: itemAsString,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

successSnackBar(message) {
  Get.snackbar("success".tr, message,
      titleText: AutoSizeText(
        "success".tr,
        stepGranularity: 1.sp,
        minFontSize: 8.sp,
        style: TextStyle(
            fontSize: 18.sp,
            color: Colors.green.shade100,
            fontWeight: FontWeight.bold),
      ),
      messageText: AutoSizeText(message,
          stepGranularity: 1.sp,
          minFontSize: 8.sp,
          style: TextStyle(
              fontSize: 15.sp,
              color: Colors.teal.shade100,
              fontWeight: FontWeight.w400)),
      backgroundColor: Colors.green.shade700);
}

errorSnackBar() {
  Get.snackbar("error".tr, "error_msg".tr,
      titleText: Text(
        "error".tr,
        style: TextStyle(
            fontSize: 18.sp,
            color: Colors.red.shade100,
            fontWeight: FontWeight.bold),
      ),
      messageText: AutoSizeText("error_msg".tr,
          stepGranularity: 1.sp,
          minFontSize: 8.sp,
          style: TextStyle(
              fontSize: 15.sp,
              color: Colors.redAccent.shade100,
              fontWeight: FontWeight.w400)),
      backgroundColor: Colors.red.shade700);
}

alertSnackBar() {
  Get.snackbar("alert".tr, "already_exist_msg".tr,
      titleText: AutoSizeText(
        "alert".tr,
        stepGranularity: 1.sp,
        minFontSize: 8.sp,
        style: TextStyle(
            fontSize: 18.sp,
            color: Colors.deepPurple.shade100,
            fontWeight: FontWeight.bold),
      ),
      messageText: AutoSizeText("already_exist_msg".tr,
          stepGranularity: 1.sp,
          minFontSize: 8.sp,
          style: TextStyle(
              fontSize: 15.sp,
              color: Colors.deepPurpleAccent.shade100,
              fontWeight: FontWeight.w400)),
      backgroundColor: Colors.deepPurple.shade700);
}

customSnackBar(String title, String message, Color titleColor,
    Color messageColor, Color backgroundColor) {
  Get.snackbar(title, message,
      titleText: AutoSizeText(
        title,
        stepGranularity: 1.sp,
        minFontSize: 8.sp,
        style: TextStyle(
            fontSize: 18.sp, color: titleColor, fontWeight: FontWeight.bold),
      ),
      messageText: AutoSizeText(message,
          stepGranularity: 1.sp,
          minFontSize: 8.sp,
          style: TextStyle(
              fontSize: 15.sp,
              color: messageColor,
              fontWeight: FontWeight.w400)),
      backgroundColor: backgroundColor);
}
