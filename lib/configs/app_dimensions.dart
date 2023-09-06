import "dart:ui" as ui;

import "package:doclense/configs/ui.dart";
import "package:flutter/material.dart";

class AppDimensions {
  static double? maxContainerWidth;
  static double? miniContainerWidth;

  static bool? isLandscape;
  static double? padding;
  static double ratio = 0;

  static Size? size;

  static void init() {
    ratio = UI.width! / UI.height!;
    final double pixelDensity = UI.mediaQuery().devicePixelRatio;
    ratio = ratio + ((pixelDensity + ratio) / 2);

    if (UI.width! <= 380 && pixelDensity >= 3) {
      ratio *= 0.85;
    }

    _initLargeScreens();
    _initSmallScreensHighDensity();

    padding = ratio * 3;
  }

  static void _initLargeScreens() {
    const double safe = 2.4;

    ratio *= 1.5;

    if (ratio > safe) {
      ratio = safe;
    }
  }

  static void _initSmallScreensHighDensity() {
    if (!UI.sm! && ratio > 2.0) {
      ratio = 2.0;
    }
    if (!UI.xs! && ratio > 1.6) {
      ratio = 1.6;
    }
    if (!UI.xxs! && ratio > 1.4) {
      ratio = 1.4;
    }
  }

  static String inString() {
    final double x = UI.width! / UI.height!;
    final Size ps = ui.window.physicalSize;
    return """
      Width: ${UI.width} | ${ps.width}
      Height: ${UI.height} | ${ps.height}
      app_ratio: $ratio
      ratio: $x
      pixels: ${UI.mediaQuery().devicePixelRatio}
    """;
  }

  /// Use this method for creating responsive Space between widgets
  static double space([double multiplier = 1.0]) =>
      AppDimensions.padding! * 3 * multiplier;

  /// Use this method for creating responsive Widget Sizes
  /// Note: For Exact width and height never use it
  static double normalize(double unit) =>
      (AppDimensions.ratio * unit * 0.77) + unit;

  /// Use this method for creating responsive Fonts
  static double font(double unit) =>
      (AppDimensions.ratio * unit * 0.125) + unit * 1.90;

  /// Use this method for getting responsive width
  /// Note: 4.8 is just for handling failure case
  static double width(double percentage) => (UI.horizontal ?? 4.8) * percentage;

  /// Use this method for getting responsive height
  /// Note: 7.2 is just for handling failure case
  static double height(double percentage) => (UI.vertical ?? 7.2) * percentage;
}
