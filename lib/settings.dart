import 'package:flutter/material.dart';

import 'MainDrawer.dart';

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
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text("Preferences"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Text("APP THEME OPTIONS"),
            SizedBox(height: 5,),
            Container(
              color: Colors.grey[200],
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "App Theme",
                    style: TextStyle(
                        height: 1,
                        fontSize: 17
                    ),
                  ),
                  DropdownButton(
                    onChanged: (item) {

                    },
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(child: Text("System Default"),),
                      DropdownMenuItem<String>(child: Text("Light"),),
                      DropdownMenuItem<String>(child: Text("Dark"),)
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20,),

            Text("ADJUST BORDERS"),
            SizedBox(height: 5,),
            Container(
              color: Colors.grey[200],
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "When auto-capturing , let me adjust borders after each scan",
                      style: TextStyle(
                          height: 1,
                          fontSize: 17
                      ),
                    ),
                  ),
                  Switch(
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

            SizedBox(height: 40,),

            Text("TEXT RECOGNITION (OCR)"),
            SizedBox(height: 5,),
            Container(
              color: Colors.grey[200],
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Run text recognition on saved pdf",
                      style: TextStyle(
                          height: 1,
                          fontSize: 17
                      ),
                    ),
                  ),
                  Switch(
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
              color: Colors.grey[200],
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Text Recognition Language",
                      style: TextStyle(
                          height: 1,
                          fontSize: 17
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                          "English"
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 40,),

            Text("FILES"),
            SizedBox(height: 5,),
            Container(
              color: Colors.grey[200],
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Save Original files to Gallery",
                      style: TextStyle(
                          height: 1,
                          fontSize: 17
                      ),
                    ),
                  ),
                  Switch(
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

            SizedBox(height: 40,),

            Container(
              color: Colors.grey[200],
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "  REPORT A BUG",
                      style: TextStyle(
                          height: 1,
                          fontSize: 17
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.bug_report,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 10,),

            Container(
              color: Colors.grey[200],
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "  REQUEST A FEATURE",
                      style: TextStyle(
                          height: 1,
                          fontSize: 17
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.featured_play_list,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 10,),

            Container(
              color: Colors.grey[200],
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "  CONTACT DEVELOPERS",
                      style: TextStyle(
                          height: 1,
                          fontSize: 17
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.contact_phone,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}