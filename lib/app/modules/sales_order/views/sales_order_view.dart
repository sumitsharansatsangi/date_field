import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sales_order_controller.dart';

class SalesOrderView extends GetView<SalesOrderController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SalesOrderView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'SalesOrderView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
