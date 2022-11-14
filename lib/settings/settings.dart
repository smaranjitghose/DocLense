// import 'package:doclense/constants/theme_constants.dart';
import 'package:doclense/constants/route_constants.dart';
import 'package:doclense/main_drawer.dart';
import 'package:doclense/ui_components/double_back_to_close_snackbar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';

import '../providers/theme_provider.dart';
import 'setting_text.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? theme;
  bool adjustBorders = true;
  bool textOcr = true;
  bool saveFile = true, _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var swithValue = themeChange.darkTheme;

    Future<void> userFeedback() async {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      Wiredash.of(context)
        ..setBuildProperties(
          buildNumber: packageInfo.buildNumber,
          buildVersion: packageInfo.version,
        )
        ..show();
    }

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text("Preferences"),
      ),
      body: _isLoading
          ? const SpinKitRotatingCircle(
              color: Colors.blue,
            )
          : DoubleBackToCloseApp(
              snackBar: doubleBackToCloseSnackBar(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 800,
                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Text("APP THEME OPTIONS"),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                    color: themeChange.darkTheme
                                        ? Colors.black45
                                        : Colors.grey[200],
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const SettingText(text: 'Dark Mode'),
                                        Switch(
                                          activeColor: themeChange.darkTheme
                                              ? Colors.white
                                              : Colors.blue,
                                          value: swithValue,
                                          onChanged: (bool value) {
                                            setState(() {
                                              swithValue = !swithValue;
                                              themeChange.darkTheme =
                                                  swithValue;
                                            });
                                            //print("Dark Mode");
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // Expanded(
                                //   child: ListTile(
                                //       title: Text("Dark Mode",
                                //           style: TextStyle(
                                //             fontSize: 15.0,
                                //             fontWeight: FontWeight.w600,
                                //           )),
                                //       trailing: Transform.scale(
                                //         scale: 0.7,
                                //         origin: Offset(25, 0),
                                //         child: Switch(
                                //           // activeColor: AppTheme.primaryColor,
                                //           value: swithValue,
                                //           onChanged: (bool value) {
                                //             setState(() {
                                //               swithValue = !swithValue;
                                //               themeChange.darkTheme = swithValue;
                                //             });
                                //             //print("Dark Mode");
                                //           },
                                //         ),
                                //       ),
                                //       onTap: () {
                                //         setState(() {
                                //           swithValue = !swithValue;
                                //           themeChange.darkTheme = swithValue;
                                //         });
                                //       },
                                //     ),
                                // ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //
                            Container(
                              color: themeChange.darkTheme
                                  ? Colors.black45
                                  : Colors.grey[200],
                              height: 50,
                              child: InkWell(
                                onTap: userFeedback,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SettingText(text: 'REPORT A BUG'),
                                    Expanded(
                                      child: Icon(
                                        Icons.bug_report,
                                        size: 30,
                                        color: themeChange.darkTheme
                                            ? Colors.white
                                            : Colors.blue,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: themeChange.darkTheme
                                  ? Colors.black45
                                  : Colors.grey[200],
                              height: 50,
                              child: InkWell(
                                onTap: userFeedback,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SettingText(
                                        text: 'REQUEST A FEATURE'),
                                    Expanded(
                                      child: Icon(
                                        Icons.featured_play_list,
                                        size: 30,
                                        color: themeChange.darkTheme
                                            ? Colors.white
                                            : Colors.blue,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: themeChange.darkTheme
                                  ? Colors.black45
                                  : Colors.grey[200],
                              height: 50,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    RouteConstants.contactDeveloperScreen,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SettingText(
                                        text: 'CONTACT DEVELOPERS'),
                                    Expanded(
                                      child: Icon(
                                        Icons.contact_phone,
                                        size: 30,
                                        color: themeChange.darkTheme
                                            ? Colors.white
                                            : Colors.blue,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
