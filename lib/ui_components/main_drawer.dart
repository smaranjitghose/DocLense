import "package:doclense/configs/app_dimensions.dart";
import "package:doclense/configs/app_typography.dart";
import "package:doclense/configs/space.dart";
import "package:doclense/constants/appstrings.dart";
import "package:doclense/constants/assets.dart";
import "package:doclense/constants/route_constants.dart";
import "package:doclense/env.dart";
import "package:doclense/providers/theme_provider.dart";
import "package:doclense/ui_components/drawer_nav_item.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:provider/provider.dart";
import "package:rating_dialog/rating_dialog.dart";
import "package:share_plus/share_plus.dart";
import "package:url_launcher/url_launcher.dart";

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final DarkThemeProvider themeChange = Provider.of<DarkThemeProvider>(context);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: themeChange.darkTheme ? Colors.black : Colors.white10,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: AppDimensions.normalize(80),
                    height: AppDimensions.normalize(80),
                    child: CircleAvatar(
                      backgroundColor:
                          themeChange.darkTheme ? Colors.black : Colors.white10,
                      radius: AppDimensions.normalize(60),
                      child: themeChange.darkTheme
                          ? SvgPicture.asset(
                              Assets.doclensewhitesmall,
                            )
                          : SvgPicture.asset(
                              Assets.doclenselightsmall,
                            ),
                    ),
                  ),
                  Text(S.onePlace, style: AppText.b1),
                ],
              ),
            ),
            Space.y!,

            // Added drawerNavItems in Place of Drawer ListTiles below.
            // Navigate to ui_components/Drawer_Nav_Items.dart to explore the refactored drawerNavItem Class.

            DrawerNavItem(
              iconData: Icons.home,
              navItemTitle: S.home,
              callback: () {
                Navigator.of(context).pushReplacementNamed(
                  RouteConstants.homeScreen,
                );
              },
            ),
            DrawerNavItem(
                iconData: Icons.stars_rounded,
                navItemTitle: S.starredDocuments,
                callback: () {
                  Navigator.of(context).pushReplacementNamed(
                    RouteConstants.starredDocumentsScreen,
                  );
                },),
            DrawerNavItem(
              callback: () {
                Navigator.of(context).pushReplacementNamed(
                  RouteConstants.settingsScreen,
                );
              },
              navItemTitle: S.settings,
              iconData: Icons.settings,
            ),
            Divider(
              color: themeChange.darkTheme ? Colors.white : Colors.black,
            ),
            DrawerNavItem(
              iconData: Icons.info,
              navItemTitle: S.aboutApp,
              callback: () {
                Navigator.of(context).pushReplacementNamed(
                  RouteConstants.aboutAppScreen,
                );
              },
            ),
            DrawerNavItem(
              navItemTitle: S.rateus,
              iconData: Icons.star_rate,
              callback: () {
                Navigator.of(context).pop();
                showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => RatingDialog(
                        image: Padding(
                          padding: EdgeInsets.fromLTRB(
                              AppDimensions.normalize(10), 0, 0, 0,),
                          child: themeChange.darkTheme
                              ? SvgPicture.asset(Assets.doclensewhiteSvg)
                              : SvgPicture.asset(Assets.doclenselightSvg),
                        ),
                        title: const Text(
                          S.howWasExperience,
                          textAlign: TextAlign.center,
                        ),
                        onSubmitted: (RatingDialogResponse RatingDialogResponse) {
                          _launchURL();
                        },
                        submitButtonText: S.submit,
                        message: const Text(
                          S.letUsKnow,
                          textAlign: TextAlign.center,
                        ),
                      ),);
              },
            ),
            Divider(
              color: themeChange.darkTheme ? Colors.white : Colors.black,
            ),
            DrawerNavItem(
              navItemTitle: S.shareTheApp,
              iconData: Icons.share,
              callback: () {
                Share.share(S.shareMessage, subject: Env.appname);
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
  const String url =
      "https://github.com/smaranjitghose/DocLense"; //!paste link of app once uploaded on play store
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw "Could not launch $url";
  }
}
