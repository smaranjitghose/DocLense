import 'dart:async';
import 'dart:io';

import 'package:doclense/Providers/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photofilters/photofilters.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as image_lib;
import 'package:provider/provider.dart';
import 'Providers/ImageList.dart';
import 'multi_select_delete.dart';

class FilterImage extends StatefulWidget {
  final File file;
  final ImageList list;
  const FilterImage(this.file, this.list);
  @override
  _FilterimageState createState() => _FilterimageState();
}

class _FilterimageState extends State<FilterImage> {
  String fileName;
  List<Filter> filters = presetFiltersList;
  File imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.file;
  }

  Future<void> getImage(BuildContext context, Color appBarColor) async {
//    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    fileName = basename(imageFile.path);
    var image = image_lib.decodeImage(imageFile.readAsBytesSync());
    image = image_lib.copyResize(image, width: 600);
    final Map imagefile = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => PhotoFilterSelector(
            appBarColor: appBarColor,
            title: const Text("Apply Filter"),
            image: image,
            filters: presetFiltersList,
            filename: fileName,
            loader: const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.teal,
              strokeWidth: 2,
            )),
            fit: BoxFit.contain,
          ),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 1000),
        ));
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        // widget.file = imagefile['image_filtered'] as File;
        imageFile = imagefile['image_filtered'] as File;
      });
      print(imageFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final Color appBarColor =
        themeChange.darkTheme ? Colors.black : Colors.blue[600];
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: (MediaQuery.of(context).size.height / 2).floor(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child:
                    // widget.file != null
                    // ? Image.file(widget.file)
                    imageFile != null
                        ? Image.file(imageFile)
                        : const Text("Image error"),
              ),
            ),
            Expanded(
              flex: (MediaQuery.of(context).size.height / 16).floor(),
              child: Container(
                height: 65,
                color:
                    themeChange.darkTheme ? Colors.black87 : Colors.blue[600],
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          children: const <Widget>[
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            Text(
                              "Back",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          getImage(context, appBarColor);
                        },
                        child: Column(
                          children: const <Widget>[
                            Icon(
                              Icons.filter,
                              color: Colors.white,
                            ),
                            Text(
                              "Filter",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // widget.list.imagelist.add(widget.file);
                          // widget.list.imagepath.add(widget.file.path);
                          widget.list.imagelist.add(imageFile);
                          widget.list.imagepath.add(imageFile.path);
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) =>
                                  MultiDelete(widget.list),
                              transitionsBuilder: (c, anim, a2, child) =>
                                  FadeTransition(opacity: anim, child: child),
                              // transitionDuration: Duration(milliseconds: 1000),
                            ),
                          );
                        },
                        child: Column(
                          children: const <Widget>[
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
