import 'package:flutter/material.dart';

import 'app_dimensions.dart';

class AppText {
  static TextStyle? btn;

  // Headings
  static TextStyle? h1;
  static TextStyle? h1b;
  static TextStyle? h2;
  static TextStyle? h2b;
  static TextStyle? h3;
  static TextStyle? h3b;

  // Body
  static TextStyle? b1;
  static TextStyle? b1b;
  static TextStyle? b2;
  static TextStyle? b2b;

  // Label
  static TextStyle? l1;
  static TextStyle? l1b;
  static TextStyle? l2;
  static TextStyle? l2b;

  static init() {
    const b = FontWeight.bold;

    const baseStyle = TextStyle(//fontFamily:
        );

    h1 = baseStyle.copyWith(fontSize: AppDimensions.font(22));
    h1b = h1!.copyWith(fontWeight: b);

    h2 = baseStyle.copyWith(fontSize: AppDimensions.font(18));
    h2b = h2!.copyWith(fontWeight: b);

    h3 = baseStyle.copyWith(fontSize: AppDimensions.font(15));
    h3b = h3!.copyWith(fontWeight: b);

    b1 = baseStyle.copyWith(fontSize: AppDimensions.font(10));
    b1b = b1!.copyWith(fontWeight: b);

    b2 = baseStyle.copyWith(fontSize: AppDimensions.font(8));
    b2b = b2!.copyWith(fontWeight: b);

    l1 = baseStyle.copyWith(fontSize: AppDimensions.font(6));
    l1b = l1!.copyWith(fontWeight: b);

    l2 = baseStyle.copyWith(fontSize: AppDimensions.font(4));
    l2b = l2!.copyWith(fontWeight: b);
  }
}

extension SuperTextStyles on TextStyle {
  TextStyle cl(Color color) {
    return copyWith(
      color: color,
    );
  }

  TextStyle s([double? size]) {
    return copyWith(
      fontSize: size ?? fontSize,
    );
  }

  TextStyle tsc([double multiplier = 1.0]) {
    return copyWith(
      fontSize: fontSize! * multiplier,
    );
  }

  TextStyle w(int i) {
    FontWeight w = FontWeight.w400;

    if (i == 3) {
      w = FontWeight.w300;
    }
    if (i == 5) {
      w = FontWeight.w500;
    }
    if (i == 6) {
      w = FontWeight.w600;
    }
    if (i == 7) {
      w = FontWeight.w700;
    }
    return copyWith(
      fontWeight: w,
    );
  }
}
