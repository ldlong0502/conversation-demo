import 'package:flutter/material.dart';

import '../../../configs/app_color.dart';
import '../../../utils/split_text.dart';
import 'package:path_drawing/path_drawing.dart';

class CustomPaintKanji extends CustomPainter {
  final String stringPath;

  const CustomPaintKanji({Key? key, required this.stringPath});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.whiteAccent1
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Define the path data
    final listStringPath = SplitText().extractPathDataList(stringPath);
    int count = 1;
    canvas.scale(2, 1.8);
    for (var i in listStringPath) {
      var path = parseSvgPathData(i);
      // final center = path.getBounds().topLeft;

      path = path.shift(const Offset(0, 0));

      canvas.drawPath(path, paint);
      TextSpan span = TextSpan(
        style: const TextStyle(fontSize: 8, color: Colors.black),
        text: (count++).toString(),
      );

      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      // final numberOffset = Offset(center.dx, center.dy);
      // tp.paint(canvas,  numberOffset);
    }
    // Create a Path object from the data
  }

  @override
  bool shouldRepaint(CustomPaintKanji oldDelegate) {
    return true;
  }
}
