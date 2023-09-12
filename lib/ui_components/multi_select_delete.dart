import "dart:io";

import "package:doclense/configs/app_dimensions.dart";
import "package:doclense/configs/app_typography.dart";
import "package:doclense/configs/space.dart";
import "package:doclense/configs/ui.dart";
import "package:doclense/constants/appstrings.dart";
import "package:doclense/constants/route_constants.dart";
import "package:doclense/providers/image_list.dart";
import "package:doclense/ui_components/grid_item.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:gallery_saver/gallery_saver.dart";
import "package:image_picker/image_picker.dart";

class MultiDelete extends StatefulWidget {
  const MultiDelete(this.imageList, {super.key});
  final ImageList imageList;

  @override
  MultiDeleteState createState() => MultiDeleteState();
}

class MultiDeleteState extends State<MultiDelete> {
  List<Item>? itemList;
  List<Item>? selectedList;
  File? imageFile;
  final ImagePicker picker = ImagePicker();

  bool _isLoading = true;

  @override
  void initState() {
    loadList();
    super.initState();
  }

  void loadList() {
    itemList = <Item>[];
    selectedList = <Item>[];
    for (int i = 0; i < (widget.imageList.length()); i++) {
      itemList?.add(Item(widget.imageList.imagelist.elementAt(i), i));
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showChoiceDialogDel(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          title: Text(
            S.deleteSelected,
            textAlign: TextAlign.center,
            style: AppText.b1!.cl(Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      for (int i = 0; i < selectedList!.length; i++) {
                        final int idx = widget.imageList.imagelist.indexOf(
                          itemList![itemList!.indexOf(selectedList![i])]
                              .imageUrl,
                        );
                        widget.imageList.imagelist.removeAt(idx);
                        widget.imageList.imagepath.removeAt(idx);
                        itemList!.remove(selectedList![i]);
                      }
                      selectedList = <Item>[];
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    S.yes,
                    textAlign: TextAlign.center,
                    style: AppText.b1!.cl(Colors.white),
                  ),
                ),
                Space.y!,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.no,
                    textAlign: TextAlign.center,
                    style: AppText.b1!.cl(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _showChoiceDialogHome(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          title: Text(
            S.deleteWarning,
            textAlign: TextAlign.center,
            style: AppText.b1!.cl(Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    for (int i = 0; i < itemList!.length; i++) {
                      debugPrint("i = $i");
                      debugPrint(widget.imageList.imagelist.length.toString());
                      final int idx = widget.imageList.imagelist.indexOf(
                        itemList![itemList!.indexOf(itemList![i])].imageUrl,
                      );
                      widget.imageList.imagelist.removeAt(idx);
                      widget.imageList.imagepath.removeAt(idx);
                      // itemList.remove(idx);
                      itemList!.removeAt(idx);
                    }

                    Navigator.of(context)
                        // ignore: always_specify_types
                        .popUntil((Route route) => route.isFirst);
                  },
                  child: Text(
                    S.yes,
                    textAlign: TextAlign.center,
                    style: AppText.b1!.cl(Colors.white),
                  ),
                ),
                Space.y!,
                GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    S.no,
                    textAlign: TextAlign.center,
                    style: AppText.b1!.cl(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _openGallery() async {
    final XFile? picture = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
      }
    });
    if (imageFile != null) {
      // ignore: use_build_context_synchronously
      await Navigator.of(context).pushNamed(
        RouteConstants.imageView,
        arguments: <String, Object?>{
          "imageFile": imageFile,
          "imageList": widget.imageList,
        },
      );
    }
  }

  Future<void> _openCamera() async {
    final XFile? picture = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
      }
    });

    if (imageFile != null) {
      await GallerySaver.saveImage(imageFile!.path)
          .then((bool? value) => debugPrint("Image Saved"))
          .whenComplete(() async {
        await Navigator.of(context).pushNamed(
          RouteConstants.imageView,
          arguments: <String, Object?>{
            "imageFile": imageFile,
            "imageList": widget.imageList,
          },
        );
      });
    }
  }

  Future<void> _showChoiceDialogAdd(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          title: Text(
            S.addMorePages,
            textAlign: TextAlign.center,
            style: AppText.b1!.cl(Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _openGallery();
                  },
                  child: Text(
                    S.gallery,
                    style: AppText.b1!.cl(Colors.white),
                  ),
                ),
                Space.y!,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _openCamera();
                  },
                  child: Text(
                    S.camera,
                    style: AppText.b1!.cl(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (itemList!.isNotEmpty) {
            setState(() {
              widget.imageList.imagelist.removeAt(itemList!.length - 1);
              widget.imageList.imagepath.removeAt(itemList!.length - 1);
              itemList!.removeAt(itemList!.length - 1);
            });
          }
          return true;
        },
        child: Scaffold(
          // backgroundColor: Colors.blueGrey[100],
          appBar: getAppBar(),
          body: _isLoading
              ? const SpinKitRotatingCircle(
                  color: Colors.blue,
                )
              : GridView.builder(
                  itemCount: itemList!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: UI.width! >= 640 ? 3 : 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) => Card(
                    elevation: 10,
                    child: GridItem(
                      item: itemList![index],
                      isSelected: (bool value) {
                        setState(() {
                          if (value) {
                            selectedList!.add(itemList![index]);
                          } else {
                            selectedList!.remove(itemList![index]);
                          }
                        });
                        debugPrint("$index : $value");
                      },
                      key: Key(itemList![index].rank.toString()),
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await _showChoiceDialogAdd(context);
            },
            child: Icon(
              Icons.add,
              size: AppDimensions.font(18),
            ),
          ),
        ),
      );

  AppBar getAppBar() => AppBar(
        leading: IconButton(
          onPressed: () {
            if (itemList!.isNotEmpty) {
              setState(() {
                widget.imageList.imagelist.removeAt(itemList!.length - 1);
                widget.imageList.imagepath.removeAt(itemList!.length - 1);
                itemList!.removeAt(itemList!.length - 1);
              });
            }
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          selectedList!.isEmpty
              ? S.documents
              : "${selectedList!.length} item selected",
        ),
        actions: <Widget>[
          if (selectedList!.isEmpty)
            Container()
          else
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _showChoiceDialogDel(context);
              },
            ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              await Navigator.of(context).pushNamed(
                RouteConstants.pdfConversionScreen,
                arguments: widget.imageList,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () async {
              await _showChoiceDialogHome(context);
            },
          ),
        ],
      );
}

class Item {
  Item(this.imageUrl, this.rank);
  File imageUrl;
  int rank;
}
