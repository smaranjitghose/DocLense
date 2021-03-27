import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CropPainter extends CustomPainter {
  Offset tl, tr, bl, br;
  CropPainter(this.tl, this.tr, this.bl, this.br);
  Paint painter = Paint()
    ..color = Colors.blue
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..style=PaintingStyle.stroke;
  Paint painter1 = Paint()
    ..color = Colors.blue
    ..strokeWidth = 3
    ..strokeCap = StrokeCap.round;
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    canvas.drawCircle(tl, 10, painter);
    canvas.drawCircle(tr, 10, painter);
    canvas.drawCircle(bl, 10, painter);
    canvas.drawCircle(br, 10, painter);
    canvas.drawLine(tl,tr, painter1);
    canvas.drawLine(tr,br, painter1);
    canvas.drawLine(br,bl, painter1);
    canvas.drawLine(bl,tl, painter1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
