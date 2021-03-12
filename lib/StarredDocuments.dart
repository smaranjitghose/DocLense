import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {},
          ),
        ],
      ),
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
                  OpenFile.open(starredBox.getAt(0)[index] as String);
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
                            Text((starredBox.getAt(0)[index] as String)
                                .split('/')
                                .last),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.share),
                                onPressed: () async {
                                  final File file = File(await starredBox
                                      .getAt(0)[index] as String);

                                  final path = file.path;

                                  print(path);

                                  Share.shareFiles([path], text: 'Your PDF!');
                                }),
                            IconButton(
                                icon: const Icon(Icons.star),
                                onPressed: () async {
                                  setState(() {
                                    Hive.box('starred')
                                        .getAt(0)
                                        .removeAt(index);
                                  });
                                  Scaffold.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Removed from starred documents')));
                                })
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
