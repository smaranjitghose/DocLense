import 'package:flutter/services.dart';

class DocumentModel{
  String name;
  String shareLink;
  String documentPath;
  DateTime dateTime;
  String pdfPath;
  DocumentModel({
    this.name,
    this.shareLink="",
    this.documentPath,
    this.dateTime,
    this.pdfPath
  });
}