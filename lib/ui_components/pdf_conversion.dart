import "dart:async";
import "dart:io";

import "package:doclense/configs/app_dimensions.dart";
import "package:doclense/configs/app_typography.dart";
import "package:doclense/configs/space.dart";
import "package:doclense/configs/styles.dart";
import "package:doclense/constants/appstrings.dart";
import "package:doclense/constants/route_constants.dart";
import "package:doclense/providers/image_list.dart";
import "package:doclense/utils/image_converter.dart" as image_converter;
import "package:easy_folder_picker/FolderPicker.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:hive/hive.dart";
import "package:intl/intl.dart";
import "package:open_file/open_file.dart";
import "package:path_provider/path_provider.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:permission_handler/permission_handler.dart";

class PDFConversion extends StatefulWidget {
  const PDFConversion(this.list, {super.key});
  final ImageList list;
  @override
  PDFConversionState createState() => PDFConversionState();
}

class PDFConversionState extends State<PDFConversion> {
  //DocumentObject document;
  String? name;
  final TextEditingController myController = TextEditingController();
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
    for (int i = 0; i < widget.list.imagelist.length; i++) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.copyWith(
            marginTop: 0,
            marginBottom: 0,
            marginLeft: 0,
            marginRight: 0,
          ),
          build: (pw.Context context) => pw.Expanded(
            // change this line to this:
            child: pw.Image(
              pw.MemoryImage(
                File(widget.list.imagepath[i]).readAsBytesSync(),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> savePdf() async {
    // Get external storage directory
    final Directory? directory = await getExternalStorageDirectory();
    //Get directory path
    final String? path = directory?.path;
    if (path == null) {
      return;
    }
    //Create an empty file to write PDF data
    final String filePath = "$path/$name.pdf";
    // final File file = File(filePath)
    //   //Write PDF data
    //   //await file.writeAsBytes(bytes, flush: true);
    //   ..writeAsBytesSync(
    //     await pdf.save(),
    //   );
    //document.pdfPath = path;
    //Open the PDF document in mobile
    await OpenFile.open(filePath);

    final List<dynamic> files = Hive.box("pdfs").getAt(0) as List<dynamic>;
    final DateTime now = DateTime.now();
    final String formatter = DateFormat("yMd").format(now);
    final String previewImage = image_converter
        .base64StringFromImage(widget.list.imagelist[0].readAsBytesSync());
    files.add(<String>[filePath, formatter, previewImage]);
    await Hive.box("pdfs").putAt(0, files);
    debugPrint("PDFS : ${Hive.box('pdfs').getAt(0)}");

    // Clearing the image list once the PDF is created and saved
    for (int i = 0; i < widget.list.imagelist.length; i++) {
      debugPrint("i = $i");
      widget.list.imagelist.removeAt(i);
      widget.list.imagepath.removeAt(i);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            S.nameYourPdf,
            style: AppText.b1b,
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () async {
                await getPermissions();
                await getStorage().whenComplete(() async {
                  debugPrint("External : $externalDirectory");

                  final Directory? folderDir = await FolderPicker.pick(
                    allowFolderCreation: true,
                    context: context,
                    rootDirectory: externalDirectory!,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.normalize(5)),
                      ),
                    ),
                  );
                  if (folderDir != null) {
                    setState(() => pickedDirectory = folderDir);
                  }
                });
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
          onPressed: () async {
            FocusScope.of(context).unfocus();
            await _pushSaved();
          },
          child: Icon(Icons.arrow_forward, size: AppDimensions.font(12)),
        ),
      );

  Future<void> getPermissions() async {
    final PermissionStatus permissions = await Permission.storage.status;
    bool request = true;
    switch (permissions) {
      case PermissionStatus.granted:
        request = false;
      // case PermissionStatus.always:
      //   request = false;
      //   break;

      case PermissionStatus.denied:
        request = true;
      case PermissionStatus.restricted:
        request = true;
      case PermissionStatus.limited:
        request = true;
      case PermissionStatus.permanentlyDenied:
        request = true;
    }
    if (request) {
      await Permission.storage.request();
    }
  }

  Future<void> getStorage() async {
    final Directory? directory = await getExternalStorageDirectory();
    setState(() => externalDirectory = directory);
  }

  Future<void> _pushSaved() async {
    name = Text(myController.text).data;

    //document.name = name;
    writeOnPdf();
    await savePdf();
    //Documents.add(document);
    await getApplicationDocumentsDirectory()
        .then((Directory documentDirectory) {
      if (pickedDirectory != null) {
        documentDirectory = pickedDirectory!;
      }

      final String documentPath = documentDirectory.path;
      //document.documentPath = documentPath;
      final String fullPath = "$documentPath/$name.pdf";
      debugPrint(fullPath);

      unawaited(
        Navigator.of(context).pushNamed(
          RouteConstants.pdfPreviewScreen,
          arguments: <String, String>{
            "path": fullPath,
            "name": name ?? "Pdf Preview",
          },
        ),
      );
    });
  }
}
