import 'dart:io';

import 'package:doclense/configs/app_dimensions.dart';
import 'package:doclense/configs/app_typography.dart';
import 'package:doclense/configs/space.dart';
import 'package:doclense/configs/styles.dart';
import 'package:doclense/constants/appstrings.dart';
import 'package:doclense/constants/route_constants.dart';
import 'package:doclense/providers/image_list.dart';
import 'package:doclense/utils/image_converter.dart' as image_converter;
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class PDFConversion extends StatefulWidget {
  final ImageList list;
  const PDFConversion(this.list);
  @override
  _PDFConversion createState() => _PDFConversion();
}

class _PDFConversion extends State<PDFConversion> {
  //DocumentObject document;
  String? name;
  final myController = TextEditingController();
  Directory? externalDirectory;
  Directory? pickedDirectory;
  bool _isLoading = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  final pw.Document pdf = pw.Document();
  void writeOnPdf() {
    for (var i = 0; i < widget.list.imagelist.length; i++) {
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4.copyWith(
            marginTop: 0,
            marginBottom: 0,
            marginLeft: 0,
            marginRight: 0,
          ),
          build: (pw.Context context) {
            return pw.Expanded(
                // change this line to this:
                child: pw.Image(
                    pw.MemoryImage(
                        File(widget.list.imagepath[i]).readAsBytesSync()),
                    fit: pw.BoxFit.contain));
          }));
    }
  }

  Future<void> savePdf() async {
    // Get external storage directory
    final Directory? directory = await getExternalStorageDirectory();
    //Get directory path
    final String? path = directory?.path;
    if (path == null) return;
    //Create an empty file to write PDF data
    final String filePath = '$path/$name.pdf';
    final File file = File(filePath);
    //Write PDF data
    //await file.writeAsBytes(bytes, flush: true);
    file.writeAsBytesSync(await pdf.save());
    //document.pdfPath = path;
    //Open the PDF document in mobile
    OpenFile.open(filePath);

    final List<dynamic> files = Hive.box('pdfs').getAt(0) as List<dynamic>;
    final now = DateTime.now();
    final String formatter = DateFormat('yMd').format(now);
    final String previewImage = image_converter
        .base64StringFromImage(widget.list.imagelist[0].readAsBytesSync());
    files.add([filePath, formatter, previewImage]);
    Hive.box('pdfs').putAt(0, files);
    print("PDFS : ${Hive.box('pdfs').getAt(0)}");

    // Clearing the image list once the PDF is created and saved
    for (int i = 0; i < widget.list.imagelist.length; i++) {
      print('i = $i');
      widget.list.imagelist.removeAt(i);
      widget.list.imagepath.removeAt(i);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.nameYourPdf,
          style: AppText.b1b,
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              await getPermissions();
              await getStorage();
              print("External : $externalDirectory");

              Directory? folderDir = await FolderPicker.pick(
                  allowFolderCreation: true,
                  context: context,
                  rootDirectory: externalDirectory!,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppDimensions.normalize(5)),
                    ),
                  ));
              if (folderDir != null)
                setState(() => pickedDirectory = folderDir);
            },
            child: Padding(
              padding: Space.h1!,
              child: Icon(
                Icons.folder_open,
                size: AppDimensions.font(
                  12,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const SpinKitRotatingCircle(
              color: Colors.blue,
            )
          : Container(
              alignment: Alignment.center,
              padding: Space.h1,
              child: TextField(
                controller: myController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: S.pdfName,
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  focusedBorder: AppStyles().textFieldBorder,
                  enabledBorder: AppStyles().textFieldBorder,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          FocusScope.of(context).unfocus();
          _pushSaved();
        },
        child: Icon(Icons.arrow_forward, size: AppDimensions.font(12)),
      ),
    );
  }

  Future<void> getPermissions() async {
    PermissionStatus permissions = await Permission.storage.status;
    var request = true;
    switch (permissions) {
      case PermissionStatus.granted:
        request = false;
        break;
      // case PermissionStatus.always:
      //   request = false;
      //   break;
      default:
    }
    if (request) {
      await Permission.storage.request();
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

    if (pickedDirectory != null) documentDirectory = pickedDirectory!;

    final String documentPath = documentDirectory.path;
    //document.documentPath = documentPath;
    final String fullPath = '$documentPath/$name.pdf';
    print(fullPath);

    Navigator.of(context).pushNamed(
      RouteConstants.pdfPreviewScreen,
      arguments: {
        'path': fullPath,
        'name': name ?? "Pdf Preview",
      },
    );
  }
}
