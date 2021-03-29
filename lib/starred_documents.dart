import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'providers/theme_provider.dart';
import 'main_drawer.dart';

class Starred extends StatefulWidget {
  @override
  _StarredState createState() => _StarredState();
}

class _StarredState extends State<Starred> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text(
          'Starred Docs',
          style: TextStyle(fontSize: 24),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      // ignore: deprecated_member_use
      body: WatchBoxBuilder(
        box: Hive.box('starred'),
        builder: (context, starredBox) {
          if (starredBox.getAt(0).length == 0) {
            return const Center(
              child: Text("No PDFs Starred Yet !! "),
            );
          }
          return ListView.builder(
            itemCount: starredBox.getAt(0).length as int,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print('tapped');
                  OpenFile.open(starredBox.getAt(0)[index][0] as String);
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 5,
                    color:
                        themeChange.darkTheme ? Colors.grey[700] : Colors.white,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image(
                                image: FileImage(
                                    starredBox.getAt(0)[index][2] as File),
                                width: MediaQuery.of(context).size.width / 6,
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (starredBox.getAt(0)[index][0] as String)
                                    .split('/')
                                    .last,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: Text('${starredBox.getAt(0)[index][1]}'),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Row(
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width *
                                          MediaQuery.of(context)
                                              .devicePixelRatio) *
                                      0.1,
                                ),
                                IconButton(
                                    icon: const Icon(Icons.share),
                                    onPressed: () async {
                                      final File file = File(await starredBox
                                          .getAt(0)[index][0] as String);

                                      final path = file.path;

                                      print(path);

                                      Share.shareFiles([path],
                                          text: 'Your PDF!');
                                    }),
                                IconButton(
                                    icon: const Icon(Icons.star),
                                    onPressed: () async {
                                      setState(() {
                                        Hive.box('starred')
                                            .getAt(0)
                                            .removeAt(index);
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Removed from starred documents'),
                                        ),
                                      );
                                    }),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
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
    );
  }
}
