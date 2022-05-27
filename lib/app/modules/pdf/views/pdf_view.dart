import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart' as pdf;
import '../controllers/pdf_controller.dart';
import 'package:speed_up_get/speed_up_get.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class PdfView extends GetView<PdfController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(c.appTitle.value),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.whatsapp),
            onPressed: () async {
              final val = await WhatsappShare.isInstalled(
                  package: Package.businessWhatsapp);
              if (val != null && val) {
                await WhatsappShare.shareFile(
                  package: Package.businessWhatsapp,
                  phone: c.phone.value,
                  text: c.msgTitle.value,
                  filePath: [c.filePath.value],
                );
              } else {
                final val = await WhatsappShare.isInstalled();
                if (val != null && val) {
                  await WhatsappShare.shareFile(
                    phone: c.phone.value,
                    text: c.msgTitle.value,
                    filePath: [c.filePath.value],
                  );
                } else {
                  Get.snackbar(
                      "Message", "Whatsapp is not installed on your device");
                }
              }
            },
          ),
        ],
      ),
      body: pdf.PdfViewPinch(
        builders: pdf.PdfViewPinchBuilders<pdf.DefaultBuilderOptions>(
          options: const pdf.DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, error) => Center(child: Text(error.toString())),
        ),
        controller: c.pdfControllerPinch,
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              c.pdfControllerPinch.previousPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          pdf.PdfPageNumber(
            controller: c.pdfControllerPinch,
            builder: (_, loadingState, page, pagesCount) => Container(
              alignment: Alignment.center,
              child: Text(
                '$page/${pagesCount ?? 0}',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              c.pdfControllerPinch.nextPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
        ],
      )),
    );
  }
}
