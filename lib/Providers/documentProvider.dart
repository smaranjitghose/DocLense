import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:documentscanner2/Model/documentModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DocumentProvider extends ChangeNotifier {
  List<DocumentModel> allDocuments = [];
  Future<bool> getDocuments() async {
    allDocuments = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getKeys());
    sharedPreferences.getKeys().forEach((key) {
      var jsonDocument = json.decode(sharedPreferences.getString(key));
      DocumentModel document = DocumentModel(
          name: jsonDocument['name'],
          documentPath: jsonDocument['documentPath'],
          dateTime: DateTime.parse(jsonDocument['dateTime']),
          pdfPath: jsonDocument['pdfPath'],
          shareLink: jsonDocument['shareLink']);
      allDocuments.add(document);
      print(document.documentPath);
    });
    allDocuments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    DocumentModel document = DocumentModel(
          name: "firstCard55466222",
          documentPath: "",
          dateTime:DateTime.utc(1969, 7, 20, 20, 18, 04),
          pdfPath: "",
          shareLink: "");
    allDocuments.add(document);
    notifyListeners();
    return true;
  }

  void saveDocument(
      {@required String name,
      @required String documentPath,
      @required DateTime dateTime,
      String shareLink,
      GlobalKey<AnimatedListState> animatedListKey,
      int angle}) async {
    final pdf = pw.Document();
    final image = PdfImage.file(
      pdf.document,
      bytes: File(documentPath).readAsBytesSync(),
    );
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat(2480, 3508),
      build: (pw.Context context) {
        return pw.Image(image, fit: angle==0 || angle==180?pw.BoxFit.fill:pw.BoxFit.fitWidth);
      },
    ));
    final tempDir = await getTemporaryDirectory();
    String pdfPath = tempDir.path + "/${name}" + ".pdf";
    File pdfFile = File(pdfPath);
    print(pdfPath);
    pdfFile.writeAsBytes(pdf.save());

    DocumentModel document = DocumentModel(
        name: name,
        documentPath: documentPath,
        dateTime: dateTime,
        pdfPath: pdfPath,
        shareLink: shareLink);

    String jsonDocument = json.encode({
      "name": document.name,
      "documentPath": document.documentPath,
      "dateTime": document.dateTime.toString(),
      "shareLink": document.shareLink,
      "pdfPath": document.pdfPath
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        document.dateTime.millisecondsSinceEpoch.toString(), jsonDocument);
    allDocuments.add(document);
    allDocuments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    Timer(Duration(milliseconds: 500), () {
      animatedListKey.currentState.insertItem(0);
    });
  }

  void deleteDocument(int index, String key) async {
    Timer(Duration(milliseconds: 300),(){
      allDocuments.removeAt(index);
      notifyListeners();
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);
  }

  void renameDocument(int index, String key, String changedName) async {
    allDocuments[index].name = changedName;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);

    String jsonDocument = json.encode({
      "name": allDocuments[index].name,
      "documentPath": allDocuments[index].documentPath,
      "dateTime": allDocuments[index].dateTime.toString(),
      "shareLink": allDocuments[index].shareLink,
      "pdfPath": allDocuments[index].pdfPath
    });
    await sharedPreferences.setString(key, jsonDocument);
    Timer(Duration(milliseconds: 800), () {
      notifyListeners();
    });
  }
}
