import "dart:async";
import "dart:io";

import "package:doclense/configs/app_typography.dart";
import "package:doclense/constants/appstrings.dart";
import "package:flutter/material.dart";
import "package:pdf/pdf.dart";
import "package:printing/printing.dart";

class PdfPreviewScreen extends StatefulWidget {
  const PdfPreviewScreen({required this.path, required this.name, super.key});
  final String path;
  final String name;

  @override
  PdfPreviewScreenState createState() => PdfPreviewScreenState();
}

class PdfPreviewScreenState extends State<PdfPreviewScreen> {
  @override
  void initState() {
    super.initState();
    homePageTimer(); // calling the function
  }

  void homePageTimer() {
    Timer(Duration.zero, () {
      Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            S.pdfPreview,
            style: AppText.h4b,
          ),
        ),
        body: PdfPreview(
          canDebug: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          allowPrinting: false,
          allowSharing: false,
          pageFormats: const <String, PdfPageFormat>{
            "A4": PdfPageFormat.a4,
            "Letter": PdfPageFormat.letter,
            "A3": PdfPageFormat.a3,
            "A5": PdfPageFormat.a5,
            "Standard": PdfPageFormat.standard,
          },
          build: (PdfPageFormat format) async =>
              File(widget.path).readAsBytes(),
          // onPrinted: _showPrintedToast,
          // onShared: _showSharedToast,
        ),
      );
}
