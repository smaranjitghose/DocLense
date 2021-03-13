import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
// import 'package:doclense/Constants/theme_constants.dart';

class SearchService extends SearchDelegate<String> {
  List<dynamic> files = Hive.box('pdfs').getAt(0) as List<dynamic>;

  List<dynamic> pdfNames = [];

  List<dynamic> recentFiles = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    // assert(context != null);
    final ThemeData theme = Theme.of(context);
    // assert(theme != null);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: Brightness.dark,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // OpenFile.open(Hive.box('pdfs').getAt(0)[index]);
    for (int i = 0; i < files.length; i++) {
      pdfNames.add(Hive.box('pdfs').getAt(0)[i].split('/').last);
    }

    final int remove = (3 * pdfNames.length / 16).floor();

    pdfNames.removeRange(files.length, pdfNames.length);
    pdfNames = pdfNames.map((element) => element.toLowerCase()).toList();
    recentFiles = pdfNames.sublist(pdfNames.length - remove);

    final suggestedFiles = query.isEmpty
        ? recentFiles
        : pdfNames
            .where((p) => p.startsWith(query.toLowerCase()) as bool)
            .toList();

    // print(files.length);
    // print(pdfNames);
    // print(suggestedFiles);

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          final String fileLocation =
              '${Hive.box('pdfs').getAt(0).where((element) => element.toString().split('/').last == suggestedFiles[index])}';
          print(fileLocation);

          final String fileLoc = fileLocation.split('(').last.split(')').first;

          // query = fileLoc.split('/').last;

          OpenFile.open(fileLoc);
        },
        leading: Icon(query.isEmpty
            ? Icons.youtube_searched_for_rounded
            : Icons.picture_as_pdf_rounded),
        title: Text(suggestedFiles[index] as String),
      ),
      itemCount: suggestedFiles.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    for (int i = 0; i < files.length; i++) {
      pdfNames.add(Hive.box('pdfs').getAt(0)[i].split('/').last);
    }

    final int remove = (3 * pdfNames.length / 16).floor();

    pdfNames.removeRange(files.length, pdfNames.length);
    pdfNames = pdfNames.map((element) => element.toLowerCase()).toList();
    recentFiles = pdfNames.sublist(pdfNames.length - remove);

    final suggestedFiles = query.isEmpty
        ? recentFiles
        : pdfNames
            .where((p) => p.startsWith(query.toLowerCase()) as bool)
            .toList();

    // print(files.length);
    print(pdfNames);
    // print(suggestedFiles);

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          final String fileLocation =
              '${Hive.box('pdfs').getAt(0).where((element) => element.toString().split('/').last == suggestedFiles[index])}';
          print(fileLocation);

          final String fileLoc = fileLocation.split('(').last.split(')').first;

          // query = fileLoc.split('/').last;

          OpenFile.open(fileLoc);
        },
        leading: Icon(query.isEmpty
            ? Icons.youtube_searched_for_rounded
            : Icons.picture_as_pdf_rounded),
        title: Text(suggestedFiles[index] as String),
      ),
      itemCount: suggestedFiles.length,
    );
  }
}
