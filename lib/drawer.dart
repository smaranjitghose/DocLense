import 'package:flutter/material.dart';

class DocDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          color: ThemeData.dark().canvasColor,
          child: Image.asset('lib/Model/images/docIcon.png'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text("About this App"),
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text("Share this App"),
        )
      ],
    );
  }
}
