import "dart:io";

import "package:doclense/configs/app_dimensions.dart";
import "package:doclense/configs/app_typography.dart";
import "package:doclense/configs/space.dart";
import "package:doclense/constants/appstrings.dart";
import "package:doclense/constants/route_constants.dart";
import "package:doclense/providers/image_list.dart";
import "package:doclense/providers/theme_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:image/image.dart" as image_lib;
import "package:image_cropper/image_cropper.dart";
import "package:path/path.dart";
import "package:photofilters/filters/preset_filters.dart";
import "package:provider/provider.dart";

class Imageview extends StatefulWidget {
  const Imageview(
    this.file,
    this.list, {
    super.key,
  });
  final File file;
  final ImageList list;

  @override
  ImageviewState createState() => ImageviewState();
}

class ImageviewState extends State<Imageview> {
  CroppedFile? cropped;
  bool _isLoading = true;
  List<File> files = <File>[];
  int index = 0;

  @override
  void initState() {
    super.initState();
    files.add(widget.file);
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> cropimage(File file, Color appBarColor, Color bgColor) async {
    // ignore: avoid_slow_async_io
    final bool isExits = await file.exists();
    if (isExits) {
      cropped = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 80,
        uiSettings: <PlatformUiSettings>[
          AndroidUiSettings(
            statusBarColor: appBarColor,
            toolbarColor: appBarColor,
            toolbarWidgetColor: Colors.white,
            backgroundColor: bgColor,
          ),
        ],
      );
      setState(() {
        // cropped == null ? file = files : file = cropped;
        // files.add(file);

        if (cropped != null) {
          index++;
          files.add(File(cropped!.path));
        } else {
          // files.add(file);
        }
      });
    }
  }

  // Widget popupMenuButton() {
  //   return PopupMenuButton<IconOptions>(
  //     icon: const Icon(Icons.more_vert),
  //     itemBuilder: (BuildContext context) => <PopupMenuEntry<IconOptions>>[
  //       PopupMenuItem<IconOptions>(
  //         value: IconOptions.share,
  //         child: Row(children: const [
  //           Icon(
  //             Icons.share,
  //             size: 28.0,
  //             // color: Colors.blue,
  //           ),
  //           SizedBox(
  //             width: 23.0,
  //           ),
  //           Text(
  //             'Share',
  //             style: TextStyle(fontSize: 20.0),
  //           )
  //         ]),
  //       )
  //     ],
  //     onSelected: (IconOptions value) {
  //       setState(() {});
  //     },
  //   );
  // }

  Future<void> getFilterImage(BuildContext context, Color appBarColor) async {
    File filterfile;
    if (files.isNotEmpty) {
      filterfile = files[index];
    } else {
      filterfile = widget.file;
    }

    //   imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    final String fileName = basename(filterfile.path);
    image_lib.Image? image =
        image_lib.decodeImage(filterfile.readAsBytesSync());
    image = image_lib.copyResize(image!, width: 600);
    final Map<String, dynamic> imagefile =
        (await Navigator.of(context).pushNamed(
      RouteConstants.photoFilterSelector,
      arguments: <String, Object>{
        "title": const Text("Apply Filter"),
        "image": image,
        "appBarColor": appBarColor,
        "filters": presetFiltersList,
        "fileName": fileName,
        "loader": const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.teal,
            strokeWidth: 2,
          ),
        ),
        "fit": BoxFit.contain,
      },
    ))! as Map<String, dynamic>;
    if (imagefile.containsKey("image_filtered")) {
      setState(() {
        // widget.file = imagefile['image_filtered'] as File;
        files.add(imagefile["image_filtered"] as File);

        index++;
      });
      debugPrint(filterfile.path);
    }
  }

  Future<void> _showChoiceDialogHome(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          title: Text(
            S.deleteWarning,
            textAlign: TextAlign.center,
            style: AppText.b1!.cl(Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    widget.list.imagelist = <File>[];
                    widget.list.imagepath = <String>[];

                    Navigator.of(context)
                        .popUntil((Route<dynamic> route) => route.isFirst);
                  },
                  child: Text(
                    S.yes,
                    textAlign: TextAlign.center,
                    style: AppText.b1!.cl(Colors.white),
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
                    style: AppText.b1!.cl(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final DarkThemeProvider themeChange =
        Provider.of<DarkThemeProvider>(context);

    final Color appBarColor =
        themeChange.darkTheme ? Colors.black : Colors.blue[600]!;
    final Color bgColor = themeChange.darkTheme ? Colors.black54 : Colors.white;

    return Scaffold(
      body: _isLoading
          ? const SpinKitRotatingCircle(
              color: Colors.blue,
            )
          : SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: Space.all(0.75),
                      child: Image.file(
                        files[index],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // padding: Space.all(),
                      color: themeChange.darkTheme
                          ? Colors.black87
                          : Colors.blue[600],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextButton(
                            onPressed: () async {
                              await _showChoiceDialogHome(context);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: AppDimensions.font(
                                    10,
                                  ),
                                ),
                                Text(
                                  S.back,
                                  style: AppText.l1!.cl(Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Opacity(
                            opacity: index == 0 ? 0.5 : 1,
                            child: TextButton(
                              onPressed: () {
                                //Navigator.of(context).pop();
                                if (index == 0) {
                                  debugPrint("no undo possible");
                                  // ignore: lines_longer_than_80_chars
                                  // implement disabled undo if no undo is possible
                                } else {
                                  setState(() {
                                    index--;
                                    files.removeLast();
                                    debugPrint(
                                      widget.list.imagelist.length.toString(),
                                    );
                                    // widget.list.imagepath.removeLast();
                                  });
                                }
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.undo,
                                    color: Colors.white,
                                    size: AppDimensions.font(
                                      10,
                                    ),
                                  ),
                                  Text(
                                    S.back,
                                    style: AppText.l1!.cl(Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (files.isNotEmpty) {
                                await cropimage(
                                  files[index],
                                  appBarColor,
                                  bgColor,
                                );
                              } else {
                                await cropimage(
                                  widget.file,
                                  appBarColor,
                                  bgColor,
                                );
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.crop_rotate,
                                  color: Colors.white,
                                  size: AppDimensions.font(
                                    10,
                                  ),
                                ),
                                Text(
                                  S.crop,
                                  style: AppText.l1!.cl(Colors.white),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await getFilterImage(context, appBarColor);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.filter,
                                  color: Colors.white,
                                  size: AppDimensions.font(
                                    10,
                                  ),
                                ),
                                Text(
                                  S.filter,
                                  style: AppText.l1!.cl(Colors.white),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (files.isNotEmpty) {
                                widget.list.imagelist.add(files[index]);
                                widget.list.imagepath.add(files[index].path);
                              } else {
                                widget.list.imagelist.add(widget.file);
                                widget.list.imagepath.add(widget.file.path);
                              }
                              await Navigator.of(context).pushNamed(
                                RouteConstants.multiDelete,
                                arguments: widget.list,
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: AppDimensions.font(
                                    10,
                                  ),
                                ),
                                Text(
                                  S.next,
                                  style: AppText.l1!.cl(Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
