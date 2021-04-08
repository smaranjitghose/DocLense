import 'dart:io';

import 'package:doclense/constants/route_constants.dart';
import 'package:doclense/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

import 'providers/image_list.dart';
import 'providers/theme_provider.dart';

class Imageview extends StatefulWidget {
  final File file;
  final ImageList list;
  const Imageview(
    this.file,
    this.list,
  );

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

  Future<void> cropimage(File file, Color appBarColor, Color bgColor) async {
    if (file != null) {
      cropped = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 80,
        androidUiSettings: AndroidUiSettings(
          statusBarColor: appBarColor,
          toolbarColor: appBarColor,
          toolbarWidgetColor: Colors.white,
          backgroundColor: bgColor,
        ),
      );
      setState(() {
        // cropped == null ? file = files : file = cropped;
        // files.add(file);

        if (cropped != null) {
          files.add(cropped);
        } else {
          files.add(file);
        }
        index++;
      });
    }
  }

  Widget popupMenuButton() {
    return PopupMenuButton<IconOptions>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<IconOptions>>[
        PopupMenuItem<IconOptions>(
          value: IconOptions.share,
          child: Row(children: const [
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

    final Color appBarColor =
        themeChange.darkTheme ? Colors.black : Colors.blue[600];
    final Color bgColor = themeChange.darkTheme ? Colors.black54 : Colors.white;

    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Image.file(
                  files[index],
                ),
              ),
            ),
            Expanded(
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
//                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
//                                      builder: (context) => Home()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
//                                  Navigator.of(context).pop();
                          if (index == 0) {
                          } else {
                            setState(() {
                              index--;
                              files.removeLast();
                            });
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const <Widget>[
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
                      TextButton(
                        onPressed: () {
                          cropimage(widget.file, appBarColor, bgColor);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const <Widget>[
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
                      TextButton(
                        onPressed: () {
                          if (cropped != null) {
                            goToFilterImageScreen(
                              file: cropped,
                            );
                          } else {
                            goToFilterImageScreen(
                              file: widget.file,
                            );
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  void goToFilterImageScreen({File file}) {
    Navigator.of(context).pushNamed(
      RouteConstants.filterImageScreen,
      arguments: {
        'file': file,
        'list': widget.list,
      },
    );
  }
}
