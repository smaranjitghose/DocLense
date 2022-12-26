import 'package:doclense/configs/app_dimensions.dart';
import 'package:doclense/configs/app_typography.dart';
import 'package:doclense/configs/space.dart';
import 'package:doclense/configs/ui.dart';
import 'package:doclense/constants/appstrings.dart';
import 'package:doclense/constants/assets.dart';
import 'package:doclense/ui_components/main_drawer.dart';
import 'package:doclense/providers/theme_provider.dart';
import 'package:doclense/ui_components/double_back_to_close_snackbar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          S.aboutApp,
        ),
      ),
      body: DoubleBackToCloseApp(
        snackBar: doubleBackToCloseSnackBar(),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                clipBehavior: Clip.none,
                height: UI.height! / 1.45,
                child: Stack(clipBehavior: Clip.none, children: [
                  if (themeChange.darkTheme)
                    Positioned(
                      top: 0,
                      child: SvgPicture.asset(
                        Assets.curveSvg,
                      ),
                    )
                  else
                    Positioned(
                      top: 0,
                      child: SvgPicture.asset(
                        Assets.curvelightSvg,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(left: AppDimensions.width(10)),
                    child: themeChange.darkTheme
                        ? SvgPicture.asset(
                            Assets.doclensewhiteSvg,
                          )
                        : SvgPicture.asset(
                            Assets.doclenselightSvg,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      alignment: Alignment.center,
                      width: UI.width!,
                      padding: Space.h! / 2.0,
                      child: Text(S.appAbout,
                          textAlign: TextAlign.center, style: AppText.b1),
                    ),
                  ),
                ]),
              ),
              Space.y1!,
              Text(
                S.doclense + '!',
                style: AppText.h3b,
              ),
              SizedBox(
                height: UI.height! / 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    Assets.undrawSvg,
                    height: AppDimensions.height(15),
                  ),
                  SvgPicture.asset(
                    Assets.undrawUpSvg,
                    height: AppDimensions.height(15),
                  )
                ],
              ),
              Space.y2!,
              Text(
                S.madeByOpenSource,
                style: AppText.b2b,
              ),
              Space.y1!,
            ],
          ),
        ),
      ),
    );
  }
}
