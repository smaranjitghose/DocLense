import "dart:math";

import "package:flutter/widgets.dart";

class UI {
  static late MediaQueryData? _mediaQueryData;
  static double? width;
  static double? height;
  static double? horizontal;
  static double? vertical;

  /// Padding Before Keyboard raise
  static EdgeInsets? padding;

  /// Padding After Keyboard raise
  static EdgeInsets? vi;
  static late double? _safeAreaHorizontal;
  static late double? _safeAreaVertical;
  static double? safeWidth;
  static double? safeHeight;

  static double? diagonal;

  static bool? xxs;
  static bool? xs;
  static bool? sm;
  static bool? md;
  static bool? xmd;
  static bool? lg;
  static bool? xl;
  static bool? xlg;
  static bool? xxlg;

  static bool isPortrait = false;
  static Size? physicalSize;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    initChecks(_mediaQueryData!);

    padding = _mediaQueryData!.padding;
    vi = _mediaQueryData!.viewInsets;
    width = _mediaQueryData!.size.width;
    height = _mediaQueryData!.size.height;
    horizontal = width! / 100;
    vertical = height! / 100;

    _safeAreaHorizontal =
        _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
    _safeAreaVertical =
        _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
    safeWidth = width! - _safeAreaHorizontal!;
    safeHeight = height! - _safeAreaVertical!;

    ///
    isPortrait = (width ?? 0) < 600;
    physicalSize = View.of(context).physicalSize;
  }

  static void initChecks(MediaQueryData query) {
    final Size size = query.size;
    diagonal = sqrt((size.width * size.width) + (size.height * size.height));
    xxs = size.width > 300;
    xs = size.width > 360;
    sm = size.width > 480;
    md = size.width > 600;
    xmd = size.width > 720;
    lg = size.width > 980;
    xl = size.width > 1160;
    xlg = size.width > 1400;
    xxlg = size.width > 1700;
  }

  static MediaQueryData mediaQuery() => _mediaQueryData!;

  static Size getSize() => _mediaQueryData!.size;
}
