import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'Providers/ImageList.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'PDFPreviewScreen.dart';

class PDFConversion extends StatefulWidget {
  ImageList list;
  PDFConversion(this.list);
  @override
  _PDFConversion createState() => _PDFConversion();
}

class _PDFConversion extends State<PDFConversion> {
  //DocumentObject document;
  var name;
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  final pw.Document pdf = pw.Document();
  writeOnPdf() {
    for (var i = 0; i < widget.list.imagelist.length; i++) {
      final image = PdfImage.file(
        pdf.document,
        bytes: File(widget.list.imagepath[i]).readAsBytesSync(),
      );
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(image));
          }));
    }
  }

  Future savePdf() async {
    //Get external storage directory
    Directory directory = await getExternalStorageDirectory();
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path' + '/${name}' + '.pdf');
    //Write PDF data
    //await file.writeAsBytes(bytes, flush: true);
    file.writeAsBytesSync(pdf.save());
    //document.pdfPath = path;
    //Open the PDF document in mobile
    OpenFile.open('$path' + '/${name}' + '.pdf');
    //Directory documentDirectory = await getApplicationDocumentsDirectory();

    //String documentPath = documentDirectory.path;

    //File file = File("$documentPath/example.pdf");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'Name Your PDF',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            color: Colors.blueGrey[100],
            child:
                // The first text field is focused on as soon as the app starts.
                Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: myController,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[900],
        child: IconButton(
          iconSize: 40,
          onPressed: () {
            // if (name == null) {
            //   AlertDialog(
            //       backgroundColor: Colors.blueGrey[800],
            //       content: Text(
            //         "Enter PDF Name",
            //         style: TextStyle(color: Colors.white),
            //       ));
            // } else
            _pushSaved();
          },
          color: Colors.blueGrey[900],
          icon: Icon(
            Icons.arrow_forward,
            color: Colors.teal,
          ),
        ),
      ),
    );
  }

  Future<void> _pushSaved() async {
    name = Text(myController.text).data;
    //document.name = name;
    writeOnPdf();
    await savePdf();
    //Documents.add(document);
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;
    //document.documentPath = documentPath;
    String fullPath = "$documentPath" + "/${name}" + ".pdf";

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => PdfPreviewScreen(
                  path: fullPath,
                )));
  }
}
