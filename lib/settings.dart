// import 'package:doclense/Constants/ThemeConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MainDrawer.dart';
import 'Providers/ThemeProvider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String theme;
  bool adjustBorders = true;
  bool textOcr = true;
  bool saveFile = true;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var swithValue = themeChange.darkTheme;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text("Preferences"),
      ),
      body: Padding(
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Dark mode",
                                    style: TextStyle(height: 1, fontSize: 17),
                                  ),
                                ),
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
                      height: 20,
                    ),
                    const Text("ADJUST BORDERS"),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: themeChange.darkTheme
                          ? Colors.black45
                          : Colors.grey[200],
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Text(
                              "When auto-capturing , let me adjust borders after each scan",
                              style: TextStyle(height: 1, fontSize: 17),
                            ),
                          ),
                          Switch(
                            activeColor: themeChange.darkTheme
                                ? Colors.white
                                : Colors.blue,
                            value: adjustBorders,
                            onChanged: (value) {
                              setState(() {
                                adjustBorders = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text("TEXT RECOGNITION (OCR)"),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: themeChange.darkTheme
                          ? Colors.black45
                          : Colors.grey[200],
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Text(
                              "Run text recognition on saved pdf",
                              style: TextStyle(height: 1, fontSize: 17),
                            ),
                          ),
                          Switch(
                            activeColor: themeChange.darkTheme
                                ? Colors.white
                                : Colors.blue,
                            value: textOcr,
                            onChanged: (value) {
                              setState(() {
                                textOcr = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: themeChange.darkTheme
                          ? Colors.black45
                          : Colors.grey[200],
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Text Recognition Language",
                              style: TextStyle(height: 1, fontSize: 17),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text("English"),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text("FILES"),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: themeChange.darkTheme
                          ? Colors.black45
                          : Colors.grey[200],
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Text(
                              "Save Original files to Gallery",
                              style: TextStyle(height: 1, fontSize: 17),
                            ),
                          ),
                          Switch(
                            activeColor: themeChange.darkTheme
                                ? Colors.white
                                : Colors.blue,
                            value: saveFile,
                            onChanged: (value) {
                              setState(() {
                                saveFile = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      color: themeChange.darkTheme
                          ? Colors.black45
                          : Colors.grey[200],
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Text(
                              "  REPORT A BUG",
                              style: TextStyle(height: 1, fontSize: 17),
                            ),
                          ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: themeChange.darkTheme
                          ? Colors.black45
                          : Colors.grey[200],
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Text(
                              "  REQUEST A FEATURE",
                              style: TextStyle(height: 1, fontSize: 17),
                            ),
                          ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: themeChange.darkTheme
                          ? Colors.black45
                          : Colors.grey[200],
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Text(
                              "  CONTACT DEVELOPERS",
                              style: TextStyle(height: 1, fontSize: 17),
                            ),
                          ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
