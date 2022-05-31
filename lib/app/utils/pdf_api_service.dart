import 'dart:io';

import 'package:app/app/data/model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class Utils {
  static formatPrice(double price) => "₹ ${price.toStringAsFixed(2)}";
  // static formatPrice(double price) => price.toStringAsFixed(2);
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}

class PdfReceiptApi {
  static late Font ttf;
  static late Font inrttf;
  Future<File> generate(Receipt receipt) async {
    final pdf = Document();
    final font = await rootBundle.load("assets/NotoSans-Regular.ttf");
    final inrFont = await rootBundle.load("assets/Hind-Regular.ttf");
    ttf = Font.ttf(font);
    inrttf = Font.ttf(inrFont);
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(receipt),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(receipt),
        buildReceipt(receipt),
        Divider(),
        buildTotal(receipt),
      ],
      footer: (context) => buildFooter(receipt),
    ));

    return PdfApi.saveDocument(
        name:
            "${DateFormat('yyyymmddHms').format(DateTime.now())}_${receipt.customer.target!.name!.replaceAll(" ", "_")}.pdf",
        pdf: pdf);
  }

  static Widget buildHeader(Receipt receipt) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: receipt.receiptInfo.target!.number ?? " ",
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(receipt.customer.target!),
              buildReceiptInfo(receipt.receiptInfo.target!),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) {
    String address = "";
    if (customer.address != null) {
      for (int i = 0; i < customer.address!.length; i++) {
        if (i < customer.address!.length - 1 &&
            customer.address![i + 1] == "ि") {
          address += customer.address![i + 1];
          address += customer.address![i];
          i = i + 1;
        } else {
          address += customer.address![i];
        }
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${customer.name}", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(address, style: TextStyle(font: ttf)),
      ],
    );
  }

  static Widget buildReceiptInfo(ReceiptInfo info) {
    final paymentTerms =
        '${info.dueDate!.difference(info.dateOfCreation).inDays} days';
    final titles = <String>[
      'Receipt Number:',
      'Receipt Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number!,
      DateFormat("dd/MM/yyyy").format(info.dateOfCreation),
      paymentTerms,
      DateFormat("dd/MM/yyyy").format(info.dueDate!),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dayal Sharan",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  font: ttf,
                  fontFallback: [inrttf])),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text("Matia,\nJamui,Bihar\n811312",
              style: TextStyle(font: ttf, fontFallback: [inrttf])),
        ],
      );

  static Widget buildTitle(Receipt receipt) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'invoice'.tr,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                font: ttf,
                fontFallback: [inrttf]),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(receipt.receiptInfo.target!.description ?? " ",
              style: TextStyle(font: ttf, fontFallback: [inrttf])),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildReceipt(Receipt receipt) {
    final headers = ['item'.tr, 'quantity'.tr, 'rate'.tr, 'gst'.tr, 'total'.tr];
    final data = receipt.receiptItems.map((item) {
      final total = item.soldPrice! * item.quantity! * (1);

      return [
        item.item.target!.purchasedItem.target!.item.target!.name,
        '${item.quantity} ${item.unit.target!.shortName}',
        '₹ ${item.soldPrice}',
        '18%',
        '₹ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(
          fontWeight: FontWeight.bold, font: ttf, fontFallback: [inrttf]),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellStyle: TextStyle(font: ttf, fontFallback: [inrttf]),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Receipt receipt) {
    final netTotal = receipt.receiptItems
        .map((item) => item.soldPrice! * item.quantity!)
        .reduce((item1, item2) => item1 + item2);
    final total = netTotal;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildPriceText(
                  title: 'payable_amount'.tr,
                  value: Utils.formatPrice(netTotal),
                  e: true,
                ),
                Divider(),
                buildPriceText(
                  title: 'total_amount_due'.tr,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  e: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Receipt receipt) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'address'.tr, value: "Matia, Jamui,Bihar,811312"),
          SizedBox(height: 1 * PdfPageFormat.mm),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool e = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(
              child: Text(title,
                  style: style.copyWith(font: ttf, fontFallback: [inrttf]))),
          Text(value,
              style: e
                  ? style.copyWith(font: ttf, fontFallback: [inrttf])
                  : TextStyle(font: ttf, fontFallback: [inrttf]))
        ],
      ),
    );
  }

  static buildPriceText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool e = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value,
              style: e
                  ? style.copyWith(font: ttf, fontFallback: [inrttf])
                  : TextStyle(font: ttf, fontFallback: [inrttf]))
        ],
      ),
    );
  }
}
