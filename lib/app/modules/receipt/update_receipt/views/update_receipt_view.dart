import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_receipt_controller.dart';

class UpdateReceiptView extends GetView<UpdateReceiptController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UpdateReceiptView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'UpdateReceiptView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
