import 'dart:async';
import 'dart:io';

import 'package:doclense/Providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:provider/provider.dart';

import 'Providers/image_list.dart';
import 'multi_select_delete.dart';

class filter_image extends StatefulWidget {
  File file;
  ImageList list;
  filter_image(this.file, this.list);
  @override
  _filterimageState createState() => _filterimageState();
}

class _filterimageState extends State<filter_image> {
  String fileName;
  List<Filter> filters = presetFiltersList;
  File imageFile;

  @override
  void initState() {
    imageFile = widget.file;
  }

  Future getImage(context, appBarColor) async {
//    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    fileName = basename(imageFile.path);
    var image = imageLib.decodeImage(imageFile.readAsBytesSync());
    image = imageLib.copyResize(image, width: 600);
    Map imagefile = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => new PhotoFilterSelector(
            appBarColor: appBarColor,
            title: Text("Apply Filter"),
            image: image,
            filters: presetFiltersList,
            filename: fileName,
            loader: Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.teal,
              strokeWidth: 2,
            )),
            fit: BoxFit.contain,
          ),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 1000),
        ));
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        widget.file = imagefile['image_filtered'];
      });
      print(imageFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Color appBarColor = themeChange.darkTheme ? Colors.black : Colors.blue[600];
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: (MediaQuery.of(context).size.height / 2).floor(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: widget.file != null
                      ? Image.file(widget.file)
                      : Text("Image error"),
                ),
              ),
              Expanded(
                flex: (MediaQuery.of(context).size.height / 19).floor(),
                child: Container(
                  height: 65,
                  color:
                      themeChange.darkTheme ? Colors.black87 : Colors.blue[600],
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Column(
                            children: <Widget>[
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
                        FlatButton(
                          onPressed: () {
                            getImage(context, appBarColor);
                          },
                          child: Column(
                            children: <Widget>[
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
                        FlatButton(
                          onPressed: () {
                            widget.list.imagelist.add(widget.file);
                            widget.list.imagepath.add(widget.file.path);
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) =>
                                      multiDelete(widget.list),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(
                                          opacity: anim, child: child),
                                  // transitionDuration: Duration(milliseconds: 1000),
                                ));
                          },
                          child: Column(
                            children: <Widget>[
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
      ),
    );
  }
}
