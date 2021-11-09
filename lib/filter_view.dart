import 'dart:async';
import 'dart:io';

import 'package:doclense/constants/route_constants.dart';
import 'package:doclense/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photofilters/photofilters.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as image_lib;
import 'package:provider/provider.dart';
import 'providers/image_list.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    imageFile = widget.file;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> getImage(BuildContext context, Color appBarColor) async {
//    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    fileName = basename(imageFile.path);
    var image = image_lib.decodeImage(imageFile.readAsBytesSync());
    image = image_lib.copyResize(image, width: 600);
    final Map imagefile = await Navigator.of(context).pushNamed(
      RouteConstants.photoFilterSelector,
      arguments: {
        'title': const Text("Apply Filter"),
        'image': image,
        'appBarColor': appBarColor,
        'filters': presetFiltersList,
        'fileName': fileName,
        'loader': const Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.teal,
          strokeWidth: 2,
        )),
        'fit': BoxFit.contain,
      },
    ) as Map;
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
      body: _isLoading
          ? const SpinKitRotatingCircle(
              color: Colors.blue,
            )
          : SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 7,
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
                    child: Container(
                      height: 65,
                      color: themeChange.darkTheme
                          ? Colors.black87
                          : Colors.blue[600],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                Navigator.of(context).pushNamed(
                                  RouteConstants.multiDelete,
                                  arguments: widget.list,
                                );
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
