import 'dart:math';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../controllers/calc_controller.dart';

class CalcView extends GetView<CalcController> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? SingleChildScrollView(
              child: NeumorphicTheme(
                  darkTheme: NeumorphicThemeData(
                    baseColor: Colors.deepPurple.shade100,
                    intensity: 0.3,
                    lightSource: LightSource.topLeft,
                    variantColor: Colors.deepPurple,
                    depth: 4,
                  ),
                  theme: NeumorphicThemeData(
                    baseColor: Colors.deepPurple.shade500,
                    intensity: 0.3,
                    lightSource: LightSource.topLeft,
                    variantColor: Colors.deepPurple,
                    depth: 4,
                  ),
                  child: Column(children: [
                    NeumorphicButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: NeumorphicStyle(
                        color: Colors.deepPurple.shade800,
                        shape: NeumorphicShape.flat,
                        boxShape: const NeumorphicBoxShape.circle(),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(
                          Icons.navigate_before,
                          size: 40.sp,
                          color: Colors.deepPurple.shade50,
                        ),
                      ),
                    ),
                    Neumorphic(
                      style: NeumorphicStyle(
                        color: Colors.deepPurple.shade50,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                        depth: -10,
                      ),
                      margin: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      child: SizedBox(
                        height: 125.h,
                        width: 300.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Obx(
                              () => AutoSizeText(
                                controller.input.value,
                                maxLines: 5,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.deepPurple.shade600),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Obx(() => Text(controller.output.value,
                                  style: TextStyle(
                                      fontSize: 22.sp,
                                      color: Colors.deepPurple.shade900))),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: min(325.r, 70.r * 5),
                      width: min(350.r, 65.r * 4),
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        // padding: EdgeInsets.only(left: 20.sp, right: 10.sp),
                        // Generate 100 widgets that display their index in the List.
                        children:
                            List.generate(controller.buttons.length, (index) {
                          return calcButton(controller.buttons[index], index);
                        }),
                      ),
                    ),
                  ])),
            )
          : SingleChildScrollView(
              child: Container(
              color: Color.fromARGB(255, 243, 240, 247),
              height: 550.h,
              width: 900.w,
              child: NeumorphicTheme(
                  darkTheme: NeumorphicThemeData(
                    baseColor: Colors.deepPurple.shade100,
                    intensity: 0.3,
                    lightSource: LightSource.topLeft,
                    variantColor: Colors.deepPurple,
                    depth: 4,
                  ),
                  theme: NeumorphicThemeData(
                    baseColor: Colors.deepPurple.shade500,
                    intensity: 0.3,
                    lightSource: LightSource.topLeft,
                    variantColor: Colors.deepPurple,
                    depth: 4,
                  ),
                  child: Column(children: [
                    Row(
                      children: [
                        NeumorphicButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: NeumorphicStyle(
                            color: Colors.deepPurple.shade800,
                            shape: NeumorphicShape.flat,
                            boxShape: const NeumorphicBoxShape.circle(),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Icon(
                              Icons.navigate_before,
                              size: 40.sp,
                              color: Colors.deepPurple.shade50,
                            ),
                          ),
                        ),
                        Flexible(
                            child: Neumorphic(
                          style: NeumorphicStyle(
                            color: Colors.deepPurple.shade50,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                            depth: -10,
                          ),
                          margin: EdgeInsets.only(top: 10.h),
                          child: SizedBox(
                            height: 125.h,
                            width: 235.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Obx(
                                  () => AutoSizeText(
                                    controller.input.value,
                                    maxLines: 4,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.deepPurple.shade600),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Obx(() => Text(controller.output.value,
                                      style: TextStyle(
                                          fontSize: 22.sp,
                                          color: Colors.deepPurple.shade900))),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: min(350.r, 70.r * 5),
                      width: min(350.r, 70.r * 4),
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        children:
                            List.generate(controller.buttons.length, (index) {
                          return calcButton(controller.buttons[index], index);
                        }),
                      ),
                    ),
                  ])),
            ));
    });
  }

  calcButton(CalcButton button, int index) {
    return Center(
      child: SizedBox(
        width: 60.r,
        height: 60.r,
        child: NeumorphicButton(
          margin: EdgeInsets.all(2.r),
          onPressed: () {
            controller.calculate(button.label, index);
          },
          style: NeumorphicStyle(
              depth: 30,
              shadowLightColor: Colors.deepPurple.shade900,
              surfaceIntensity: 0.35,
              boxShape: const NeumorphicBoxShape.circle(),
              shape: NeumorphicShape.concave,
              color: button.textAccent
                  ? Colors.deepPurple.shade900
                  : Colors.deepPurple.shade50),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                button.label,
                style: TextStyle(
                    fontSize: 18.sp,
                    color: button.textAccent
                        ? Colors.deepPurple.shade50
                        : Colors.deepPurple.shade900),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
