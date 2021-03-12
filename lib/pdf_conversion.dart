import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:permission/permission.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Directory externalDirectory;
  Directory pickedDirectory;

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

    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<dynamic> files = Hive.box('pdfs').getAt(0);
    files.add('$path' + '/${name}' + '.pdf');
    Hive.box('pdfs').putAt(0, files);
    print("PDFS : ${Hive.box('pdfs').getAt(0)}");
    //Directory documentDirectory = await getApplicationDocumentsDirectory();

    // Clearing the image list once the PDF is created and saved
    for (int i = 0; i < widget.list.imagelist.length; i++) {
      print('i = $i');
      widget.list.imagelist.removeAt(i);
      widget.list.imagepath.removeAt(i);
    }
    //String documentPath = documentDirectory.path;

    //File file = File("$documentPath/example.pdf");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Name Your PDF',
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          GestureDetector(
            child: Center(
              child: Text(
                "Choose Directory to save",
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: () async {
              await getPermissions();
              await getStorage();
              print("External : $externalDirectory");
              Navigator.of(context)
                  .push<FolderPickerPage>(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return FolderPickerPage(
                        rootDirectory: externalDirectory,
                        action: (BuildContext context,
                            Directory folder) async {
                          print("Picked directory $folder");
                          setState(() => pickedDirectory = folder);
                          Navigator.of(context).pop();
                        });
                  }));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
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
        onPressed: () {
          // if (name == null) {
          //   AlertDialog(
          //       backgroundColor: Colors.blueGrey[800],
          //       content: Text(
          //         "Enter PDF Name",
          //         style: TextStyle(color: Colors.white),
          //       ));
          // } else
          FocusScope.of(context).unfocus();
          _pushSaved();
        },
        child: Icon(
            Icons.arrow_forward,
            size: 40
        ),
      ),
    );
  }

  Future<void> getPermissions() async {
    final permissions =
        await Permission.getPermissionsStatus([PermissionName.Storage]);
    var request = true;
    switch (permissions[0].permissionStatus) {
      case PermissionStatus.allow:
        request = false;
        break;
      case PermissionStatus.always:
        request = false;
        break;
      default:
    }
    if (request) {
      await Permission.requestPermissions([PermissionName.Storage]);
    }
  }

  Future<void> getStorage() async {
    final directory = await getExternalStorageDirectory();
    setState(() => externalDirectory = directory);
  }

  Future<void> _pushSaved() async {
    name = Text(myController.text).data;


    //document.name = name;
    writeOnPdf();
    await savePdf();
    //Documents.add(document);
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    if (pickedDirectory != null) documentDirectory = pickedDirectory;

    String documentPath = documentDirectory.path;
    //document.documentPath = documentPath;
    String fullPath = "$documentPath" + "/${name}" + ".pdf";
    print(fullPath);


    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                PdfPreviewScreen(
                  path: fullPath,
                )));
  }
}
