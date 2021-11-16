import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

String base64StringFromImage(Uint8List image) {
  return base64Encode(image);
}

Image base64StringToImage(String image) {
  return Image.memory(
    base64Decode(image),
    fit: BoxFit.fill,
  );
}
