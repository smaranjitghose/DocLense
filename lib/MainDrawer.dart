import 'package:flutter/material.dart';

import 'Home.dart';
import 'About.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18)),
              color: Colors.blue[600],
            ),
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Center(
                child: Column(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 180,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Image.asset(
                      'assets/images/scanlogo.png',
                    ),
                  ),
                ),
                Text(
                  "One Place For All \n Your Documents!",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'),
                ),
              ],
            )),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              leading: Icon(
                EvaIcons.home,
                color: Colors.black,
              ),
              title: Text(
                "Home",
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {},
              leading: Icon(
                EvaIcons.star,
                color: Colors.green,
              ),
              title: Text(
                "Starred Documents",
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => About()));
              },
              leading: Icon(
                EvaIcons.info,
                color: Colors.lightBlue,
              ),
              title: Text(
                "About App",
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {},
              leading: Icon(
                EvaIcons.settings,
                color: Colors.grey,
              ),
              title: Text(
                "Settings",
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
