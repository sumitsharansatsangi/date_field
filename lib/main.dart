import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/data/model.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/languages.dart';
import 'app/utils/objectbox.dart';
import 'objectbox.g.dart';

//view_item_variant
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await GetStorage.init();
  final objectBoxController = Get.put(ObjectBoxController());
  final box = GetStorage();
  final isDark = box.read("darkMode");
  final isHindi = box.read("isHindi");
  final isData = box.read("isData");
  await objectBoxController.create();
  if (isData == null || !isData) {
    await readFileByLines();
  }
  FlutterNativeSplash.remove();
  runApp(ScreenUtilInit(
    designSize: const Size(360, 712),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, child) => GetMaterialApp(
      translations: Languages(),
      locale: isHindi == null
          ? Get.deviceLocale
          : isHindi
              ? Locale("hi", "IN")
              : Locale("en", "US"),
      fallbackLocale: Locale('en', 'US'),
      defaultTransition: Transition.native,
      transitionDuration: const Duration(milliseconds: 200),
      debugShowCheckedModeBanner: false,
      title: "Kumpali",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      home: child,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: TextTheme(
            headlineLarge: TextStyle(fontSize: 20.sp, color: Colors.white),
            titleLarge: TextStyle(
                fontSize: 19.sp, color: Color.fromARGB(255, 103, 14, 187)),
            labelLarge: TextStyle(
                fontSize: 18.sp, color: Color.fromARGB(255, 120, 42, 255)),
            headlineMedium:
                TextStyle(fontSize: 17.sp, color: Color(0xFF6400FF)),
            titleMedium: TextStyle(
                fontSize: 16.sp,
                color: Colors.deepPurple.shade600,
                fontWeight: FontWeight.w400),
            labelMedium: TextStyle(
                fontSize: 15.sp, color: Color.fromARGB(255, 87, 35, 177)),
            headlineSmall: TextStyle(
                fontSize: 14.sp, color: Color.fromARGB(255, 65, 13, 99)),
            titleSmall: TextStyle(
                fontSize: 13.sp, color: Color.fromARGB(255, 50, 10, 80)),
            labelSmall: TextStyle(
                fontSize: 12.sp, color: Color.fromARGB(255, 45, 15, 100))),
      ),
      themeMode: isDark == null
          ? ThemeMode.system
          : isDark
              ? ThemeMode.dark
              : ThemeMode.light,
    ),
  ));
}

Future<void> readFileByLines() async {
  var data = [];
  final objectBoxController = Get.find<ObjectBoxController>();
  final rawData = await rootBundle.loadString("assets/data.csv");
  List<String> lines = rawData.split("\n");

  for (final line in lines) {
    data.add(line.split(','));
  }
  data = data.sublist(0, data.length - 1);
  objectBoxController.pincodeBox.putMany(data.map((e) {
    if (e.length == 6) {
      return Pincode()
        ..pincode = e[5].trim().replaceAll(",", "")
        ..district = "जमुई"
        ..state = "बिहार"
        ..country = "भारत";
    } else {
      return Pincode()
        ..pincode = e[4].trim().replaceAll(",", "")
        ..district = "जमुई"
        ..state = "बिहार"
        ..country = "भारत";
    }
  }).toList());
  objectBoxController.locationBox.putMany(data.map((e) {
    if (e.length == 6) {
      final p = objectBoxController.pincodeBox
          .query(Pincode_.pincode.equals(e[5].trim()))
          .build()
          .findFirst();
      return Location()
        ..area = e[0].trim()
        ..village = e[1].trim()
        ..panchayat = e[2].trim()
        ..block = e[3].trim()
        ..pin.target = p;
    } else if (e.length == 5) {
      final p = objectBoxController.pincodeBox
          .query(Pincode_.pincode.equals(e[4].trim()))
          .build()
          .findFirst();
      return Location()
        ..village = e[0].trim()
        ..panchayat = e[1].trim()
        ..block = e[2].trim()
        ..pin.target = p;
    } else {
      return Location();
    }
  }).toList());
  final box = GetStorage();
  box.write('isData', true);
}
