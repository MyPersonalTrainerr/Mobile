import 'dart:ui';

import "package:flutter/material.dart";

class PositionPainter extends CustomPainter {
  List<Offset> offsets;
  PositionPainter(this.offsets) : super();

  @override
  void paint(Canvas canvas, Size size) {
    print('painting');
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(offsets[20], offsets[18], paint);
    canvas.drawLine(offsets[18], offsets[16], paint);
    canvas.drawLine(offsets[16], offsets[22], paint);
    canvas.drawLine(offsets[16], offsets[20], paint);
    canvas.drawLine(offsets[16], offsets[14], paint);
    canvas.drawLine(offsets[14], offsets[12], paint);
    canvas.drawLine(offsets[12], offsets[11], paint);
    canvas.drawLine(offsets[12], offsets[24], paint);
    canvas.drawLine(offsets[24], offsets[23], paint);
    canvas.drawLine(offsets[24], offsets[26], paint);
    canvas.drawLine(offsets[26], offsets[28], paint);
    canvas.drawLine(offsets[28], offsets[30], paint);
    canvas.drawLine(offsets[28], offsets[32], paint);
    canvas.drawLine(offsets[32], offsets[30], paint);
    canvas.drawLine(offsets[11], offsets[13], paint);
    canvas.drawLine(offsets[13], offsets[15], paint);
    canvas.drawLine(offsets[15], offsets[21], paint);
    canvas.drawLine(offsets[15], offsets[17], paint);
    canvas.drawLine(offsets[17], offsets[19], paint);
    canvas.drawLine(offsets[19], offsets[15], paint);
    canvas.drawLine(offsets[11], offsets[23], paint);
    canvas.drawLine(offsets[23], offsets[25], paint);
    canvas.drawLine(offsets[25], offsets[27], paint);
    canvas.drawLine(offsets[27], offsets[29], paint);
    canvas.drawLine(offsets[27], offsets[31], paint);
    canvas.drawLine(offsets[29], offsets[31], paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
