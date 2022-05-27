import 'package:get/get.dart';

import '../controllers/update_receipt_controller.dart';

class UpdateReceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateReceiptController>(
      () => UpdateReceiptController(),
    );
  }
}
