import "dart:io";

import "package:doclense/constants/route_constants.dart";
import "package:doclense/providers/image_list.dart";
import "package:doclense/screens/about.dart";
import "package:doclense/screens/home.dart";
import "package:doclense/screens/pdf_preview_screen.dart";
import "package:doclense/screens/settings/contact_developers.dart";
import "package:doclense/screens/settings/settings.dart";
import "package:doclense/screens/starred_documents.dart";
import "package:doclense/ui_components/image_view.dart";
import "package:doclense/ui_components/multi_select_delete.dart";
import "package:doclense/ui_components/pdf_conversion.dart";
import "package:flutter/material.dart";
// import 'package:folder_picker/folder_picker.dart';
import "package:image/image.dart" as image_lib;
import "package:photofilters/photofilters.dart";

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteConstants.homeScreen:
      return pageBuilder(
        screen: const HomeScreen(),
      );
    case RouteConstants.settingsScreen:
      return pageBuilder(
        screen: const SettingsScreen(),
      );
    case RouteConstants.starredDocumentsScreen:
      return pageBuilder(
        screen: const Starred(),
      );
    case RouteConstants.aboutAppScreen:
      return pageBuilder(
        screen: const About(),
      );
    case RouteConstants.multiDelete:
      final ImageList args = settings.arguments! as ImageList;
      return pageBuilder(
        screen: MultiDelete(args),
      );

    case RouteConstants.imageView:
      final Map<String, Object> args =
          settings.arguments! as Map<String, Object>;
      return pageBuilder(
        screen: Imageview(
          args["imageFile"]! as File,
          args["imageList"]! as ImageList,
        ),
      );
    case RouteConstants.contactDeveloperScreen:
      return pageBuilder(
        screen: const ContactDeveloperScreen(),
      );
    case RouteConstants.photoFilterSelector:
      final Map<String, Object> args =
          settings.arguments! as Map<String, Object>;
      return pageBuilder(
        screen: PhotoFilterSelector(
          title: args["title"]! as Widget,
          filters: args["filters"]! as List<Filter>,
          image: args["image"]! as image_lib.Image,
          filename: args["fileName"]! as String,
          fit: args["fit"]! as BoxFit,
          appBarColor: args["appBarColor"]! as Color,
          loader: args["loader"]! as Widget,
        ),
      );
    case RouteConstants.pdfConversionScreen:
      final ImageList args = settings.arguments! as ImageList;
      return pageBuilder(
        screen: PDFConversion(args),
      );
    case RouteConstants.pdfPreviewScreen:
      final Map<String, Object> args =
          settings.arguments! as Map<String, Object>;
      return pageBuilder(
        screen: PdfPreviewScreen(
          path: args["path"]! as String,
          name: args["name"]! as String,
        ),
      );
    // case RouteConstants.folderPickerPage:
    //   final args = settings.arguments as Map;
    //   return pageBuilder(
    //     screen: FolderPickerPage(
    //       action:
    //           args['action'] as Future<void>
    //    Function(BuildContext, Directory),
    //       rootDirectory: args['rootDirectory'] as Directory,
    //     ),
    //   );
    default:
      return pageBuilder(
        screen: const Text(
          "Unknown Screen. Please restart the app.",
          textAlign: TextAlign.center,
        ),
      );
  }
}

PageRouteBuilder<dynamic> pageBuilder({
  required Widget screen,
}) =>
    PageRouteBuilder<dynamic>(
      pageBuilder:
          (BuildContext c, Animation<double> a1, Animation<double> a2) =>
              screen,
      transitionsBuilder: (
        BuildContext c,
        Animation<double> anim,
        Animation<double> a2,
        Widget child,
      ) =>
          FadeTransition(opacity: anim, child: child),
    );
