import 'dart:async';

// import 'package:doclense/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PdfPreviewScreen extends StatefulWidget {
  final String path;

  const PdfPreviewScreen({this.path});

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
    return PDFViewerScaffold(
      path: widget.path,
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      // ),
    );
  }
}
