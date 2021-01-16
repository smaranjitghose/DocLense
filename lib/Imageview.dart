import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/cupertino.dart';
import 'Filterview.dart';
import 'Home.dart';
import 'Providers/ImageList.dart';

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

  cropimage(file) async {
    if (file != null) {
      cropped = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 80,
      );
      setState(() {
        file = cropped;
        files.add(file);
        index++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.blueGrey[100],
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Image.file(files[index]),
                ),
              ),
              SafeArea(
                child: Expanded(
                  flex: 1,
                  child: Container(
                    height: 65,
                    color: Colors.blue[600],
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
                            color: Colors.blue[600],
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
                              if(index == 0) {
                                
                              }
                              else {
                                setState(() {
                                  index--;
                                  files.removeLast();
                                });
                              }
                            },
                            color: Colors.blue[600],
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
                              cropimage(widget.file);
                            },
                            color: Colors.blue[600],
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
                                    MaterialPageRoute(
                                        builder: (context) => filter_image(
                                            cropped, widget.list)));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => filter_image(
                                            widget.file, widget.list)));
                              }
                            },
                            color: Colors.blue[600],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
