import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'Providers/image_list.dart';
import 'image_view.dart';

import 'package:image_picker/image_picker.dart';

class PhotoCapture extends StatefulWidget {
  PhotoCapture();

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<PhotoCapture> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  String albumName = 'Media';
  ImageList images;

  @override
  void initState() {
    super.initState();
    images = ImageList();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future<void> _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller =
        CameraController(cameraDescription, ResolutionPreset.ultraHigh);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: FloatingActionButton(
                heroTag: '1',
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
                onPressed: _onSwitchCamera,
                child: Icon(Icons.flip_camera_android_rounded),
              ),
            ),
            Expanded(
              child: FloatingActionButton(
                heroTag: '2',
                backgroundColor: Colors.white10,
                onPressed: () {
                  _onCapturePressed(context);
                },
                child: Icon(Icons.camera_alt),
              ),
            ),
            Expanded(
              child: FloatingActionButton(
                heroTag: '3',
                backgroundColor: Colors.white10,
                onPressed: () async {
                  Navigator.pop(context);
                  final PickedFile imageFile =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  if (imageFile == null) return;
                  final File tmpFile = File(imageFile.path);

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Imageview(tmpFile, images)));
                },
                child: Icon(
                  Icons.image_rounded,
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: _cameraPreviewWidget(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Display Camera preview.
  Widget _cameraPreviewWidget(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading....',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return ClipRect(
        child: OverflowBox(
      alignment: Alignment.center,
      child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height /
                      controller.value.aspectRatio) -
                  200,
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller),
              ))),
    ));

    // return AspectRatio(
    //   aspectRatio: controller.value.aspectRatio,
    //   child: CameraPreview(controller),
    // );
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    _initCameraController(selectedCamera);
  }

  void _onCapturePressed(context) async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Attempt to take a picture and log where it's been saved
      Directory directory = await getExternalStorageDirectory();
      print(directory.path);
      final path = join(
        // In this example, store the picture in the temp directory. Find
        // the temp directory using the `path_provider` plugin.
        directory.path,
        '${DateTime.now()}.png',
      );
      print(path);
      await controller.takePicture(path);

      setState(() {
        controller.dispose();

        GallerySaver.saveImage(
          path,
        ).then((bool success) {
          setState(() {
            print(path);
          });
        });
      });

      // If the picture was taken, display it on a new screen
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Imageview(File(path), images),
        ),
      );
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    print('Error: ${e.code}\n${e.description}');
  }
}
