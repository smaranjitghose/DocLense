import 'package:doclense/starred_documents.dart';
import 'package:doclense/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:provider/provider.dart';

import 'About.dart';

import 'Providers/theme_provider.dart';

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
              padding: const EdgeInsets.all(20),
              color: themeChange.darkTheme ? Colors.black : Colors.white10,
              child: Center(
                  child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    height: 180,
                    child: CircleAvatar(
                      backgroundColor:
                          themeChange.darkTheme ? Colors.black : Colors.white10,
                      radius: 60,
                      child: themeChange.darkTheme
                          ? SvgPicture.asset(
                              'assets/doclensewhitesmall.svg',
                              height: 100,
                            )
                          : SvgPicture.asset(
                              'assets/doclenselightsmall.svg',
                              height: 100,
                            ),
                    ),
                  ),
                  const Text(
                    "One Place For All \n Your Documents!",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                leading: const Icon(Icons.home),
                title: const Text(
                  "Home",
                  style: TextStyle(fontSize: 18),
                )),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => Starred(),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      // transitionDuration: Duration(milliseconds: 2000),
                    ));
              },
              leading: const Icon(Icons.stars_rounded),
              title: const Text(
                "Starred Documents",
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => SettingsScreen(),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    // transitionDuration: Duration(milliseconds: 2000),
                  ),
                );
              },
              leading: const Icon(Icons.settings),
              title: const Text(
                "Settings",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Divider(
              color: themeChange.darkTheme ? Colors.white : Colors.black,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => About(),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    // transitionDuration: Duration(milliseconds: 1000),
                  ),
                );
              },
              leading: const Icon(Icons.info),
              title: const Text(
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
                        accentColor:
                            themeChange.darkTheme ? Colors.black : Colors.blue,
                        icon: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: themeChange.darkTheme ?
                          SvgPicture.asset(
                            'assets/doclensewhite.svg'
                          ) :
                          SvgPicture.asset(
                              'assets/images/doclenselight.svg'),
                        ),
                        title: "How was your experience?",
                        description: "Let us know what you think",
                        onSubmitPressed: (int starRating) {
                          _launchURL();
                        },
                        submitButton: "Submit",
                      );
                    });
              },
              leading: const Icon(Icons.star_rate),
              title: const Text(
                "Rate us",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Divider(
              color: themeChange.darkTheme ? Colors.white : Colors.black,
            ),
            ListTile(
              onTap: () {
                Share.share(
                    'Hey !! , I am using this wonderful app : DocLense , check it out here https://github.com/smaranjitghose/DocLense',
                    subject: "DocLense");
              },
              leading: const Icon(Icons.share),
              title: const Text(
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

Future<void> _launchURL() async {
  const url =
      'https://github.com/smaranjitghose/DocLense'; //!paste link of app once uploaded on play store
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
