import 'dart:async';
import 'dart:io';

import 'package:doclense/services/search_service.dart';
import 'package:doclense/starred_documents.dart';
// import 'package:path/path.dart' as path;
import 'package:doclense/settings.dart';
import 'package:flutter/cupertino.dart';
// import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter/material.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:quick_actions/quick_actions.dart';

import 'about.dart';
import 'image_view.dart';
import 'main_drawer.dart';
import 'providers/image_list.dart';

enum IconOptions { share }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future setSharedPreferences() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (sharedPreferences.getStringList('savedFiles') == null) {
      sharedPreferences.setStringList('savedFiles', []);
      return [];
    } else {
      return sharedPreferences.getStringList('savedFiles');
    }
  }

  ImageList images = ImageList();
  QuickActions quickActions = QuickActions();

  void _navigate(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
  // File imageFile;

  final picker = ImagePicker();

  Future<void> getImage(ImageSource imageSource) async {
    final PickedFile imageFile = await picker.getImage(source: imageSource);
    if (imageFile == null) return;
    final File tmpFile = File(imageFile.path);
    // final appDir = await syspaths.getApplicationDocumentsDirectory();
    // final fileName = path.basename(imageFile.path);
    // final localFile = await tmpFile.copy('${appDir.path}/$fileName');

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
          MaterialPageRoute(builder: (_) {
            return Scaffold(
              body: Center(
                child: Text('No Page defined for $shortcutType'),
              ),
            );
          });
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'about', localizedTitle: 'About DocLense', icon: 'info'),
      const ShortcutItem(
          type: 'starredDocument',
          localizedTitle: 'Starred Documents',
          icon: 'starred'),
      const ShortcutItem(
          type: 'setting', localizedTitle: 'Settings', icon: 'setting'),
    ]);
  }

  bool isStarred(Box<dynamic> pdfsBox, int index) {
    final File file = File(pdfsBox.getAt(0)[index] as String);
    final path = file.path;

    final List<dynamic> files = Hive.box('starred').getAt(0) as List<dynamic>;
    if (files.contains(path)) {
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
        title: const Center(
          child: Text(
            'DocLense',
            style: TextStyle(fontSize: 24),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchService());
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {},
          ),
        ],
      ),
      body: WatchBoxBuilder(
        box: Hive.box('pdfs'),
        builder: (context, pdfsBox) {
          if (pdfsBox.getAt(0).length == 0) {
            return const Center(
              child: Text("No PDFs Scanned Yet !! "),
            );
          }
          return ListView.builder(
            itemCount: pdfsBox.getAt(0).length as int,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  OpenFile.open(pdfsBox.getAt(0)[index] as String);
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    color: Colors.grey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: const [
                            /// TODO: Add logic for displaying first image of PDF
                            Icon(Icons.photo)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (pdfsBox.getAt(0)[index] as String)
                                    .split('/')
                                    .last,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: Text(

                                  /// TODO: Add logic for displaying date of creation of PDF
                                  '10/03/2021'),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.share),
                                    onPressed: () async {
                                      final File file = File(await pdfsBox
                                          .getAt(0)[index] as String);

                                      final path = file.path;

                                      print(path);

                                      Share.shareFiles([path],
                                          text: 'Your PDF!');
                                    }),
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext ctx) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  Colors.blueGrey[800],
                                              title: const Text(
                                                "The PDF will be permanently deleted.\nDo you want to proceed?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      child: const Text(
                                                        "Yes",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onTap: () {
                                                        final File sourceFile =
                                                            File(pdfsBox.getAt(
                                                                    0)[index]
                                                                as String);
                                                        print(sourceFile.path);
                                                        sourceFile.delete();
                                                        final List<dynamic>
                                                            starredFiles =
                                                            Hive.box('starred')
                                                                    .getAt(0)
                                                                as List<
                                                                    dynamic>;
                                                        setState(() {
                                                          pdfsBox
                                                              .getAt(0)
                                                              .removeAt(index);
                                                          final List<dynamic>
                                                              editedList =
                                                              pdfsBox.getAt(0)
                                                                  as List<
                                                                      dynamic>;
                                                          pdfsBox.putAt(
                                                              0, editedList);
                                                          if (starredFiles
                                                              .contains(
                                                                  sourceFile
                                                                      .path)) {
                                                            print('yes');
                                                            for (int i = 0;
                                                                i <
                                                                    starredFiles
                                                                        .length;
                                                                i++) {
                                                              if (Hive.box('starred')
                                                                          .getAt(
                                                                              0)[
                                                                      i] ==
                                                                  sourceFile
                                                                      .path) {
                                                                print('yes');
                                                                Hive.box(
                                                                        'starred')
                                                                    .getAt(0)
                                                                    .removeAt(
                                                                        i);
                                                                final List<
                                                                        dynamic>
                                                                    editedList =
                                                                    Hive.box(
                                                                            'starred')
                                                                        .getAt(
                                                                            0) as List<
                                                                        dynamic>;
                                                                Hive.box(
                                                                        'starred')
                                                                    .putAt(0,
                                                                        editedList);
                                                                break;
                                                              }
                                                            }
                                                          }
                                                        });
                                                        Navigator.of(ctx).pop();
                                                      },
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: const Text(
                                                        "No",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    }),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    TextEditingController pdfName;
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext dialogContext) {
                                          pdfName = TextEditingController();
                                          return AlertDialog(
                                            title: const Text(
                                              "Rename",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            content: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextField(
                                                      controller: pdfName,
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        final List<dynamic>
                                                            starred =
                                                            Hive.box('starred')
                                                                    .getAt(0)
                                                                as List<
                                                                    dynamic>;
                                                        print(
                                                            "PDFS : ${Hive.box('pdfs').getAt(0)}");
                                                        final File sourceFile =
                                                            File(pdfsBox.getAt(
                                                                    0)[index]
                                                                as String);
                                                        setState(() {
                                                          if (starred.contains(
                                                              pdfsBox.getAt(
                                                                  0)[index])) {
                                                            for (int i = 0;
                                                                i <
                                                                    starred
                                                                        .length;
                                                                i++) {
                                                              if (Hive.box('starred')
                                                                          .getAt(
                                                                              0)[
                                                                      i] ==
                                                                  sourceFile
                                                                      .path) {
                                                                print('yes');
                                                                final List<
                                                                        String>
                                                                    path =
                                                                    (Hive.box('starred').getAt(0)[i]
                                                                            as String)
                                                                        .split(
                                                                            '/');
                                                                path.last =
                                                                    "${pdfName.text}.pdf";
                                                                Hive.box('starred')
                                                                        .getAt(
                                                                            0)[i] =
                                                                    path.join(
                                                                        '/');
                                                                final List<
                                                                        dynamic>
                                                                    editedList =
                                                                    Hive.box(
                                                                            'starred')
                                                                        .getAt(
                                                                            0) as List<
                                                                        dynamic>;
                                                                Hive.box(
                                                                        'starred')
                                                                    .putAt(0,
                                                                        editedList);
                                                                break;
                                                              }
                                                            }
                                                          }
                                                          final List<String>
                                                              path = pdfsBox
                                                                      .getAt(0)[
                                                                          index]
                                                                      .split(
                                                                          '/')
                                                                  as List<
                                                                      String>;
                                                          path.last =
                                                              "${pdfName.text}.pdf";
                                                          pdfsBox.getAt(
                                                                  0)[index] =
                                                              path.join('/');
                                                        });
                                                        sourceFile.renameSync(
                                                            pdfsBox.getAt(
                                                                    0)[index]
                                                                as String);
                                                        print(
                                                            "PDFS : ${Hive.box('pdfs').getAt(0)}");
                                                        final List<dynamic>
                                                            editedList =
                                                            pdfsBox.getAt(0)
                                                                as List<
                                                                    dynamic>;
                                                        pdfsBox.putAt(
                                                            0, editedList);
                                                        Navigator.pop(
                                                            dialogContext);
                                                      },
                                                      child: const Text("Save"),
                                                    ),
                                                  ]),
                                            ),
                                          );
                                        });
                                  },
                                ),
                                IconButton(
                                    icon: const Icon(
                                      Icons.drive_file_move,
                                    ),
                                    onPressed: () async {
                                      final String oldPath =
                                          pdfsBox.getAt(0)[index] as String;
                                      String newPath;
                                      final String path = await ExtStorage
                                          .getExternalStorageDirectory();
                                      final Directory directory =
                                          Directory(path);
                                      Navigator.of(context)
                                          .push<FolderPickerPage>(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                        return FolderPickerPage(
                                            rootDirectory: directory,
                                            action: (BuildContext context,
                                                Directory folder) async {
                                              newPath =
                                                  '${folder.path}/${(pdfsBox.getAt(0)[index] as String).split('/').last}';
                                              print(newPath);
                                              if (newPath != null) {
                                                print("Newpath: $newPath");
                                                final File sourceFile =
                                                    File(oldPath);
                                                await sourceFile.copy(newPath);
                                                await sourceFile.delete();
                                                setState(() {
                                                  pdfsBox.getAt(0)[index] =
                                                      newPath;
                                                });
                                              }
                                              Navigator.of(context).pop();
                                            });
                                      }));
                                    }),
                                IconButton(
                                  icon: Icon(
                                    isStarred(pdfsBox, index)
                                        ? Icons.star
                                        : Icons.star_border,
                                  ),
                                  onPressed: () async {
                                    print(isStarred(pdfsBox, index));
                                    final File file = File(await pdfsBox
                                        .getAt(0)[index] as String);
                                    final path = file.path;

                                    final List<dynamic> files =
                                        Hive.box('starred').getAt(0)
                                            as List<dynamic>;
                                    if (files.contains(path)) {
                                      for (int i = 0; i < files.length; i++) {
                                        if (Hive.box('starred').getAt(0)[i] ==
                                            path) {
                                          Hive.box('starred')
                                              .getAt(0)
                                              .removeAt(i);
                                          break;
                                        }
                                      }
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Removed from starred documents')));
                                      print('Already fav');
                                    } else {
                                      files.add(path);
                                      Hive.box('starred').putAt(0, files);
                                      print(
                                          "STARRED : ${Hive.box('starred').getAt(0)}");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Added to starred documents!')));
                                    }
                                    setState(() {});
                                  },
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
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
              icon: const Icon(
                Icons.camera_alt,
              ),
              onPressed: () {
                getImage(ImageSource.camera);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            const SizedBox(
              width: 2,
              height: 15,
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              iconSize: 30,
              icon: const Icon(
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
