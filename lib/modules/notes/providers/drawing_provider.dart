import 'package:flutter/material.dart';
import 'package:web_todolist/modules/notes/widgets/drawer_canvas.dart';

class DrawingProvider extends ChangeNotifier {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  Size heightOfChild = Size.infinite;
  List<DrawingPoints> points = <DrawingPoints>[];
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];

  clearPoints(){
    points= <DrawingPoints>[];
    notifyListeners();
  }

  onPointsCopyWith(List<DrawingPoints> points) {
    this.points=points;
    notifyListeners();
  }

  onDraw(Offset offset, BuildContext context) {
    if (offset == null) {
      points.add(DrawingPoints());
      notifyListeners();
      return;
    }
    RenderBox renderBox = context.findRenderObject();
    points.add(DrawingPoints(
        points: renderBox.globalToLocal(offset),
        paint: Paint()
          ..strokeCap = strokeCap
          ..isAntiAlias = true
          ..color = selectedColor.withOpacity(opacity)
          ..strokeWidth = strokeWidth));
    notifyListeners();
  }

  onStrokeOption() {
    if (selectedMode == SelectedMode.StrokeWidth)
      showBottomList = !showBottomList;
    selectedMode = SelectedMode.StrokeWidth;
    notifyListeners();
  }

  onOpacityOption() {
    if (selectedMode == SelectedMode.Opacity) showBottomList = !showBottomList;
    selectedMode = SelectedMode.Opacity;
    notifyListeners();
  }

  onColorOption() {
    if (selectedMode == SelectedMode.Color) showBottomList = !showBottomList;
    selectedMode = SelectedMode.Color;
    notifyListeners();
  }

  onUndo() {
    showBottomList = false;
    if (points.length > 20) {
      points.removeRange(points.length - 16, points.length - 1);
    } else if (points.length > 10) {
      points.removeRange(points.length - 11, points.length - 1);
    } else if (points.length > 5) {
      points.removeRange(points.length - 6, points.length - 1);
    } else {
      points.removeLast();
    }
    notifyListeners();
  }

  onClear() {
    showBottomList = false;
    points.clear();
    notifyListeners();
  }

  onAddColor(Color color) {
    colors.add(color);
    notifyListeners();
  }

  onSelectedColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  onPickerSelectedColor(Color color) {
    pickerColor = color;
    notifyListeners();
  }

  onStrokeWidthChanged(double val) {
    strokeWidth = val;
    notifyListeners();
  }

  onOpacityChanged(double val) {
    opacity = val;
    notifyListeners();
  }
}
