import 'package:doclense/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'providers/theme_provider.dart';
import 'ui_components/drawer_nav_item.dart';

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
                        backgroundColor: themeChange.darkTheme
                            ? Colors.black
                            : Colors.white10,
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
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // Added drawerNavItems in Place of Drawer ListTiles below.
            // Navigate to ui_components/Drawer_Nav_Items.dart to explore the refactored drawerNavItem Class.

            DrawerNavItem(
              iconData: Icons.home,
              navItemTitle: 'Home',
              callback: () {
                Navigator.of(context).pushReplacementNamed(
                  RouteConstants.homeScreen,
                );
              },
            ),
            DrawerNavItem(
                iconData: Icons.stars_rounded,
                navItemTitle: 'Starred Documents',
                callback: () {
                  Navigator.of(context).pushReplacementNamed(
                    RouteConstants.starredDocumentsScreen,
                  );
                }),
            DrawerNavItem(
              callback: () {
                Navigator.of(context).pushReplacementNamed(
                  RouteConstants.settingsScreen,
                );
              },
              navItemTitle: 'Settings',
              iconData: Icons.settings,
            ),
            Divider(
              color: themeChange.darkTheme ? Colors.white : Colors.black,
            ),
            DrawerNavItem(
              iconData: Icons.info,
              navItemTitle: 'About App',
              callback: () {
                Navigator.of(context).pushReplacementNamed(
                  RouteConstants.aboutAppScreen,
                );
              },
            ),
            DrawerNavItem(
              navItemTitle: 'Rate us',
              iconData: Icons.star_rate,
              callback: () {
                Navigator.of(context).pop();
                showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return RatingDialog(
                        // accentColor:
                        //     themeChange.darkTheme ? Colors.white : Colors.blue,
                        image: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: themeChange.darkTheme
                              ? SvgPicture.asset('assets/doclensewhite.svg')
                              : SvgPicture.asset(
                                  'assets/images/doclenselight.svg'),
                        ),
                        title: Text("How was your experience?"),
                        onSubmitted: (RatingDialogResponse) {
                          _launchURL();
                        },
                        submitButtonText: "Submit",
                        message: Text("Let us know what you think"),
                      );
                    });
              },
            ),
            Divider(
              color: themeChange.darkTheme ? Colors.white : Colors.black,
            ),
            DrawerNavItem(
              navItemTitle: 'Share the App',
              iconData: Icons.share,
              callback: () {
                Share.share(
                    'Hey !! , I am using this wonderful app : DocLense , check it out here https://github.com/smaranjitghose/DocLense',
                    subject: "DocLense");
              },
            ),
            // ListTile(
            //   onTap: () {
            //     Navigator.of(context).pop();
            //     Share.share('Share my PDF');
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
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}
