


import 'package:doclense/GooglePixel44XL1.dart';

import 'package:doclense/settings.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:share/share.dart';
import 'settings.dart';


class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.blue[600],
            child: Center(
                child: Column(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 180,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 60,
                    child: Image.asset(
                      'assets/images/scanlogo.png',
                    ),
                  ),
                ),
                Text(
                  "One Place For All \n Your Documents!",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            )),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            
            leading: Icon(Icons.home),
            title: Text(
              "Home",
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.star),
            title: Text(
              "Starred Documents",
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => GooglePixel44XL1()));
            },
            leading: Icon(Icons.info),
            title: Text(
              "About App",
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {
              Share.share(
                'Hey !! , I am using this wonderful app : DocLense , check it out here https://github.com/smaranjitghose/DocLense',
                subject: "DocLense"
              );
            },
            leading: Icon(Icons.share),
            title: Text(
              "Share the App",
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Share.share('Share my PDF');
              //TODO: add pdf file that is to be shared
            },
            leading: Icon(Icons.share),
            title: Text(
              "Share PDF",
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {

               
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SettingsScreen()));

              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(),));

            },
            leading: Icon(Icons.settings),
            title: Text(
              "Settings",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
