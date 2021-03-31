import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'providers/image_list.dart';

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

  final GlobalKey _imageKey = GlobalKey();

  Offset topLeft;
  Offset topRight;
  Offset bottomRight;
  Offset bottomLeft;

  double _imageWidth;
  double _imageHeight;

  static const double _initialOffset = 20;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), _getInitialHandles);
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
        x < _imageWidth / 2 &&
        y < _imageHeight / 2) {
      setState(() {
        topLeft = localPosition;
      });
      return;
    }

    if (sqrt((topRight.dx - x) * (topRight.dx - x) +
                (topRight.dy - y) * (topRight.dy - y)) <
            _initialOffset &&
        x >= _imageWidth / 2 &&
        y >= 0 &&
        x < _imageWidth &&
        y < _imageHeight / 2) {
      setState(() {
        topRight = localPosition;
      });
      return;
    }

    if (sqrt((bottomLeft.dx - x) * (bottomLeft.dx - x) +
                (bottomLeft.dy - y) * (bottomLeft.dy - y)) <
            _initialOffset &&
        x >= 0 &&
        y >= _imageHeight / 2 &&
        x < _imageWidth / 2 &&
        y < _imageHeight) {
      setState(() {
        bottomLeft = localPosition;
      });
      return;
    }

    if (sqrt((bottomRight.dx - x) * (bottomRight.dx - x) +
                (bottomRight.dy - y) * (bottomRight.dy - y)) <
            _initialOffset &&
        x >= _imageWidth / 2 &&
        y >= _imageHeight / 2 &&
        x < _imageWidth &&
        y < _imageHeight) {
      setState(() {
        bottomRight = localPosition;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GestureDetector(
            onPanUpdate: _onPanUpdate,
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
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
