import 'dart:io';

import 'package:app/app/data/model.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class Utils {
  static formatPrice(double price) => '\u{20B9} ${price.toStringAsFixed(2)}';
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
  Future<File> generate(Receipt receipt) async {
    final pdf = Document();

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

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${customer.name}",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
              "${customer.address}, ${customer.location.target!.area} , ${customer.location.target!.village}, ${customer.location.target!.panchayat}, ${customer.location.target!.block}, ${customer.location.target!.pin.target!.district}, ${customer.location.target!.pin.target!.state}, ${customer.location.target!.pin.target!.pincode} "),
        ],
      );

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
          Text("Dayal Sharan", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text("Matia,\nJamui,Bihar\n811312"),
        ],
      );

  static Widget buildTitle(Receipt receipt) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(receipt.receiptInfo.target!.description ?? " "),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildReceipt(Receipt receipt) {
    final headers = ['Item', 'Quantity', 'Rate', 'GST', 'Total'];
    final data = receipt.receiptItems.map((item) {
      final total = item.soldPrice! * item.quantity! * (1);

      return [
        item.item.target!.purchasedItem.target!.item.target!.name,
        '${item.quantity} ${item.unit}',
        '\$ ${item.soldPrice}',
        '18%',
        '\$ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
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
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(netTotal),
                  e: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount due',
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
          buildSimpleText(title: 'Address', value: "Matia, Jamui,Bihar,811312"),
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
          Expanded(child: Text(title, style: style)),
          Text(value, style: e ? style : null),
        ],
      ),
    );
  }
}
