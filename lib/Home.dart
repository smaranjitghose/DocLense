import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'Imageview.dart';
import 'Providers/ImageList.dart';
import 'MainDrawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ImageList images = new ImageList();

  File imageFile;

  void chooseImage(ImageSource source) async {
    File fileGallery = await ImagePicker.pickImage(source: source);
    if (fileGallery != null) {
      imageFile = fileGallery;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Imageview(fileGallery, images)));
    }
  }

  @override
  Widget build(BuildContext context) {
//    return ChangeNotifierProvider.value(
//      value:imagelist;
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Center(
          child: Text(
            'DocLense',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey[900],
        onPressed: () {},
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              iconSize: 30,
              color: Colors.blueGrey[900],
              icon: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              onPressed: () {
                chooseImage(ImageSource.camera);
              },
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              color: Colors.white.withOpacity(0.2),
              width: 2,
              height: 15,
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              iconSize: 30,
              color: Colors.blueGrey[900],
              icon: Icon(
                Icons.image,
                color: Colors.white,
              ),
              onPressed: () {
                chooseImage(ImageSource.gallery);
              },
            )
          ],
        ),
      ),
    );
  }
}
