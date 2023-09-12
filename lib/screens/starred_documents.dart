import "dart:io";

import "package:doclense/configs/app_dimensions.dart";
import "package:doclense/configs/app_typography.dart";
import "package:doclense/configs/space.dart";
import "package:doclense/constants/appstrings.dart";
import "package:doclense/providers/theme_provider.dart";
import "package:doclense/ui_components/double_back_to_close_snackbar.dart";
import "package:doclense/ui_components/main_drawer.dart";
import "package:doclense/utils/image_converter.dart" as image_converter;
import "package:double_back_to_close_app/double_back_to_close_app.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:open_file/open_file.dart";
import "package:provider/provider.dart";
import "package:share_plus/share_plus.dart";

class Starred extends StatefulWidget {
  const Starred({super.key});

  @override
  StarredState createState() => StarredState();
}

class StarredState extends State<Starred> {
  @override
  Widget build(BuildContext context) {
    final DarkThemeProvider themeChange =
        Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: Text(
          S.starredDocs,
          style: AppText.h4b,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: AppDimensions.font(
                13,
              ),
            ),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: DoubleBackToCloseApp(
        snackBar: doubleBackToCloseSnackBar(),
        child: ValueListenableBuilder<Box<dynamic>>(
          valueListenable: Hive.box("starred").listenable(),
          builder:
              (BuildContext context, Box<dynamic> starredBox, Widget? widget) {
            if ((starredBox.getAt(0) as List<dynamic>).isEmpty) {
              return const Center(
                child: Text("No PDFs Starred Yet !! "),
              );
            }
            return ListView.builder(
              itemCount: (starredBox.getAt(0) as List<dynamic>).length,
              itemBuilder: (BuildContext context, int index) {
                final Image previewImage = image_converter.base64StringToImage(
                  (starredBox.getAt(0) as List<dynamic>)[index][2] as String,
                );
                return GestureDetector(
                  onTap: () async {
                    debugPrint("tapped");
                    await OpenFile.open(
                      starredBox.getAt(0)[index][0] as String,
                    );
                  },
                  child: Padding(
                    padding: Space.all(0.75),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: Space.all(0.4),
                                child: Text(
                                  (starredBox.getAt(0)[index][0] as String)
                                      .split("/")
                                      .last
                                      .trim(),
                                  style: AppText.b1,
                                ),
                              ),
                              Padding(
                                padding: Space.all(0.4),
                                child: Text(
                                  "${starredBox.getAt(0)[index][1]}",
                                  style: AppText.l1,
                                ),
                              ),
                              Space.y!,
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width *
                                            MediaQuery.of(context)
                                                .devicePixelRatio) *
                                        0.1,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: themeChange.darkTheme
                                          ? Colors.white70
                                          : Colors.grey,
                                      size: AppDimensions.font(8),
                                    ),
                                    onPressed: () async {
                                      await _onShare(starredBox, index);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.star,
                                      color: themeChange.darkTheme
                                          ? Colors.white70
                                          : Colors.grey,
                                      size: AppDimensions.font(8),
                                    ),
                                    onPressed: () async {
                                      await _onStarred(index, context);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: themeChange.darkTheme
                                          ? Colors.white70
                                          : Colors.grey,
                                    ),
                                    onPressed: () async {},
                                  ),
                                ],
                              ),
                            ],
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
    );
  }

  Future<void> _onStarred(int index, BuildContext context) async {
    setState(() {
      Hive.box("starred").getAt(0).removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          S.removeStar,
          style: AppText.b1,
        ),
      ),
    );
  }

  Future<void> _onShare(Box<dynamic> starredBox, int index) async {
    final File file = File(await starredBox.getAt(0)[index][0] as String);

    final String path = file.path;

    debugPrint(path);

    await Share.shareXFiles(
      <XFile>[XFile(path)],
      text: S.yourPDF,
    );
  }
}
