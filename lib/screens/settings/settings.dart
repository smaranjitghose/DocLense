import "package:doclense/configs/app_dimensions.dart";
import "package:doclense/configs/app_typography.dart";
import "package:doclense/configs/space.dart";
import "package:doclense/constants/appstrings.dart";
import "package:doclense/constants/route_constants.dart";
import "package:doclense/providers/theme_provider.dart";
import "package:doclense/screens/settings/setting_text.dart";
import "package:doclense/ui_components/double_back_to_close_snackbar.dart";
import "package:doclense/ui_components/main_drawer.dart";
import "package:double_back_to_close_app/double_back_to_close_app.dart";
import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:provider/provider.dart";
import "package:wiredash/wiredash.dart";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String? theme;
  bool adjustBorders = true;
  bool textOcr = true;
  bool saveFile = true;

  @override
  Widget build(BuildContext context) {
    final DarkThemeProvider themeChange =
        Provider.of<DarkThemeProvider>(context);
    bool swithValue = themeChange.darkTheme;

    Future<void> userFeedback() async {
      await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        Wiredash.of(context)
            // ..setBuildProperties(
            //   buildNumber: packageInfo.buildNumber,
            //   buildVersion: packageInfo.version,
            // )
            .show();
      });
    }

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text(S.preferences),
      ),
      body: DoubleBackToCloseApp(
        snackBar: doubleBackToCloseSnackBar(),
        child: ListView(
          padding: Space.all(),
          children: <Widget>[
            Space.y1!,
            Text(
              S.appThemeOptions.toUpperCase(),
              style: AppText.l1b,
            ),
            Space.y!,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: themeChange.darkTheme
                        ? Colors.black45
                        : Colors.grey[200],
                    height: AppDimensions.font(25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const SettingText(text: S.darkMode),
                        Switch(
                          activeColor: themeChange.darkTheme
                              ? Colors.white
                              : Colors.blue,
                          value: swithValue,
                          onChanged: (bool value) {
                            setState(() {
                              swithValue = !swithValue;
                              themeChange.darkTheme = swithValue;
                            });
                            //print("Dark Mode");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Space.y1!,
            _SettingsTile(
              themeChange: themeChange,
              onTap: userFeedback,
              title: S.reportABug,
              iconData: Icons.bug_report,
            ),
            _SettingsTile(
              themeChange: themeChange,
              onTap: userFeedback,
              title: S.requestAFeature,
              iconData: Icons.featured_play_list,
            ),
            _SettingsTile(
              themeChange: themeChange,
              onTap: () async {
                await Navigator.of(context).pushNamed(
                  RouteConstants.contactDeveloperScreen,
                );
              },
              title: S.contactDevelopers,
              iconData: Icons.contact_phone,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.themeChange,
    required this.onTap,
    required this.title,
    required this.iconData,
  });

  final DarkThemeProvider themeChange;
  final Function onTap;
  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) => Container(
        color: themeChange.darkTheme ? Colors.black45 : Colors.grey[200],
        height: AppDimensions.font(25),
        margin: Space.vf(0.3),
        child: InkWell(
          onTap: () => onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SettingText(text: title.toUpperCase()),
              Expanded(
                child: Icon(
                  iconData,
                  size: AppDimensions.font(15),
                  color: themeChange.darkTheme ? Colors.white : Colors.blue,
                ),
              ),
            ],
          ),
        ),
      );
}
