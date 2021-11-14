import 'package:doclense/main_drawer.dart';
import 'package:doclense/providers/theme_provider.dart';
import 'package:doclense/ui_components/double_back_to_close_snackbar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool _isLoading = true;

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

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text(
          "About App",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: _isLoading
          ? const SpinKitRotatingCircle(
              color: Colors.blue,
            )
          : DoubleBackToCloseApp(
              snackBar: doubleBackToCloseSnackBar(),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.85,
                      // width: MediaQuery.of(context).size.width,
                      child: Stack(children: [
                        if (themeChange.darkTheme)
                          Positioned(
                            top: 0,
                            child: SvgPicture.asset(
                              'assets/aboutPage/curve.svg',
                              // 'assets/aboutPage/bg-wave.svg'
                              // width: MediaQuery.of(context).size.width,
                              // height: 50,
                            ),
                          )
                        else
                          Positioned(
                            top: 0,
                            child: SvgPicture.asset(
                              'assets/aboutPage/curvelight.svg',
                              // 'assets/aboutPage/bg-wave.svg'
                              // width: MediaQuery.of(context).size.width,
                              // height: 50,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 4, 4, 0),
                          child: themeChange.darkTheme
                              ? SvgPicture.asset(
                                  'assets/doclensewhite.svg',
                                )
                              : SvgPicture.asset(
                                  'assets/images/doclenselight.svg',
                                  // width: 300,
                                  // height: 100,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          // right: MediaQuery.of(context).size.width/9,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: const Text(
                              "DocLense is the one place for all your documents!\n\nYou can now click, upload, crop, rotate and do so\nmuch more!\n\nSo whether it is your college assignment or the\noffice document you want to digitalize, stop\nworrying and just use",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Doclense!',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(
                          'assets/aboutPage/undraw_At_work_re_qotl.svg',
                          height: 100,
                        ),
                        SvgPicture.asset(
                          'assets/aboutPage/undraw_Upload_re_pasx.svg',
                          height: 100,
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 13,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
            ),
    );
  }
}
