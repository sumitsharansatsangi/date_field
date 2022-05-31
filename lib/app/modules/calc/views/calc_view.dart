import 'dart:math';
import 'package:app/app/widgets/custom_widget.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../controllers/calc_controller.dart';

class CalcView extends GetView<CalcController> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return SingleChildScrollView(
          child: Column(children: [
            CustomBack(),
            SizedBox(
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
                          fontSize: 14, color: Colors.deepPurple.shade600),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() => SelectableText(controller.output.value,
                        style: TextStyle(
                            fontSize: 22.sp,
                            color: Colors.deepPurple.shade900))),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: min(400.r, 75.r * 5),
              width: min(400.r, 65.r * 4),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                padding: EdgeInsets.symmetric(vertical: 10.sp),
                children: List.generate(controller.buttons.length, (index) {
                  return CustomButton(
                    button: controller.buttons[index],
                    index: index,
                    onPressed: () {
                      controller.calculate(
                          controller.buttons[index].label, index);
                    },
                  );
                }),
              ),
            ),
          ]),
        );
      } else {
        return Text("jhal modi");
        // Column(children: [
        // Row(
        //   children: [
        //     CustomBack(),
        //     Flexible(
        //         child: SizedBox(
        //       height: 125.h,
        //       width: 235.w,
        //       child: Column(
        //         mainAxisSize: MainAxisSize.max,
        //         crossAxisAlignment: CrossAxisAlignment.end,
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: <Widget>[
        //           Obx(
        //             () => AutoSizeText(
        //               controller.input.value,
        //               maxLines: 4,
        //               style: TextStyle(
        //                   fontSize: 14.sp,
        //                   color: Colors.deepPurple.shade600),
        //             ),
        //           ),
        //           SingleChildScrollView(
        //             scrollDirection: Axis.horizontal,
        //             child: Obx(() => SelectableText(
        //                 controller.output.value,
        //                 style: TextStyle(
        //                     fontSize: 22.sp,
        //                     color: Colors.deepPurple.shade900))),
        //           ),
        //         ],
        //       ),
        //     )),
        //   ],
        // // ),
        // SizedBox(
        //   height: min(350.r, 70.r * 5),
        //   width: min(350.r, 70.r * 4),
        //   child: GridView.count(
        //     physics: const NeverScrollableScrollPhysics(),
        //     crossAxisCount: 4,
        //     children: List.generate(controller.buttons.length, (index) {
        //       return CustomButton(
        //         button: controller.buttons[index],
        //         index: index,
        //         onPressed: () {
        //           controller.calculate(
        //               controller.buttons[index].label, index);
        //         },
        //       );
        //     }),
        //   ),
        // ),
        // ]);
      }
    });
  }

//   calcButton(CalcButton button, int index) {
//     return Center(
//       child: SizedBox(
//         width: 60.r,
//         height: 60.r,
//         child: NeumorphicButton(
//           margin: EdgeInsets.all(2.r),
//           onPressed: () {
//             controller.calculate(button.label, index);
//           },
//           style: NeumorphicStyle(
//               depth: 30,
//               shadowLightColor: Colors.deepPurple.shade900,
//               surfaceIntensity: 0.35,
//               boxShape: const NeumorphicBoxShape.circle(),
//               shape: NeumorphicShape.concave,
//               color: button.textAccent
//                   ? Colors.deepPurple.shade900
//                   : Colors.deepPurple.shade50),
//           child: Center(
//             child: FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(
//                 button.label,
//                 style: TextStyle(
//                     fontSize: 18.sp,
//                     color: button.textAccent
//                         ? Colors.deepPurple.shade50
//                         : Colors.deepPurple.shade900),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.button,
      required this.index,
      required this.onPressed})
      : super(key: key);
  final CalcButton button;
  final int index;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        gradient: button.textAccent
            ? const LinearGradient(
                colors: [
                  Color(0xFF6400FF),
                  Color(0xFF7700FF),
                ],
              )
            : const LinearGradient(
                colors: [
                  Color.fromARGB(255, 229, 221, 240),
                  Color.fromARGB(255, 239, 229, 250),
                ],
              ),
        borderRadius: BorderRadius.circular(30.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.4),
            spreadRadius: 6.sp,
            blurRadius: 4.sp,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: IconButton(
          padding: EdgeInsets.all(0),
          icon: FittedBox(
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
          onPressed: onPressed),
    );
  }
}
