// ignore_for_file: avoid_dynamic_calls, use_build_context_synchronously

import "dart:async";
import "dart:io";

import "package:doclense/configs/app_dimensions.dart";
import "package:doclense/configs/app_typography.dart";
import "package:doclense/configs/space.dart";
import "package:doclense/configs/styles.dart";
import "package:doclense/constants/appstrings.dart";
import "package:doclense/constants/route_constants.dart";
import "package:doclense/env.dart";
import "package:doclense/providers/image_list.dart";
import "package:doclense/providers/theme_provider.dart";
import "package:doclense/ui_components/double_back_to_close_snackbar.dart";
import "package:doclense/ui_components/main_drawer.dart";
import "package:doclense/utils/image_converter.dart" as image_converter;
import "package:double_back_to_close_app/double_back_to_close_app.dart";
import "package:easy_folder_picker/FolderPicker.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:gallery_saver/gallery_saver.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:image_picker/image_picker.dart";
import "package:open_file/open_file.dart";
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";
import "package:quick_actions/quick_actions.dart";
import "package:share_plus/share_plus.dart";

enum IconOptions { share }

enum DeviceType { phone, tablet }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool tablet = false;

  bool getDeviceType() {
    final Size data = MediaQuery.sizeOf(context);
    if (data.shortestSide < 550) {
      return false;
    } else {
      return true;
    }
  }

  ImageList images = ImageList();
  QuickActions quickActions = const QuickActions();

  void _navigate(String routeName) {
    unawaited(Navigator.of(context).pushNamed(routeName));
  }

  final ImagePicker picker = ImagePicker();

  Future<void> getImage(ImageSource imageSource) async {
    final XFile? imageFile = await picker.pickImage(source: imageSource);
    if (imageFile == null) {
      return;
    }
    final File tmpFile = File(imageFile.path);

    if (imageSource == ImageSource.camera) {
      await GallerySaver.saveImage(tmpFile.path)
          .then((bool? value) => debugPrint("Image Saved"));
    }

    await Navigator.of(context).pushNamed(
      RouteConstants.imageView,
      arguments: <String, Object>{
        "imageFile": tmpFile,
        "imageList": images,
      },
    );
  }

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) async {
      tablet = getDeviceType();
      await quickActions.initialize((String shortcutType) {
        switch (shortcutType) {
          case "about":
            return _navigate(RouteConstants.aboutAppScreen);
          case "starredDocument":
            return _navigate(RouteConstants.starredDocumentsScreen);
          case "setting":
            return _navigate(RouteConstants.settingsScreen);

          default:
            MaterialPageRoute<dynamic>(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text("No Page defined for $shortcutType"),
                ),
              ),
            );
        }
      });
      await quickActions.setShortcutItems(<ShortcutItem>[
        const ShortcutItem(
          type: "about",
          localizedTitle: "About DocLense",
          icon: "info",
        ),
        const ShortcutItem(
          type: "starredDocument",
          localizedTitle: "Starred Documents",
          icon: "starred",
        ),
        const ShortcutItem(
          type: "setting",
          localizedTitle: "Settings",
          icon: "setting",
        ),
      ]);

      setState(() {
        _isLoading = false;
      });
    });
  }

  bool isStarred(Box<dynamic> pdfsBox, int index) {
    final File file = File(pdfsBox.getAt(0)[index][0] as String);
    final String path = file.path;

    final List<dynamic> files = Hive.box("starred").getAt(0) as List<dynamic>;
    final List<dynamic> starredDocs = <dynamic>[];
    for (int i = 0; i < files.length; i++) {
      starredDocs.add(files[i][0]);
    }
    if (starredDocs.contains(path)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DarkThemeProvider themeChange =
        Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: Center(
          child: Text(
            Env.appname,
            style: AppText.h4b,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              size: AppDimensions.font(13),
            ),
            onPressed: () {
              // showSearch(context: context, delegate: SearchService());
            },
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: AppDimensions.font(13),
            ),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      // ignore: deprecated_member_use
      body: _isLoading
          ? const SpinKitRotatingCircle(
              color: Colors.blue,
            )
          : DoubleBackToCloseApp(
              snackBar: doubleBackToCloseSnackBar(),
              child: ValueListenableBuilder<Box<dynamic>>(
                valueListenable: Hive.box("pdfs").listenable(),
                builder: (
                  BuildContext context,
                  Box<dynamic> pdfsBox,
                  Widget? widget,
                ) {
                  if (pdfsBox.getAt(0).length == 0) {
                    return Center(
                      child: Text(
                        S.noPDFyet,
                        style: AppText.b2,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: pdfsBox.getAt(0).length as int,
                    itemBuilder: (BuildContext context, int index) {
                      final Image previewImage =
                          image_converter.base64StringToImage(
                        pdfsBox.getAt(0)[index][2] as String,
                      );

                      return GestureDetector(
                        onTap: () async {
                          await OpenFile.open(
                            pdfsBox.getAt(0)[index][0] as String,
                          );
                        },
                        child: Container(
                          padding: Space.all(),
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? AppDimensions.height(40)
                              : AppDimensions.height(21),
                          child: Card(
                            elevation: 5,
                            color: themeChange.darkTheme
                                ? Colors.grey[700]
                                : Colors.white,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: AppDimensions.width(25),
                                  padding: Space.all(),
                                  child: previewImage,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Padding(
                                        padding: Space.all(0.4),
                                        child: Text(
                                          (pdfsBox.getAt(0)[index][0] as String)
                                              .split("/")
                                              .last,
                                          style: AppText.b1,
                                        ),
                                      ),
                                      Text(
                                        "${pdfsBox.getAt(0)[index][1]}",
                                        style: AppText.l1,
                                      ),
                                      Space.y!,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              Icons.share,
                                              color: themeChange.darkTheme
                                                  ? Colors.white70
                                                  : Colors.grey,
                                              size: AppDimensions.font(8),
                                            ),
                                            onPressed: () async {
                                              final File file = File(
                                                await pdfsBox.getAt(
                                                  0,
                                                )[index][0] as String,
                                              );

                                              final String path = file.path;

                                              debugPrint(path);

                                              await Share.shareXFiles(
                                                <XFile>[XFile(path)],
                                                text: S.yourPDF,
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: themeChange.darkTheme
                                                  ? Colors.white70
                                                  : Colors.grey,
                                              size: AppDimensions.font(8),
                                            ),
                                            onPressed: () async {
                                              await _onDelete(
                                                context,
                                                pdfsBox,
                                                index,
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: themeChange.darkTheme
                                                  ? Colors.white70
                                                  : Colors.grey,
                                              size: AppDimensions.font(8),
                                            ),
                                            onPressed: () async {
                                              await _onRename(
                                                context,
                                                pdfsBox,
                                                index,
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.drive_file_move,
                                              color: themeChange.darkTheme
                                                  ? Colors.white70
                                                  : Colors.grey,
                                              size: AppDimensions.font(8),
                                            ),
                                            onPressed: () async {
                                              await _onFileMove(
                                                pdfsBox,
                                                index,
                                                context,
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              isStarred(pdfsBox, index)
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: themeChange.darkTheme
                                                  ? Colors.white70
                                                  : Colors.grey,
                                              size: AppDimensions.font(8),
                                            ),
                                            onPressed: () async {
                                              await _onStarred(
                                                pdfsBox,
                                                index,
                                                context,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
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
              onPressed: () async {
                await getImage(ImageSource.camera);
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.image,
              ),
              onPressed: () async {
                await getImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onStarred(
    Box<dynamic> pdfsBox,
    int index,
    BuildContext context,
  ) async {
    debugPrint(isStarred(pdfsBox, index).toString());
    final File file = File(await pdfsBox.getAt(0)[index][0] as String);
    final String path = file.path;
    final dynamic date = pdfsBox.getAt(0)[index][1];
    final dynamic imagePreview = pdfsBox.getAt(0)[index][2];

    final List<dynamic> files = Hive.box("starred").getAt(0) as List<dynamic>;

    final List<dynamic> starredDocs = <dynamic>[];

    for (int i = 0; i < files.length; i++) {
      starredDocs.add(files[i][0]);
    }
    if (starredDocs.contains(path)) {
      for (int i = 0; i < starredDocs.length; i++) {
        if (Hive.box("starred").getAt(0)[i][0] == path) {
          Hive.box("starred").getAt(0).removeAt(i);
          break;
        }
      }
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.removeStar,
            style: AppText.b1,
          ),
        ),
      );
      debugPrint("Already fav");
    } else {
      files.add(<dynamic>[path, date, imagePreview]);
      await Hive.box("starred").putAt(0, files);
      debugPrint("STARRED : ${Hive.box('starred').getAt(0)}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.addStar,
            style: AppText.b1,
          ),
        ),
      );
    }
    setState(() {});
  }

  Future<void> _onFileMove(
    Box<dynamic> pdfsBox,
    int index,
    BuildContext context,
  ) async {
    final PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final String oldPath = pdfsBox.getAt(0)[index][0] as String;
    String newPath;
    final Directory? extDir = await getExternalStorageDirectory();
    final String path = extDir!.path;
    final Directory directory = Directory(path);

    final Directory? folderDir = await FolderPicker.pick(
      allowFolderCreation: true,
      context: context,
      rootDirectory: directory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );

    if (folderDir != null) {
      newPath =
          '${folderDir.path}/${(pdfsBox.getAt(0)[index][0] as String).split('/').last}';
      debugPrint(newPath);
      final List<dynamic> starred =
          Hive.box("starred").getAt(0) as List<dynamic>;
      final List<dynamic> finalStarred = <dynamic>[];
      for (int i = 0; i < starred.length; i++) {
        finalStarred.add(starred[i][0]);
      }
      final File sourceFile = File(oldPath);
      if (finalStarred.contains(pdfsBox.getAt(0)[index][0])) {
        debugPrint("yes");
        for (int i = 0; i < finalStarred.length; i++) {
          if (Hive.box("starred").getAt(0)[i][0] == sourceFile.path) {
            debugPrint("yes");
            await sourceFile.copy(newPath);
            await sourceFile.delete();

            Hive.box("starred").getAt(0)[i][0] = newPath;
            pdfsBox.getAt(0)[index][0] = newPath;
            final List<dynamic> editedList =
                Hive.box("starred").getAt(0) as List<dynamic>;
            await Hive.box("starred").putAt(0, editedList);
            final List<dynamic> pdfEditedList =
                pdfsBox.getAt(0) as List<dynamic>;
            await pdfsBox.putAt(0, pdfEditedList);
            break;
          }
        }
      } else {
        debugPrint("Newpath: $newPath");
        await sourceFile.copy(newPath);
        await sourceFile.delete();
        setState(() {
          pdfsBox.getAt(0)[index][0] = newPath;
        });
      }
    }
  }

  Future<void> _onRename(
    BuildContext context,
    Box<dynamic> pdfsBox,
    int index,
  ) async {
    TextEditingController pdfName;

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        pdfName = TextEditingController();
        return AlertDialog(
          title: Text(
            S.rename,
            textAlign: TextAlign.center,
            style: AppText.b1b,
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: pdfName,
                decoration: InputDecoration(
                  labelText: S.rename,
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  focusedBorder: AppStyles().textFieldBorder,
                  enabledBorder: AppStyles().textFieldBorder,
                ),
              ),
              Space.y!,
              ElevatedButton(
                onPressed: () async {
                  final List<dynamic> starred =
                      Hive.box("starred").getAt(0) as List<dynamic>;
                  final List<dynamic> finalStarred = <dynamic>[];
                  for (int i = 0; i < starred.length; i++) {
                    finalStarred.add(starred[i][0]);
                  }
                  debugPrint("PDFS : ${Hive.box('pdfs').getAt(0)}");
                  final File sourceFile =
                      File(pdfsBox.getAt(0)[index][0] as String);
                  setState(() {
                    if (finalStarred.contains(pdfsBox.getAt(0)[index][0])) {
                      debugPrint("yes");
                      for (int i = 0; i < finalStarred.length; i++) {
                        if (Hive.box("starred").getAt(0)[i][0] ==
                            sourceFile.path) {
                          debugPrint("yes");
                          final List<String> path =
                              (Hive.box("starred").getAt(0)[i][0] as String)
                                  .split("/")
                                ..last = "${pdfName.text}.pdf";
                          Hive.box("starred").getAt(0)[i][0] = path.join("/");
                          final List<dynamic> editedList =
                              Hive.box("starred").getAt(0) as List<dynamic>;
                          Hive.box("starred").putAt(0, editedList);
                          break;
                        }
                      }
                    }
                    final List<String> path =
                        (pdfsBox.getAt(0)[index][0].split("/") as List<String>)
                          ..last = "${pdfName.text}.pdf";
                    pdfsBox.getAt(0)[index][0] = path.join("/");
                  });
                  sourceFile.renameSync(pdfsBox.getAt(0)[index][0] as String);
                  debugPrint("PDFS : ${Hive.box('pdfs').getAt(0)}");
                  final List<dynamic> editedList =
                      pdfsBox.getAt(0) as List<dynamic>;
                  await pdfsBox.putAt(0, editedList);
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  S.save,
                  style: AppText.b1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onDelete(
    BuildContext context,
    Box<dynamic> pdfsBox,
    int index,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: Colors.blueGrey[800],
        title: Text(
          S.deleteConfirmText,
          textAlign: TextAlign.center,
          style: AppText.b1!.cl(
            Colors.white,
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  final File sourceFile =
                      File(pdfsBox.getAt(0)[index][0] as String);
                  debugPrint(sourceFile.path);
                  sourceFile.delete();
                  final List<dynamic> starredFiles =
                      Hive.box("starred").getAt(0) as List<dynamic>;
                  setState(() {
                    pdfsBox.getAt(0).removeAt(index);
                    final List<dynamic> editedList =
                        pdfsBox.getAt(0) as List<dynamic>;
                    pdfsBox.putAt(0, editedList);
                    final List<dynamic> finalStarredFiles = <dynamic>[];
                    for (int i = 0; i < starredFiles.length; i++) {
                      finalStarredFiles.add(starredFiles[i][0]);
                    }
                    if (finalStarredFiles.contains(sourceFile.path)) {
                      debugPrint("yes");
                      for (int i = 0; i < finalStarredFiles.length; i++) {
                        if (Hive.box("starred").getAt(0)[i][0] ==
                            sourceFile.path) {
                          debugPrint("yes");
                          Hive.box("starred").getAt(0).removeAt(i);
                          final List<dynamic> editedList =
                              Hive.box("starred").getAt(0) as List<dynamic>;
                          Hive.box("starred").putAt(0, editedList);
                          break;
                        }
                      }
                    }
                  });
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  S.yes,
                  textAlign: TextAlign.center,
                  style: AppText.b1!.cl(
                    Colors.white,
                  ),
                ),
              ),
              Space.y!,
              GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  S.no,
                  textAlign: TextAlign.center,
                  style: AppText.b1!.cl(
                    Colors.white,
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
