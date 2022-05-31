import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';
// import 'package:whatsapp_share2/whatsapp_share2.dart';

class PdfController extends GetxController {
  final appTitle = "receipt".tr.obs;
  final filePath = "".obs;
  final phone = "".obs;
  final msgTitle = "".obs;
  late PdfControllerPinch pdfControllerPinch;
  @override
  void onInit() {
    super.onInit();
    appTitle.value = Get.arguments[0];
    filePath.value = Get.arguments[1];
    phone.value = Get.arguments[2];
    msgTitle.value = Get.arguments[3];
    pdfControllerPinch =
        PdfControllerPinch(document: PdfDocument.openFile(filePath.value));
  }

  // Future<void> isInstalled() async {
  //   final val = await WhatsappShare.isInstalled();
  // }

  @override
  void onClose() {}
}
