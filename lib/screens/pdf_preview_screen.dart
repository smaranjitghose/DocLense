import "dart:async";
import "dart:io";

import "package:doclense/configs/app_typography.dart";
import "package:doclense/constants/appstrings.dart";
import "package:flutter/material.dart";
import "package:pdf/pdf.dart";
import "package:printing/printing.dart";
// import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PdfPreviewScreen extends StatefulWidget {
  const PdfPreviewScreen({required this.path, required this.name, super.key});
  final String path;
  final String name;

  @override
  _PdfPreviewScreenState createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  @override
  void initState() {
    super.initState();
    homePageTimer(); // calling the function
  }

  void homePageTimer() {
    Timer(const Duration(), () {
      Navigator.of(context).popUntil((Route route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        build: (PdfPageFormat format) => File(widget.path).readAsBytes(),
        // onPrinted: _showPrintedToast,
        // onShared: _showSharedToast,
      ),
    );
    // PDFViewerScaffold(
    // path: widget.path,
    // appBar: AppBar(
    //   backgroundColor: Colors.blue,
    // ),
    // );
  }
}
