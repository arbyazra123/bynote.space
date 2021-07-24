import 'package:web_todolist/modules/notes/blocs/add_new_note/add_new_note_cubit.dart';
import 'package:web_todolist/modules/notes/models/note.dart' as n;
import 'package:web_todolist/modules/notes/providers/drawing_provider.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';
import 'package:web_todolist/shared/theme.dart';

class DrawerCanvas extends StatefulWidget {
  final Widget child;
  final n.Note note;
  const DrawerCanvas({Key key, this.child, this.note}) : super(key: key);
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<DrawerCanvas> {
  final containerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (context.read<AddNewNoteCubit>().state.drawing.length > 0) {
        if (widget.note != null) {
          Provider.of<DrawingProvider>(context, listen: false)
              .onPointsCopyWith(context.read<AddNewNoteCubit>().state.drawing);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    return BlocBuilder<AddNewNoteCubit, AddNewNoteState>(
      builder: (context, state) {
        return _buildBody(theme, context, state);
      },
    );
  }

  Widget _buildBody(
      CustomTheme theme, BuildContext context, AddNewNoteState state) {
    return Consumer<DrawingProvider>(
      builder: (context, value, child) => Container(
        color: theme.backgroundColor,
        child: Column(
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                value.onDraw(details.globalPosition, context);
                // context.read<AddNewNoteCubit>().onUpdatePoints(
                //       value.points,
                //       initial: widget.note==null
                //     );
              },
              onPanStart: (details) {
                value.onDraw(details.globalPosition, context);
                context.read<AddNewNoteCubit>().onUpdatePoints(
                      value.points,
                      initial: widget.note==null
                    );
              },
              onPanEnd: (details) {
                value.onDraw(null, context);
                context.read<AddNewNoteCubit>().onUpdatePoints(
                      value.points,
                      initial: widget.note==null
                    );
              },
              child: CustomPaint(
                size: Size.infinite,
                child: Container(
                  key: containerKey,
                  child: widget.child,
                ),
                painter: DrawingPainter(
                  pointsList: state.drawing,
                ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});
  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = <Offset>[];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null &&
          pointsList[i].paint != null &&
          pointsList[i + 1] != null &&
          pointsList[i + 1].paint != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null &&
          pointsList[i].paint != null &&
          pointsList[i + 1] == null &&
          pointsList[i + 1].paint == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({this.points, this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
