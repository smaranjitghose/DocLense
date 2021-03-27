import 'dart:async';
import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:documentscanner2/Providers/documentProvider.dart';
import 'package:documentscanner2/cropImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:provider/provider.dart';

class ShowImage extends StatefulWidget {
  File file;
  var imagePixelSize;
  double width;
  double height;
  Offset tl, tr, bl, br;
  GlobalKey<AnimatedListState> animatedListKey;
  ShowImage(
      {this.file,
      this.bl,
      this.br,
      this.tl,
      this.height,
      this.tr,
      this.imagePixelSize,
      this.width,
      this.animatedListKey});
  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  TextEditingController nameController = TextEditingController();
  final _focusNode = FocusNode();
  MethodChannel channel = new MethodChannel('opencv');
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 0;
  bool isBottomOpened = false;
  PersistentBottomSheetController controller;
  var whiteboardBytes;
  var originalBytes;
  var grayBytes;
  bool isGrayBytes = false;
  bool isOriginalBytes = false;
  bool isWhiteBoardBytes = false;
  bool isRotating = false;
  int angle = 0;
  String canvasType = "whiteboard";
  double tl_x;
  double tr_x;
  double bl_x;
  double br_x;
  double tl_y;
  double tr_y;
  double bl_y;
  double br_y;
  var bytes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = "Scan" + DateTime.now().toString();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        nameController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: nameController.text.length,
        );
      }
    });
    tl_x = (widget.imagePixelSize.width / widget.width) * widget.tl.dx;
    tr_x = (widget.imagePixelSize.width / widget.width) * widget.tr.dx;
    bl_x = (widget.imagePixelSize.width / widget.width) * widget.bl.dx;
    br_x = (widget.imagePixelSize.width / widget.width) * widget.br.dx;

    tl_y = (widget.imagePixelSize.height / widget.height) * widget.tl.dy;
    tr_y = (widget.imagePixelSize.height / widget.height) * widget.tr.dy;
    bl_y = (widget.imagePixelSize.height / widget.height) * widget.bl.dy;
    br_y = (widget.imagePixelSize.height / widget.height) * widget.br.dy;
    convertToGray();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (isBottomOpened) {
      Navigator.of(context).pop();
      isBottomOpened = false;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Discard this Scan?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(
              thickness: 2,
            ),
            Text(
              "This will discard the scans you have captured. Are you sure?",
              style: TextStyle(color: Colors.grey[500]),
            )
          ],
        )),
        actions: <Widget>[
          OutlineButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          OutlineButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              return false;
            },
            child: Text(
              "Discard",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                color: Colors.black,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Save as PDF",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await widget.file
                                .writeAsBytes(bytes)
                                .then((_) async {
                              print(ImageSizGetter.getSize(widget.file));
                              Provider.of<DocumentProvider>(context,
                                      listen: false)
                                  .saveDocument(
                                      name: nameController.text,
                                      documentPath: widget.file.path,
                                      dateTime: DateTime.now(),
                                      animatedListKey: widget.animatedListKey,
                                      angle: angle);
                            });
                          },
                        )
                      ],
                    ),
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ThemeData.dark().cardColor,
                      ),
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        focusNode: _focusNode,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        controller: nameController,
                      ),
                    )
                  ],
                ),
              ),
              bytes == null
                  ? Container()
                  : isRotating
                      ? Center(
                          child: Container(
                              height: 150,
                              width: 100,
                              child: Center(
                                  child: Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black),
                                ),
                              ))))
                      : Center(
                          child: Container(
                              padding: EdgeInsets.all(10),
                              constraints:
                                  BoxConstraints(maxHeight: 300, maxWidth: 250),
                              child: Image.memory(bytes))),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.black,
        onTap: (index) async {
          if (index == 0) {
            if (isBottomOpened) {
              isBottomOpened = false;
              Navigator.of(context).pop();
            }
            setState(() {
              isRotating = true;
            });
            Timer(Duration(seconds: 1), () async {
              bytes = await channel.invokeMethod('rotate', {"bytes": bytes});
            });

            Timer(Duration(seconds: 4), () async {
              if (angle == 360) {
                angle = 0;
              }
              angle = angle + 90;
              bytes = await channel
                  .invokeMethod('rotateCompleted', {"bytes": bytes});
              setState(() {
                isRotating = false;
              });
            });
          }
          if (index == 1) {
            if (isBottomOpened) {
              isBottomOpened = false;
              Navigator.of(context).pop();
            }
            Navigator.of(context)
                .push(MaterialPageRoute(
              builder: (context) => CropImage(widget.file),
            ))
                .then((value) {
              if (value != null) {
                tl_x = value[1];
                tl_y = value[2];
                tr_x = value[3];
                tr_y = value[4];
                bl_x = value[5];
                bl_y = value[6];
                br_x = value[7];
                br_y = value[8];
                setState(() {
                  bytes = value[0];
                  isGrayBytes = false;
                  isOriginalBytes = false;
                  isWhiteBoardBytes = false;
                });
              }
            });
          }
          if (index == 2) {
            if (isBottomOpened) {
              Navigator.of(context).pop();
              isBottomOpened = false;
            } else {
              isBottomOpened = true;
              BottomSheet bottomSheet = BottomSheet(
                onClosing: () {},
                builder: (context) => colorBottomSheet(),
                enableDrag: true,
              );
              controller = scaffoldKey.currentState
                  .showBottomSheet((context) => bottomSheet);
            }
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.rotate_right,
                color: Colors.black,
              ),
              title: Text("Rotate")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.crop,
                color: Colors.black,
              ),
              title: Text("Crop")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.color_lens,
                color: Colors.black,
              ),
              title: Text("Color")),
        ],
      ),
    );
  }

  Widget colorBottomSheet() {
    if (isOriginalBytes == false) {
      grayandoriginal();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (originalBytes != null) {
                print("original");
                Navigator.of(context).pop();
                isBottomOpened = false;
                canvasType = "original";
                Timer(Duration(milliseconds: 500), () {
                  angle = 0;
                  setState(() {
                    bytes = originalBytes;
                  });
                });
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    width: 80,
                    margin: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: isOriginalBytes
                        ? Image.memory(
                            originalBytes,
                            fit: BoxFit.fill,
                            height: 120,
                          )
                        : Container(
                            height: 120,
                            child: Center(
                              child: Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.black),
                                  )),
                            ),
                          )),
                Text("Original"),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              print("whiteboard");
              Navigator.of(context).pop();
              isBottomOpened = false;
              angle = 0;
              canvasType = "whiteboard";
              Timer(Duration(milliseconds: 500), () {
                setState(() {
                  bytes = whiteboardBytes;
                });
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 80,
                  margin: EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: isWhiteBoardBytes
                      ? Image.memory(
                          whiteboardBytes,
                          fit: BoxFit.fill,
                          height: 120,
                        )
                      : Container(
                          height: 120,
                          child: Center(
                            child: Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black),
                                )),
                          ),
                        ),
                ),
                Text("Whiteboard"),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              print("gray");
              Navigator.of(context).pop();
              isBottomOpened = false;
              angle = 0;
              canvasType = "gray";
              Timer(Duration(milliseconds: 500), () {
                setState(() {
                  bytes = grayBytes;
                });
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 80,
                  margin: EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: isGrayBytes
                      ? Image.memory(
                          grayBytes,
                          fit: BoxFit.fill,
                          height: 120,
                        )
                      : Container(
                          height: 120,
                          child: Center(
                            child: Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black),
                                )),
                          ),
                        ),
                ),
                Text("Grayscale"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> convertToGray() async {
    var bytesArray = await channel.invokeMethod('convertToGray', {
      'filePath': widget.file.path,
      'tl_x': tl_x,
      'tl_y': tl_y,
      'tr_x': tr_x,
      'tr_y': tr_y,
      'bl_x': bl_x,
      'bl_y': bl_y,
      'br_x': br_x,
      'br_y': br_y,
    });
    setState(() {
      bytes = bytesArray;
      whiteboardBytes = bytesArray;
    });
    return bytesArray;
  }

  Future<void> grayandoriginal() async {
    Future.delayed(Duration(seconds: 1), () {
      channel.invokeMethod('gray', {
        'filePath': widget.file.path,
        'tl_x': tl_x,
        'tl_y': tl_y,
        'tr_x': tr_x,
        'tr_y': tr_y,
        'bl_x': bl_x,
        'bl_y': bl_y,
        'br_x': br_x,
        'br_y': br_y,
      });
      channel.invokeMethod('whiteboard', {
        'filePath': widget.file.path,
        'tl_x': tl_x,
        'tl_y': tl_y,
        'tr_x': tr_x,
        'tr_y': tr_y,
        'bl_x': bl_x,
        'bl_y': bl_y,
        'br_x': br_x,
        'br_y': br_y,
      });
      channel.invokeMethod('original', {
        'filePath': widget.file.path,
        'tl_x': tl_x,
        'tl_y': tl_y,
        'tr_x': tr_x,
        'tr_y': tr_y,
        'bl_x': bl_x,
        'bl_y': bl_y,
        'br_x': br_x,
        'br_y': br_y,
      });
    });
    Timer(Duration(seconds: 7), () {
      print("this started");
      channel.invokeMethod('grayCompleted').then((value) {
        grayBytes = value;
        isGrayBytes = true;
      });
      channel.invokeMethod('whiteboardCompleted').then((value) {
        whiteboardBytes = value;
        isWhiteBoardBytes = true;
      });
      channel.invokeMethod('originalCompleted').then((value) {
        originalBytes = value;
        isOriginalBytes = true;
        if (isBottomOpened) {
          Navigator.pop(context);
          BottomSheet bottomSheet = BottomSheet(
            onClosing: () {},
            builder: (context) => colorBottomSheet(),
            enableDrag: true,
          );
          controller = scaffoldKey.currentState
              .showBottomSheet((context) => bottomSheet);
        }
      });
    });
  }
}
