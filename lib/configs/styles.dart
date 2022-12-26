import 'package:flutter/material.dart';

import 'app_dimensions.dart';

class AppStyles {
  final OutlineInputBorder textFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      AppDimensions.normalize(3),
    ),
    borderSide: BorderSide(
      color: Colors.grey.shade500,
    ),
  );
}
