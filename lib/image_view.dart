import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'Filterview.dart';
import 'Home.dart';
import 'Providers/ImageList.dart';
import 'Providers/ThemeProvider.dart';

class Imageview extends StatefulWidget {
  File file;
  ImageList list;
  Imageview(this.file, this.list);

  @override
  _ImageviewState createState() => _ImageviewState();
}

class _ImageviewState extends State<Imageview> {
  File cropped;

  List<File> files = [];
  int index;

  @override
  void initState() {
    super.initState();
    files.add(widget.file);
    index = 0;
  }

  cropimage(file, appBarColor, bgColor) async {
    if (file != null) {
      cropped = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 80,
          androidUiSettings: AndroidUiSettings(
            statusBarColor: appBarColor,
            toolbarColor: appBarColor,
            toolbarWidgetColor: Colors.white,
            backgroundColor: bgColor,
          )
      );
      setState(() {
        cropped == null ? file = files : file = cropped;
        files.add(file);
        index++;
      });
    }
  }

  Widget popupMenuButton() {
    return PopupMenuButton<IconOptions>(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<IconOptions>>[
        PopupMenuItem<IconOptions>(
          value: IconOptions.Share,
          child: Row(children: [
            Icon(
              Icons.share,
              size: 28.0,
              // color: Colors.blue,
            ),
            SizedBox(
              width: 23.0,
            ),
            Text(
              'Share',
              style: TextStyle(fontSize: 20.0),
            )
          ]),
        )
      ],
      onSelected: (IconOptions value) {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    Color appBarColor = themeChange.darkTheme ? Colors.black : Colors.blue[600];
    Color bgColor = themeChange.darkTheme ? Colors.black54 : Colors.white;

    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: (MediaQuery
                    .of(context)
                    .size
                    .height / 2).floor(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Image.file(
                    files[index],
                  ),
                ),
              ),
              Expanded(
                flex: (MediaQuery
                    .of(context)
                    .size
                    .height / 19).floor(),
                child: Container(
                  height: 65,
                  color: themeChange.darkTheme ? Colors.black87 : Colors.blue[600],
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
//                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
//                                      builder: (context) => Home()));
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
//                                  Navigator.of(context).pop();
                            if (index == 0) {} else {
                              setState(() {
                                index--;
                                files.removeLast();
                              });
                            }
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.undo,
                                color: Colors.white,
                              ),
                              Text(
                                "Undo",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            cropimage(widget.file, appBarColor, bgColor);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.crop_rotate,
                                color: Colors.white,
                              ),
                              Text(
                                "Crop",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            if (cropped != null) {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) =>
                                        filter_image(
                                            cropped, widget.list),
                                    transitionsBuilder: (c, anim, a2, child) =>
                                        FadeTransition(
                                            opacity: anim, child: child),
                                    // transitionDuration: Duration(milliseconds: 1000),
                                  ));
                            } else {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) =>
                                        filter_image(
                                            widget.file, widget.list),
                                    transitionsBuilder: (c, anim, a2, child) =>
                                        FadeTransition(
                                            opacity: anim, child: child),
                                  ));
                            }
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
              // ),
            ],
          ),
        ),
      ),
    );
  }
}