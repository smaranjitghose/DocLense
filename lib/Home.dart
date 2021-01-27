import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'Imageview.dart';
import 'Providers/ImageList.dart';
import 'MainDrawer.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:share/share.dart';

enum IconOptions { Share }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ImageList images = new ImageList();

  // File imageFile;

  final picker = ImagePicker();

  void getImage(ImageSource imageSource) async {
    PickedFile imageFile = await picker.getImage(source: imageSource);
    if (imageFile == null) return;
    File tmpFile = File(imageFile.path);
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final localFile = await tmpFile.copy('${appDir.path}/$fileName');

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Imageview(tmpFile, images)));
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
              color: Colors.blue,
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
        setState(() {
          Share.share('Share my PDF');
          //TODO: add pdf file that is to be shared
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
//    return ChangeNotifierProvider.value(
//      value:imagelist;
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
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
          popupMenuButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue[600],
        onPressed: () {},
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              iconSize: 30,
              color: Colors.blue[600],
              icon: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              onPressed: () {
                getImage(ImageSource.camera);
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
              color: Colors.blue[600],
              icon: Icon(
                Icons.image,
                color: Colors.white,
              ),
              onPressed: () {
                getImage(ImageSource.gallery);
              },
            )
          ],
        ),
      ),
    );
  }
}
