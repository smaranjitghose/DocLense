import 'dart:io';
import 'Home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Providers/ImageList.dart';
import 'Imageview.dart';
import 'PDFConversion.dart';
import 'griditem.dart';

class multiDelete extends StatefulWidget {
  ImageList imageList;
  multiDelete(this.imageList);
  @override
  _multiDeleteState createState() => _multiDeleteState();
}

class _multiDeleteState extends State<multiDelete> {
  List<Item> itemList;
  List<Item> selectedList;
  File imageFile;

  @override
  void initState() {
    loadList();
    super.initState();
  }

  loadList() {
    itemList = List();
    selectedList = List();
    for (int i = 0; i < widget.imageList.length(); i++) {
      itemList.add(Item(widget.imageList.imagelist.elementAt(i), i));
    }
  }

  Future<void> _showChoiceDialog_del(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blueGrey[800],
            title: Text(
              "Delete selected item(s)?",
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        for (int i = 0; i < selectedList.length; i++) {
                          int idx = widget.imageList.imagelist.indexOf(
                              itemList[itemList.indexOf(selectedList[i])]
                                  .imageUrl);
                          widget.imageList.imagelist.removeAt(idx);
                          widget.imageList.imagepath.removeAt(idx);
                          itemList.remove(selectedList[i]);
                        }
                        selectedList = List();
                      });
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  multiDelete(widget.imageList)));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  GestureDetector(
                    child: Text(
                      "No",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  multiDelete(widget.imageList)));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _openGallery() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Imageview(imageFile, widget.imageList)));
  }

  _openCamera() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Imageview(imageFile, widget.imageList)));
  }

  Future<void> _showChoiceDialog_add(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blueGrey[800],
            title: Text(
              "Add more pages with:",
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "Gallery",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _openGallery();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  GestureDetector(
                    child: Text(
                      "Camera",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _openCamera();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey[100],
        appBar: getAppBar(),
        body: GridView.builder(
            itemCount: itemList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 10,
                  child: GridItem(
                      item: itemList[index],
                      isSelected: (bool value) {
                        setState(() {
                          if (value) {
                            selectedList.add(itemList[index]);
                          } else {
                            selectedList.remove(itemList[index]);
                          }
                        });
                        print("$index : $value");
                      },
                      key: Key(itemList[index].rank.toString())),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          // backgroundColor: Colors.blue[600],
          onPressed: () {},
          child: IconButton(
            iconSize: 40,
            onPressed: () {
              _showChoiceDialog_add(context);
            },
            // color: Colors.blue[600],
            icon: Icon(
              Icons.add,
              // color: Colors.teal,
            ),
          ),
        ));
  }

  getAppBar() {
    return AppBar(
      // backgroundColor: Colors.blue[600],
      title: Text(selectedList.length < 1
          ? "Documents"
          : "${selectedList.length} item selected"),
      actions: <Widget>[
        selectedList.length < 1
            ? Container()
            : InkWell(
            onTap: () {
              _showChoiceDialog_del(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete,
              ),
            )),
        IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => PDFConversion(widget.imageList),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    // transitionDuration: Duration(milliseconds: 2000),
                  ));
              // MaterialPageRoute(
              //     builder: (context) => PDFConversion(widget.imageList)));
            }),
        IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            })
      ],
    );
  }
}

class Item {
  File imageUrl;
  int rank;

  Item(this.imageUrl, this.rank);
}