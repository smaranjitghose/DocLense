import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PdfPreviewScreen extends StatefulWidget {
  final String path;

  PdfPreviewScreen({this.path});

  @override
  _PdfPreviewScreenState createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  @override
  void initState() {
    super.initState();
    homePageTimer(); // calling the function
  }

  homePageTimer() {
    Timer(Duration(seconds: 0), () async {
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
