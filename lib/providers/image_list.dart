// TODO Implement this library.
import 'dart:io';

import 'package:flutter/cupertino.dart';

class ImageList extends ChangeNotifier {
  List<File> imagelist = List<File>();
  List<String> imagepath = List<String>();
  notifyListeners();

  int length() {
    return imagelist.length;
  }
}
