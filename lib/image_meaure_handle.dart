import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:provider/provider.dart';
import 'package:image_size_getter/image_size_getter.dart' as image_size;

import './image_view.dart';
import './providers/image_list.dart';
import './providers/theme_provider.dart';

class ImageMeasureHandle extends StatefulWidget {
  const ImageMeasureHandle({
    Key key,
    @required this.file,
    @required this.list,
  }) : super(key: key);

  final File file;
  final ImageList list;

  @override
  _ImageMeasureHandleState createState() => _ImageMeasureHandleState();
}

class _ImageMeasureHandleState extends State<ImageMeasureHandle> {
  bool _isInit = true;
  bool _isLoading = false;

  final GlobalKey _imageKey = GlobalKey();

  Offset topLeft;
  Offset topRight;
  Offset bottomRight;
  Offset bottomLeft;

  double _imageWidth;
  double _imageHeight;

  static const double _initialOffset = 15;

  image_size.Size imagePixelSize;

  MethodChannel channel = const MethodChannel('opencv');

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), _getInitialHandles);
    imagePixelSize = image_size.ImageSizeGetter.getSize(FileInput(widget.file));
  }

  void _getInitialHandles() {
    final RenderBox imageBox =
        _imageKey.currentContext.findRenderObject() as RenderBox;

    _imageWidth = imageBox.size.width;
    _imageHeight = imageBox.size.height;

    topLeft = const Offset(_initialOffset, _initialOffset);
    topRight = Offset(_imageWidth - _initialOffset, _initialOffset);
    bottomLeft = Offset(_initialOffset, _imageHeight - _initialOffset);
    bottomRight = Offset(
      _imageWidth - _initialOffset,
      _imageHeight - _initialOffset,
    );

    setState(() {
      _isInit = false;
    });
  }

  void _onPanStart(DragStartDetails details) {
    setHandlePositions(details.localPosition);
  }

  void _onPanDown(DragDownDetails details) {
    setHandlePositions(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setHandlePositions(details.localPosition);
  }

  void setHandlePositions(Offset localPosition) {
    final double x = localPosition.dx;
    final double y = localPosition.dy;

    if (sqrt((topLeft.dx - x) * (topLeft.dx - x) +
                (topLeft.dy - y) * (topLeft.dy - y)) <
            _initialOffset &&
        x >= 0 &&
        y >= 0 &&
        // x < _imageWidth / 2
        x < _imageWidth &&
        // y < _imageHeight / 2
        y < _imageHeight) {
      setState(() {
        topLeft = localPosition;
      });
      return;
    }

    if (sqrt((topRight.dx - x) * (topRight.dx - x) +
                (topRight.dy - y) * (topRight.dy - y)) <
            _initialOffset &&
        // x >= _imageWidth / 2
        x >= 0 &&
        y >= 0 &&
        x <= _imageWidth &&
        // y < _imageHeight / 2
        y <= _imageHeight) {
      setState(() {
        topRight = localPosition;
      });
      return;
    }

    if (sqrt((bottomLeft.dx - x) * (bottomLeft.dx - x) +
                (bottomLeft.dy - y) * (bottomLeft.dy - y)) <
            _initialOffset &&
        x >= 0 &&
        // y >= _imageHeight / 2 &&
        y >= 0 &&
        // x < _imageWidth / 2 &&
        x <= _imageWidth &&
        y <= _imageHeight) {
      setState(() {
        bottomLeft = localPosition;
      });
      return;
    }

    if (sqrt((bottomRight.dx - x) * (bottomRight.dx - x) +
                (bottomRight.dy - y) * (bottomRight.dy - y)) <
            _initialOffset &&
        // x >= _imageWidth / 2 &&
        x >= 0 &&
        // y >= _imageHeight / 2 &&
        y >= 0 &&
        x < _imageWidth &&
        y < _imageHeight) {
      setState(() {
        bottomRight = localPosition;
      });
      return;
    }
  }

  DarkThemeProvider themeChange;

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Border adjustment'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Stack(
                  children: [
                    GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanDown: _onPanDown,
                      child: Image.file(
                        widget.file,
                        key: _imageKey,
                      ),
                    ),
                    if (!_isInit)
                      CustomPaint(
                        painter: CropPainter(
                          topLeft: topLeft,
                          topRight: topRight,
                          bottomRight: bottomRight,
                          bottomLeft: bottomLeft,
                        ),
                      )
                  ],
                ),
              ),
            ),
            _buildBottomSheet,
          ],
        ),
      ),
    );
  }

  Widget get _buildBottomSheet => Container(
        color: themeChange.darkTheme ? Colors.black87 : Colors.blue[600],
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _bottomSheetButton(
                'Back',
                Icons.arrow_back,
                () => Navigator.of(context).pop(),
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                _bottomSheetButton(
                  'Crop and Next',
                  Icons.crop_free_sharp,
                  _isInit
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          final double widthRatio =
                              imagePixelSize.width / _imageWidth;

                          final double heightRatio =
                              imagePixelSize.height / _imageHeight;

                          final double tlX = widthRatio * topLeft.dx;
                          final double trX = widthRatio * topRight.dx;
                          final double blX = widthRatio * bottomLeft.dx;
                          final double brX = widthRatio * bottomRight.dx;

                          final double tlY = heightRatio * topLeft.dy;
                          final double trY = heightRatio * topRight.dy;
                          final double blY = heightRatio * bottomLeft.dy;
                          final double brY = heightRatio * bottomRight.dy;

                          print('invoking channel method');

                          await channel.invokeMethod('convertToGray', {
                            'filePath': widget.file.path,
                            'tl_x': tlX,
                            'tl_y': tlY,
                            'tr_x': trX,
                            'tr_y': trY,
                            'bl_x': blX,
                            'bl_y': blY,
                            'br_x': brX,
                            'br_y': brY,
                          }).then((value) {
                          print('finished channel method');

                            setState(() {
                              _isLoading = false;
                            });
                          });

                          // final originalBytes =
                          //     await channel.invokeMethod('originalCompleted');

                          // print(originalBytes.runtimeType);

                          setState(() {
                            _isLoading = false;
                          });

                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         Imageview(widget.file, widget.list),
                          //   ),
                          // );
                        },
                ),
              _bottomSheetButton(
                'Skip and Next',
                Icons.arrow_forward,
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Imageview(widget.file, widget.list),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _bottomSheetButton(
      String text, IconData icon, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
          ),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CropPainter extends CustomPainter {
  CropPainter({
    @required this.topLeft,
    @required this.topRight,
    @required this.bottomLeft,
    @required this.bottomRight,
  });

  final Offset topLeft;
  final Offset topRight;
  final Offset bottomLeft;
  final Offset bottomRight;

  final Paint _handleCornerPainter = Paint()
    ..color = Colors.blue
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 2
    ..style = PaintingStyle.fill;

  final Paint _handlePainter = Paint()
    ..color = Colors.blue
    ..strokeWidth = 3
    ..strokeCap = StrokeCap.round;

  final double _handleCornerRadius = 7;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(topLeft, _handleCornerRadius, _handleCornerPainter);
    canvas.drawCircle(topRight, _handleCornerRadius, _handleCornerPainter);
    canvas.drawCircle(bottomLeft, _handleCornerRadius, _handleCornerPainter);
    canvas.drawCircle(bottomRight, _handleCornerRadius, _handleCornerPainter);

    canvas.drawLine(topLeft, topRight, _handlePainter);
    canvas.drawLine(topRight, bottomRight, _handlePainter);
    canvas.drawLine(bottomRight, bottomLeft, _handlePainter);
    canvas.drawLine(bottomLeft, topLeft, _handlePainter);
  }

  @override
  bool shouldRepaint(CropPainter oldDelegate) =>
      oldDelegate.topLeft != topLeft ||
      oldDelegate.topRight != topRight ||
      oldDelegate.bottomRight != bottomRight ||
      oldDelegate.bottomLeft != bottomLeft;
}
