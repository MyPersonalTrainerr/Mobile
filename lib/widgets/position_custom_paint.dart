import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_personal_trainer/models/position_painter.dart';
import 'package:http/http.dart' as http;
import 'package:my_personal_trainer/value_notifiers/value_notifiers.dart';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:provider/provider.dart';

class PositionCustomPaint extends StatefulWidget {
  @override
  State<PositionCustomPaint> createState() => _PositionCustomPaintState();
}

class _PositionCustomPaintState extends State<PositionCustomPaint> {
  bool _uploaded = false;
  // List<Offset> _frame = [];
  // List<Offset> jsonList = [];
  bool _drawing = false;

  // var positionPainter = PositionPainter([]);

  @override
  void dispose() {
    drawing.dispose();
    // frame.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    // await getData(width, height, context);
    return ValueListenableBuilder(
      valueListenable: frame,
      builder: (BuildContext context, List<Offset> _frame, __) {
        print("current frame is $_frame");
        print("drawing in widget is ${drawing.value}");
        if (drawing.value) {
          return CustomPaint(
            child: Container(
              width: width,
              height: height,
            ),
            painter: PositionPainter(_frame),
          );
        } else {
          return Container();
        }
      },
    );
  }
}


