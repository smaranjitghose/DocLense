import 'dart:async';
import 'package:doclense/Services/SearchService.dart';
import 'package:doclense/StarredDocuments.dart';
import 'package:doclense/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Imageview.dart';
import 'Providers/ImageList.dart';
import 'MainDrawer.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:ext_storage/ext_storage.dart';
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
        case 'starredDocument':
          return _navigate(Starred());
        case 'setting':
          return _navigate(SettingsScreen());

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
      ShortcutItem(type: 'starredDocument', localizedTitle: 'Starred Documents', icon: 'starred'),
      ShortcutItem(type: 'setting', localizedTitle: 'Settings', icon: 'setting'),
    ]);
  }

  bool isStarred(pdfsBox, index) {
    File file = File(
        pdfsBox.getAt(0)[index]
    );
    final path = file.path;

    List<dynamic> files = Hive.box('starred')
        .getAt(0);
    if(files.contains(path)){
      return true;
    } else {
      return false;
    }
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
            onPressed: () {
              showSearch(context: context, delegate: SearchService());
            },
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
      body: WatchBoxBuilder(
        box: Hive.box('pdfs'),
        builder: (context, pdfsBox) {
          if (pdfsBox
              .getAt(0)
              .length == 0) {
            return Center(
              child: Text(
                  "No PDFs Scanned Yet !! "
              ),
            );
          }
          return ListView.builder(
            itemCount: pdfsBox
                .getAt(0)
                .length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    OpenFile.open(pdfsBox.getAt(0)[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      color: Colors.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                  pdfsBox.getAt(0)[index]
                                      .split('/')
                                      .last
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(
                                      Icons.share
                                  ),
                                  onPressed: () async {
                                    File file = await File(
                                        pdfsBox.getAt(0)[index]
                                    );

                                    final path = file.path;

                                    print(path);

                                    Share.shareFiles(
                                        ['$path'], text: 'Your PDF!');
                                  }
                              ),
                              IconButton(
                                  icon: Icon(
                                      Icons.delete
                                  ),
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return AlertDialog(
                                            backgroundColor: Colors
                                                .blueGrey[800],
                                            title: Text(
                                              "The PDF will be permanently deleted.\nDo you want to proceed?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: Text(
                                                      "Yes",
                                                      textAlign: TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onTap: () {
                                                      File sourceFile = File(
                                                          pdfsBox.getAt(
                                                              0)[index]);
                                                      print(sourceFile.path);
                                                      sourceFile.delete();
                                                      List<
                                                          dynamic> starredFiles = Hive
                                                          .box('starred').getAt(
                                                          0);
                                                      setState(() {
                                                        pdfsBox.getAt(0)
                                                            .removeAt(index);
                                                        if (starredFiles
                                                            .contains(
                                                            sourceFile.path)) {
                                                          print('yes');
                                                          for (int i = 0; i <
                                                              starredFiles
                                                                  .length; i++) {
                                                            if (Hive.box(
                                                                'starred')
                                                                .getAt(0)[i] ==
                                                                sourceFile
                                                                    .path) {
                                                              print('yes');
                                                              Hive.box(
                                                                  'starred')
                                                                  .getAt(0)
                                                                  .removeAt(i);
                                                              break;
                                                            }
                                                          }
                                                        }
                                                      });
                                                      Navigator.of(ctx).pop();
                                                    },
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(10),
                                                  ),
                                                  GestureDetector(
                                                    child: Text(
                                                      "No",
                                                      textAlign: TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onTap: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    );
                                  }
                              ),
                              IconButton(
                                icon: Icon(
                                    Icons.edit
                                ),
                                onPressed: () {
                                  BuildContext dialogContext;
                                  TextEditingController pdfName;
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        dialogContext = context;
                                        pdfName = TextEditingController();
                                        return Container(
                                          /*padding: EdgeInsets.only(
                                            bottom:250,
                                          ),*/
                                          padding: MediaQuery
                                              .of(context)
                                              .padding,

                                          child: Dialog(
                                            child: Container
                                              (
                                              padding: EdgeInsets.all(20),
                                              alignment: Alignment.center,
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Rename",
                                                  ),
                                                  TextField(
                                                    controller: pdfName,
                                                  ),
                                                  RaisedButton(
                                                    color: Colors.blue,
                                                    textColor: Colors.white,
                                                    child: Text("Save"),
                                                    onPressed: () async {
                                                      File sourceFile = File(
                                                          pdfsBox.getAt(
                                                              0)[index]);
                                                      setState(() {
                                                        List<
                                                            String> path = pdfsBox
                                                            .getAt(0)[index]
                                                            .split(
                                                            '/');
                                                        path.last =
                                                            pdfName.text +
                                                                ".pdf";
                                                        pdfsBox.getAt(
                                                            0)[index] =
                                                            path.join('/');
                                                      });
                                                      await sourceFile
                                                          .renameSync(pdfsBox
                                                          .getAt(0)[index]);
                                                      Navigator.pop(
                                                          dialogContext);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.drive_file_move,
                                  ),
                                  onPressed: () async {
                                    String oldPath = pdfsBox.getAt(0)[index];
                                    String newPath = null;
                                    final String path = await ExtStorage
                                        .getExternalStorageDirectory();
                                    Directory directory = Directory(path);
                                    Navigator.of(context)
                                        .push<FolderPickerPage>(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return FolderPickerPage(
                                                  rootDirectory: directory,
                                                  action: (BuildContext context,
                                                      Directory folder) async {
                                                    newPath =
                                                        folder.path + '/' +
                                                            pdfsBox.getAt(
                                                                0)[index]
                                                                .split('/')
                                                                .last;
                                                    print(newPath);
                                                    if (newPath != null) {
                                                      print("Newpath: " +
                                                          newPath);
                                                      File sourceFile = File(
                                                          oldPath);
                                                      await sourceFile.copy(
                                                          newPath);
                                                      await sourceFile.delete();
                                                      setState(() {
                                                        pdfsBox.getAt(
                                                            0)[index] = newPath;
                                                      });
                                                    }
                                                    Navigator.of(context).pop();
                                                  });
                                            }));
                                  }
                              ),

                              IconButton(
                                icon: Icon(
                                  isStarred(pdfsBox, index) ? Icons.star : Icons
                                      .star_border,
                                ),
                                onPressed: () async {
                                  print(isStarred(pdfsBox, index));
                                  File file = await File(
                                      pdfsBox.getAt(0)[index]
                                  );
                                  final path = file.path;

                                  List<dynamic> files = Hive.box('starred')
                                      .getAt(0);
                                  if (files.contains(path)) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            'Already a starred document')));
                                    print('Already fav');
                                  } else {
                                    files.add('$path');
                                    Hive.box('starred').putAt(0, files);
                                    print(
                                        "STARRED : ${Hive.box('starred').getAt(
                                            0)}");
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            'Added to starred documents!')));
                                  }
                                  setState(() {

                                  });
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
              );
            },
          );
        },
      ),
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
