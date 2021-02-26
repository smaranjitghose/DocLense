import 'package:doclense/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: themeChange.darkTheme ? Colors.black : Colors.white10,
              child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 180,
                        child: CircleAvatar(
                          backgroundColor: themeChange.darkTheme
                              ? Colors.black
                              : Colors.white10,
                          radius: 60,
                          child: themeChange.darkTheme ?
                          SvgPicture.asset(
                            'assets/doclensewhitesmall.svg',
                            height: 100,
                          ) :
                          SvgPicture.asset(
                            'assets/doclenselightsmall.svg',
                            height: 100,
                          ),
                        ),
                      ),
                      Text(
                        "One Place For All \n Your Documents!",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                leading: Icon(Icons.home),
                title: Text(
                  "Home",
                  style: TextStyle(fontSize: 18),)),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.stars_rounded),
              title: Text(
                "Starred Documents",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Share.share(
                  'Hey !! , I am using this wonderful app : DocLense , check it out here https://github.com/smaranjitghose/DocLense',
                  subject: "DocLense");
            },
            leading: Icon(Icons.share),
            title: Text(
              "Share the App",
              style: TextStyle(fontSize: 18),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
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
            Divider(
              color: themeChange.darkTheme ? Colors.white : Colors.black,),
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
                Navigator.of(context).pop();

                showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return RatingDialog(
                        accentColor: themeChange.darkTheme
                            ? Colors.black
                            : Colors
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
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ));
            },
            leading: Icon(Icons.settings),
            title: Text(
              "Settings",
              style: TextStyle(fontSize: 18),
            Divider(
              color: themeChange.darkTheme ? Colors.white : Colors.black,),
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
            // ListTile(
            //   onTap: () {
            //     Navigator.of(context).pop();
            //     Share.share('Share my PDF');
            //     //TODO: add pdf file that is to be shared
            //   },
            //   leading: Icon(Icons.share),
            //   title: Text(
            //     "Share PDF",
            //     style: TextStyle(fontSize: 18),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

/*class drawerShareItem extends StatelessWidget {
  String shareCaption, shareTitle;

  drawerShareItem({
    this.shareCaption,
    this.shareTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Share.share(shareCaption, subject: "DocLense");
      },
      leading: Icon(Icons.share),
      title: Text(
        shareTitle,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class drawerNavItem extends StatelessWidget {
  Widget navigateTo;
  IconData screenIcon;
  String screenName;

  drawerNavItem(
      {this.navigateTo, @required this.screenIcon, @required this.screenName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pop();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigateTo));
      },
      leading: Icon(screenIcon),
      title: Text(
        screenName,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
*/
// TODO: Refactor the above listtile widgets to a custom widget with the required properties

_launchURL() async {
  const url =
      'https://github.com/smaranjitghose/DocLense'; //!paste link of app once uploaded on play store
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
