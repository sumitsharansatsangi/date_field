import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final connectionStatus = false.obs;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> streamSubscription;

  @override
  void onInit() async {
    super.onInit();
    await initConnectivity();
    streamSubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  @override
  void onClose() {}

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
      await updateConnectionStatus(result);
    } on PlatformException catch (e) {
      Get.snackbar("error".tr, "Potential network problem");
    }
  }

  checkConnection() async {
    try {
      connectionStatus.value = await InternetConnectionChecker().hasConnection;
    } on Exception {
      Get.snackbar("no_internet_title".tr, "no_internet_msg".tr,
          colorText: Colors.white,
          titleText: Wrap(
            children: [
              Icon(
                Icons.wifi_off_rounded,
                color: Colors.purple.shade100,
              ),
              Text(
                "no_internet_title".tr,
                style: TextStyle(
                    fontSize: 13.sp,
                    color: Color.fromARGB(255, 253, 226, 228),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          messageText: Text("no_internet_msg".tr,
              style: TextStyle(
                  fontSize: 11.sp,
                  color: Color.fromARGB(255, 231, 189, 185),
                  fontWeight: FontWeight.w400)),
          backgroundColor: Colors.red.shade700);
    }
  }

  updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        checkConnection();
        break;
      case ConnectivityResult.mobile:
        checkConnection();
        break;
      case ConnectivityResult.ethernet:
        checkConnection();
        break;
      case ConnectivityResult.bluetooth:
        checkConnection();
        break;
      case ConnectivityResult.none:
        connectionStatus.value = false;
        break;
      default:
        Get.snackbar("no_internet_title".tr, "no_internet_msg".tr,
            colorText: Colors.white,
            backgroundGradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 0, 0),
                Color.fromARGB(255, 253, 72, 0),
              ],
            ));
        break;
    }
  }
}
