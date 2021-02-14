import 'dart:async';

import 'package:doclense/Home.dart';
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
    homePageTimer();  // calling the function
  }

  homePageTimer() {
    Timer(Duration(seconds: 0), () async {
      Navigator.pushReplacement(
          context, PageRouteBuilder(
        pageBuilder: (c, a1, a2) => Home(),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        // transitionDuration: Duration(milliseconds: 1000),
      ));  // pushing HomePage()
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
