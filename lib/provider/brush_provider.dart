import 'package:flutter/material.dart';
import 'package:paint_app/models/brush.dart';

class BrushProvider extends ChangeNotifier {
  Map<String, Brush> _brush = {};
  Map<String, Brush> get brush => _brush;

  int get brushCount => _brush.length;

  void addBrush(double strokeWidth, Color color, String id) {
    if (_brush.containsKey(strokeWidth)) {
      _brush.update(
        id,
        (value) => Brush(color: color, id: id, strokeWidth: strokeWidth),
      );
      notifyListeners();
    } else {
      _brush.putIfAbsent(
        id,
        () => Brush(
            strokeWidth: strokeWidth,
            id: DateTime.now().toString(),
            color: color),
      );
      notifyListeners();
    }
  }
}
