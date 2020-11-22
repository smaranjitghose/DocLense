import 'package:flutter/material.dart';
import 'Home.dart';
import 'About.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.blueGrey[900],
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 180,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 60,
                      child: Icon(
                        Icons.description,
                        color: Colors.teal,
                        size: 70,
                      ),
                    ),
                  ),
                  Text("One Place For All \n Your Documents!", style: TextStyle(fontSize: 20, color: Colors.white),)
                ],
              )
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: (){
              Navigator.of(context).pop();
            },
            leading: Icon(Icons.home),
            title: Text("Home", style: TextStyle(fontSize: 18),),
          ),
          ListTile(
            onTap: (){},
            leading: Icon(Icons.star),
            title: Text("Starred Documents", style: TextStyle(fontSize: 18),),
          ),
          ListTile(
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => About())
              );
            },
            leading: Icon(Icons.info),
            title: Text("About App", style: TextStyle(fontSize: 18),),
          ),
          ListTile(
            onTap: (){},
            leading: Icon(Icons.settings),
            title: Text("Settings", style: TextStyle(fontSize: 18),),
          ),
        ],
      ),
    );
  }
}
