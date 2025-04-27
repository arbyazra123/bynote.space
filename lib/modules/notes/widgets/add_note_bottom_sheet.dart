import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/modules/notes/blocs/add_new_note/add_new_note_cubit.dart';
import 'package:web_todolist/modules/notes/models/note.dart';
import 'package:web_todolist/modules/notes/providers/drawing_provider.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';

import 'drawer_canvas.dart';

class AddNoteBottomSheet extends StatefulWidget {
  final Note note;
  final TextEditingController contentController;
  const AddNoteBottomSheet({Key key, this.note, this.contentController})
      : super(key: key);

  @override
  _AddNoteBottomSheetState createState() => _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState extends State<AddNoteBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    return BlocBuilder<AddNewNoteCubit, AddNewNoteState>(
      builder: (context, state) {
        return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            // height: state.isDrawMode ? null : 0,
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: theme.backgroundColor),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: Colors.pink,
                        ),
                        child: Checkbox(
                          value: state.isDrawMode,
                          onChanged: (v) {
                            context
                                .read<AddNewNoteCubit>()
                                .onDrawModeChanged(v);
                          },
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(2),
                          //   side: BorderSide(color: Colors.white, width: 0.5),
                          // ),

                          checkColor: Colors.white,
                          activeColor: Colors.pink,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "Draw Mode",
                        style: TextStyle(
                          color: theme.primaryColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    margin: EdgeInsets.only(top: 10),
                    height: state.isDrawMode ? null : 0,
                    child: Column(
                      children: [
                        _buildDrawingOptions(),
                        SizedBox(
                          height: 15,
                        ),
                        _buildDrawingOptionsVisibility(),
                      ],
                    ),
                  ),
                  widget.note == null
                      ? Container(
                          width: double.maxFinite,
                          height: 40,
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<AddNewNoteCubit>().add(
                                    Note(
                                      content: widget.contentController.text,
                                    ),
                                  );

                              Navigator.pop(context);
                              context.read<AddNewNoteCubit>().clear();
                            },
                            child: Center(
                              child: Text(
                                "Add new Note",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildDrawingOptionsVisibility() {
    return Consumer<DrawingProvider>(
      builder: (context, value, child) => Visibility(
        child: (value.selectedMode == SelectedMode.Color)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...List<Widget>.from(value.colors
                      .map((e) => InkWell(
                            onTap: () {
                              value.onSelectedColor(e);
                            },
                            child: ClipOval(
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                height: 36,
                                width: 36,
                                color: e,
                              ),
                            ),
                          ))
                      .toList()),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: value.pickerColor,
                              onColorChanged: (color) {
                                value.onPickerSelectedColor(color);
                              },
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Save'),
                              onPressed: () {
                                value.onSelectedColor(value.pickerColor);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: ClipOval(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          colors: [Colors.red, Colors.green, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                      ),
                    ),
                  )
                ],
                // children: getColorList(),
              )
            : Slider(
                value: (value.selectedMode == SelectedMode.StrokeWidth)
                    ? value.strokeWidth
                    : value.opacity,
                max: (value.selectedMode == SelectedMode.StrokeWidth)
                    ? 50.0
                    : 1.0,
                min: 0.0,
                onChanged: (val) {
                  if (value.selectedMode == SelectedMode.StrokeWidth)
                    value.onStrokeWidthChanged(val);
                  else
                    value.onOpacityChanged(val);
                }),
        visible: value.showBottomList,
      ),
    );
  }

  Widget _buildDrawingOptions() {
    return Consumer<DrawingProvider>(
      builder: (context, value, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildDrawingOptionItem(
            "Stroke",
            () {
              value.onStrokeOption();
            },
            Icons.album,
          ),
          _buildDrawingOptionItem(
            "Opacity",
            () {
              value.onOpacityOption();
            },
            Icons.opacity,
          ),
          _buildDrawingOptionItem(
            "Color",
            () {
              value.onColorOption();
            },
            Icons.color_lens,
          ),
          _buildDrawingOptionItem(
            "Undo",
            () {
              value.onUndo();
              context.read<AddNewNoteCubit>().onUpdatePoints(value.points);
            },
            Icons.undo,
          ),
          _buildDrawingOptionItem(
            "Clear",
            () {
              value.onClear();
              context.read<AddNewNoteCubit>().onUpdatePoints(value.points);
            },
            Icons.clear,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawingOptionItem(
      String title, VoidCallback onTap, IconData icon) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: theme.primaryColor,
            size: 18,
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            title,
            style: TextStyle(color: theme.primaryColor),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
