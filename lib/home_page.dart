import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:paint_app/provider/brush_provider.dart';
import 'package:provider/provider.dart';
import './painter/drawing_helper.dart';
import 'dart:math' as math;

import 'models/brush.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Offset> _points = <Offset>[];
  AnimationController _controller;
  List<DrawingHelper> drawingHelper = [];
  double strokeWidth = 1;
  double eraserStroke = 1;
  double currentWidth = 1;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  List<IconData> icons = [
    Icons.arrow_back_rounded,
    Icons.cleaning_services,
    Icons.brush,
    Icons.remove,
    Icons.color_lens
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void tapAnywhere(BuildContext context) {
    FocusScope.of(context).requestFocus(
      FocusNode(),
    );
    _controller.reverse();
  }

  void fabOpenClose() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void fabAction(int index, BuildContext context) {
    if (index == 3) {
      drawingHelper.clear();
      _points.clear();
    } else if (index == 4) {
      void changeColor(Color color) {
        setState(() => pickerColor = color);
      }

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                  showLabel: true,
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else if (index == 2) {
      _scaffoldKey.currentState.openDrawer();
    } else if(index == 1) {
      setState(() {
        drawingHelper.add(DrawingHelper(
          points: _points.toList(),
          color: currentColor,
          strokeWidth: currentWidth,
        ));
        _points.clear();
        currentWidth = eraserStroke;
        currentColor = Colors.white;
      });
    } else {
      _points.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brushes = Provider.of<BrushProvider>(context, listen: true);
    List<Brush> brushList =
        brushes.brush.entries.map((entry) => entry.value).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: Drawer(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                'Eraser Stroke width',
                style: TextStyle(fontSize: 20),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red[700],
                  inactiveTrackColor: Colors.red[100],
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Colors.redAccent,
                  overlayColor: Colors.red.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.red[700],
                  inactiveTickMarkColor: Colors.red[100],
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.redAccent,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  value: eraserStroke,
                  min: 1,
                  max: 30,
                  divisions: 30,
                  label: '${eraserStroke.round()}',
                  onChanged: (v) {
                    setState(
                      () {
                        eraserStroke = v;
                      },
                    );
                  },
                ),
              ),
              Text(
                'Add Stroke width',
                style: TextStyle(fontSize: 20),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red[700],
                  inactiveTrackColor: Colors.red[100],
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Colors.redAccent,
                  overlayColor: Colors.red.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.red[700],
                  inactiveTickMarkColor: Colors.red[100],
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.redAccent,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  value: strokeWidth,
                  min: 1,
                  max: 30,
                  divisions: 30,
                  label: '${strokeWidth.round()}',
                  onChanged: (v) {
                    setState(
                      () {
                        strokeWidth = v;
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    drawingHelper.add(DrawingHelper(
                      points: _points.toList(),
                      color: currentColor,
                      strokeWidth: currentWidth,
                    ));
                    _points.clear();
                    currentColor = pickerColor;
                    currentWidth = strokeWidth;
                  });
                  brushes.addBrush(
                      currentWidth, currentColor, DateTime.now().toString());
                },
                child: Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    primary: Colors.blueGrey),
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                //height: 550,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: brushList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            drawingHelper.add(
                              DrawingHelper(
                                points: _points.toList(),
                                color: brushList[index].color,
                                strokeWidth: brushList[index].strokeWidth,
                              ),
                            );
                            currentColor =  brushList[index].color;
                            strokeWidth =  brushList[index].strokeWidth;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 5),
                          child: Center(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.brush,
                                  color: pickerColor == Colors.white
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Stroke Width: ${brushList[index].strokeWidth.round()}',
                                  style: TextStyle(
                                      color: pickerColor == Colors.white
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ],
                            ),
                          ),
                          color: brushList[index].color,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => tapAnywhere(context),
        child: Container(
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                RenderBox object = context.findRenderObject();
                Offset _localPosition =
                    object.globalToLocal(details.globalPosition);
                _points = List.from(_points)..add(_localPosition);
              });
            },
            onPanEnd: (DragEndDetails details) => _points.add(null),
            child: CustomPaint(
              painter: DrawingHelper(
                  points: _points,
                  color: currentColor,
                  strokeWidth: currentWidth,
                  drawingHelper: drawingHelper),
              size: Size.infinite,
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(icons.length, (index) {
          Widget child = Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(0.0, 1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.black,
                mini: true,
                child: Icon(icons[index], color: Colors.white),
                onPressed: () => fabAction(index, context),
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            FloatingActionButton(
              backgroundColor: Colors.black,
              heroTag: null,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform(
                    transform:
                        Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: Icon(
                      _controller.isDismissed ? Icons.add : Icons.close,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              onPressed: fabOpenClose,
            ),
          ),
      ),
    );
  }
}
