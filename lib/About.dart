import 'package:doclense/MainDrawer.dart';
import 'package:doclense/Providers/ThemeProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          "About App",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            themeChange.darkTheme ?
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 4, 4, 0),
              child: SvgPicture.asset(
                'assets/doclensewhite.svg',
              ),
            )
                :
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 4, 4, 0),
              child: SvgPicture.asset(
                'assets/images/doclenselight.svg',
                // width: 300,
                // height: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              child: Text(
                "DocLense is the one place for all your documents. \nYou can now click, upload, crop, rotate and do so much more!\n\nSo whether it is your college assignment or the office document you want to digitalize, stop worrying and just use DocLense!",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Text(
                    "Made with ❤ by Open Source",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
