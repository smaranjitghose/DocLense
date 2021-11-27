import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
// import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PdfPreviewScreen extends StatefulWidget {
  final String path;
  final String name;
  const PdfPreviewScreen({required this.path, required this.name});

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
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf preview"),
      ),
      body: PdfPreview(
        canDebug: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        allowPrinting: false,
        allowSharing: false,
        pageFormats: <String, PdfPageFormat>{
          'A4': PdfPageFormat.a4,
          'Letter': PdfPageFormat.letter,
          'A3': PdfPageFormat.a3,
          'A5': PdfPageFormat.a5,
          'Standard': PdfPageFormat.standard,
        },
        build: (PdfPageFormat format) {
          return File(widget.path).readAsBytes();
        },
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
