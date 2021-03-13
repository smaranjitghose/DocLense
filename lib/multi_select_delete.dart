import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// import 'home.dart';
import 'image_view.dart';
import 'pdf_conversion.dart';
import 'Providers/image_list.dart';
import 'grid_item.dart';

class MultiDelete extends StatefulWidget {
  final ImageList imageList;
  const MultiDelete(this.imageList);
  @override
  _MultiDeleteState createState() => _MultiDeleteState();
}

class _MultiDeleteState extends State<MultiDelete> {
  List<Item> itemList;
  List<Item> selectedList;
  File imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    loadList();
    super.initState();
  }

  void loadList() {
    itemList = [];
    selectedList = [];
    for (int i = 0; i < (widget.imageList.length() as int); i++) {
      itemList.add(Item(widget.imageList.imagelist.elementAt(i), i));
    }
  }

  Future<void> _showChoiceDialogDel(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blueGrey[800],
            title: const Text(
              "Delete selected item(s)?",
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        for (int i = 0; i < selectedList.length; i++) {
                          final int idx = widget.imageList.imagelist.indexOf(
                              itemList[itemList.indexOf(selectedList[i])]
                                  .imageUrl);
                          widget.imageList.imagelist.removeAt(idx);
                          widget.imageList.imagepath.removeAt(idx);
                          itemList.remove(selectedList[i]);
                        }
                        selectedList = [];
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  multiDelete(widget.imageList)));
                    },
                    child: const Text(
                      "No",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showChoiceDialogHome(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            backgroundColor: Colors.blueGrey[800],
            title: const Text(
              "All your progress will be lost.\nDo you want to go back to home?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      for (int i = 0; i < itemList.length; i++) {
                        print('i = $i');
                        print(widget.imageList.imagelist.length);
                        final int idx = widget.imageList.imagelist.indexOf(
                            itemList[itemList.indexOf(itemList[i])].imageUrl);
                        widget.imageList.imagelist.removeAt(idx);
                        widget.imageList.imagepath.removeAt(idx);
                        // itemList.remove(idx);
                        itemList.removeAt(idx);
                      }
                      Navigator.of(ctx).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text(
                      "Yes",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text(
                      "No",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _openGallery() async {
    final picture = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(picture.path);
    });
    if (imageFile != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Imageview(imageFile, widget.imageList)));
    }
  }

  Future<void> _openCamera() async {
    final picture = await picker.getImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(picture.path);
    });
    if (imageFile != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Imageview(imageFile, widget.imageList)));
    }
  }

  Future<void> _showChoiceDialogAdd(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blueGrey[800],
            title: const Text(
              "Add more pages with:",
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _openGallery();
                    },
                    child: const Text(
                      "Gallery",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _openCamera();
                    },
                    child: const Text(
                      "Camera",
                      style: TextStyle(color: Colors.white),
                    ),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              _showChoiceDialogAdd(context);
            },
            // color: Colors.blue[600],
            icon: const Icon(
              Icons.add,
              // color: Colors.teal,
            ),
          ),
        ));
  }

  AppBar getAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          if (itemList.isNotEmpty) {
            setState(() {
              widget.imageList.imagelist.removeAt(itemList.length - 1);
              widget.imageList.imagepath.removeAt(itemList.length - 1);
              itemList.removeAt(itemList.length - 1);
            });
          }
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(selectedList.isEmpty
          ? "Documents"
          : "${selectedList.length} item selected"),
      actions: <Widget>[
        if (selectedList.isEmpty)
          Container()
        else
          InkWell(
              onTap: () {
                _showChoiceDialogDel(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                ),
              )),
        IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => PDFConversion(widget.imageList),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    // transitionDuration: Duration(milliseconds: 2000),
                  ));
            }),
        IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              _showChoiceDialogHome(context);
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
