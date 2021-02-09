import 'package:doclense/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Home.dart';
import 'About.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rating_dialog/rating_dialog.dart';

import 'Providers/ThemeProvider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

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
                  context, PageRouteBuilder(
                pageBuilder: (c, a1, a2) => Home(),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                // transitionDuration: Duration(milliseconds: 1000),
              ));
            },
            leading: Icon(Icons.home),
            title: Text(
              "Home",
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.stars_rounded),
            title: Text(
              "Starred Documents",
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, PageRouteBuilder(
                pageBuilder: (c, a1, a2) => About(),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                // transitionDuration: Duration(milliseconds: 1000),
              ),);
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
              Navigator.push(context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => SettingsScreen(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  // transitionDuration: Duration(milliseconds: 2000),
                ),);
            },
            leading: Icon(Icons.settings),
            title: Text(
              "Settings",
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();

              showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return RatingDialog(
                      accentColor: themeChange.darkTheme ? Colors.black : Colors
                          .blue,
                      icon: Image.asset('assets/images/logos.png'),
                      title: "How's your experience with us?",
                      description: "Let us know what you think",
                      onSubmitPressed: (int starRating) {
                        _launchURL();
                      },
                      submitButton: "Submit",
                    );
                  });
            },
            leading: Icon(Icons.star_rate),
            title: Text(
              "Rate us",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}


_launchURL() async {
  const url =
      'https://github.com/smaranjitghose/DocLense'; //!paste link of app once uploaded on play store
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}