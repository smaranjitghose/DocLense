import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';
import 'MainDrawer.dart';

class Starred extends StatefulWidget {
  @override
  _StarredState createState() => _StarredState();
}

class _StarredState extends State<Starred> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Starred Docs',
          style: TextStyle(
              fontSize: 24),
        ),
        actions: <Widget>[
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
        box: Hive.box('starred'),
        builder: (context, starredBox) {
          if (starredBox
              .getAt(0)
              .length == 0) {
            return Center(
              child: Text(
                  "No PDFs Starred Yet !! "
              ),
            );
          }
          return ListView.builder(
            itemCount: starredBox
                .getAt(0)
                .length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print('tapped');
                  OpenFile.open(starredBox.getAt(0)[index]);
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
                                starredBox.getAt(0)[index]
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
                                      starredBox.getAt(0)[index]
                                  );

                                  final path = file.path;

                                  print(path);

                                  Share.shareFiles(
                                      ['$path'], text: 'Your PDF!');
                                }
                            ),
                            IconButton(
                                icon: Icon(
                                    Icons.star
                                ),
                                onPressed: () async {
                                }
                            )
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
    );
  }
}
