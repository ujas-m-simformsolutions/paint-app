import 'package:flutter/cupertino.dart';
import 'package:paint_app/painter/drawing_helper.dart';

class Brush{
  final Color color;
  final double strokeWidth;
  final String id;
  final DrawingHelper drawingHelper;

  Brush({this.strokeWidth,this.color,this.id,this.drawingHelper});
}