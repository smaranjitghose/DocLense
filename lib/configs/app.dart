import "package:doclense/configs/app_dimensions.dart";
import "package:doclense/configs/app_typography.dart";
import "package:doclense/configs/space.dart";
import "package:doclense/configs/ui.dart";
import "package:flutter/material.dart";

class App {
  static bool? isLtr;
  static bool showAds = false;

  static void init(BuildContext context) {
    UI.init(context);
    AppDimensions.init();
    Space.init();
    AppText.init();
    isLtr = Directionality.of(context) == TextDirection.ltr;
  }
}
