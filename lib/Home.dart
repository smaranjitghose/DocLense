import 'package:doclense/PDFPreviewScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Imageview.dart';
import 'Providers/ImageList.dart';
import 'MainDrawer.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'About.dart';
import 'package:quick_actions/quick_actions.dart';

enum IconOptions { Share }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future setSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getStringList('savedFiles') == null) {
      sharedPreferences.setStringList('savedFiles', []);
      return [];
    } else {
      return sharedPreferences.getStringList('savedFiles');
    }
  }
  ImageList images = new ImageList();
  QuickActions quickActions = QuickActions();

  _navigate(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
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

  // List<String> savedPdfs;

  @override
  void initState() {
    super.initState();

    // setSharedPreferences().then((value) {
    //   savedPdfs = value;
    //   print('Saved : $savedPdfs');
    // });
    quickActions.initialize((String shortcutType) {
      switch (shortcutType) {
        case 'about':
          return _navigate(About());

      //! un comment the below line once the starred document and setting screen is created
      // case 'starredDocument':
      //   return _navigate(//TODO: enter starred document screen name);
      //   case 'setting':
      //   return _navigate(//TODO: enter setting screen name);

        default:
          return MaterialPageRoute(builder: (_) {
            return Scaffold(
              body: Center(
                child: Text('No Page defined for $shortcutType'),
              ),
            );
          });
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
          type: 'about', localizedTitle: 'About DocLense', icon: 'info'),

      //! un comment the below line once the starred document and setting screen is created
      // ShortcutItem(type: 'starredDocument', localizedTitle: 'Starred Documents', icon: 'starred'),
      // ShortcutItem(type: 'setting', localizedTitle: 'Setting', icon: 'setting'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
//    return ChangeNotifierProvider.value(
//      value:imagelist;
    return Scaffold(
      // backgroundColor: Colors.blueGrey[100],
      drawer: MainDrawer(),
      appBar: AppBar(
        // backgroundColor: Colors.blue[600],
        title: Center(
          child: Text(
            'DocLense',
            style: TextStyle(
              // color: Colors.white,
                fontSize: 24),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {},
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {

              });
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () async {},
          ),
        ],
      ),
      body: FutureBuilder(
        future: setSharedPreferences(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data.last);
            if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                    "No PDFs Scanned Yet !! "
                ),
              );
            }
            return GridView.builder(
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),

              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    OpenFile.open(snapshot.data[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 40,
                      // color: Colors.white,
                      child: Center(
                        child: Text(
                            snapshot.data[index]
                                .split('/')
                                .last
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        // backgroundColor: Colors.blue[600],
        onPressed: () {},
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              iconSize: 30,
              // color: Colors.blue[600],
              icon: Icon(
                Icons.camera_alt,
                // color: Colors.white,
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
              // color: Colors.blue[600],
              icon: Icon(
                Icons.image,
                // color: Colors.white,
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