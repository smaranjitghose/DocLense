import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Imageview.dart';
import 'Providers/ImageList.dart';
import 'MainDrawer.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'About.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:pdf_render/pdf_render_widgets2.dart';
import 'package:intl/intl.dart';

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
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Center(
          child: Text(
            'DocLense',
            style: TextStyle(
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
      body: ListView.builder(itemBuilder: (context,index) {
        return Container(
            width: double.infinity,
            child:ListTile(
          title: Text("Hello"),
          subtitle: Column(
                    children: <Widget>[
                      Text(DateFormat("dd/MM/yyyy").format(File.fromRawPath(Hive.box("pdfs").getAt(0)[index]).lastModifiedSync())),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: (){

                          },
                          ),
                          IconButton(
                            icon: Icon(Icons.picture_as_pdf),
                            onPressed: (){

                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: (){

                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: (){

                            },
                          ),
                        ],
                      ),
                      ],
        ),
          leading: PdfDocumentLoader(
              assetName: Hive.box("pdfs").getAt(0)[index]
                  .split("/")
                  .last,
              filePath: Hive.box("pdfs").getAt(0)[index],
              pageNumber: 1,
              pageBuilder: (context, textureBuilder, pageSize) =>
                  textureBuilder()
          ),
        ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              iconSize: 30,
              icon: Icon(
                Icons.camera_alt,
              ),
              onPressed: () {
                getImage(ImageSource.camera);
              },
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 2,
              height: 15,
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              iconSize: 30,
              icon: Icon(
                Icons.image,
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