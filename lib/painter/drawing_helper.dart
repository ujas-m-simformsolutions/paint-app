import 'package:flutter/material.dart';
import '.././home_page.dart';
class DrawingHelper extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final List<DrawingHelper> drawingHelper;
  HomePage homePage;
  DrawingHelper({this.points,this.color,this.strokeWidth,this.drawingHelper= const []});

  @override
  void paint(Canvas canvas, Size size) {
    for(var helper in drawingHelper){
      helper.paint(canvas,size);
    }
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingHelper oldDelegate) => oldDelegate.points != points;
}
