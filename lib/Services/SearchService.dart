import 'package:doclense/Constants/ThemeConstants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';

class SearchService extends SearchDelegate<String> {

  List<dynamic> files = Hive.box('pdfs').getAt(0);

  List<dynamic> pdfNames = [];

  List<dynamic> recentFiles = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {

  }

  @override
  Widget buildResults(BuildContext context) {

  }

  @override
  Widget buildSuggestions(BuildContext context) {

}