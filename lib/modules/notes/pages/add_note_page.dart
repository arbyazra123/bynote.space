import 'package:formz/formz.dart';
import 'package:web_todolist/modules/notes/blocs/add_new_note/add_new_note_cubit.dart';
import 'package:web_todolist/modules/notes/providers/drawing_provider.dart';
import 'package:web_todolist/modules/notes/widgets/add_note_bottom_sheet.dart';
import 'package:web_todolist/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cursor/flutter_cursor.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/components/theme_switcher.dart';
import 'package:web_todolist/modules/notes/models/note.dart' as n;
import 'package:web_todolist/modules/notes/widgets/drawer_canvas.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';
import 'package:web_todolist/shared/theme.dart';

class AddNewNotePage extends StatefulWidget {
  final n.Note note;
  AddNewNotePage({Key key, this.note}) : super(key: key);

  @override
  _AddNewNotePageState createState() => _AddNewNotePageState();
}

class _AddNewNotePageState extends State<AddNewNotePage> {
  final contentCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      contentCon.text = widget.note.content;
      context.read<AddNewNoteCubit>().onUpdatedNoteChanged(widget.note);
      var points = List<DrawingPoints>.from(
          widget.note.drawingPoints.map((n.DrawingPoint e) {
        if (e.paint == null) {
          return DrawingPoints();
        }
        var paint = Paint()
          ..color = HexColor.fromHex(e.paint.color)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = e.paint.strokeWidth;
        return DrawingPoints(
            paint: paint, points: Offset(e.points.x, e.points.y));
      })).toList();
      context.read<AddNewNoteCubit>().onUpdatePoints(points, initial: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    var borderSide = InputBorder.none;
    return WillPopScope(
      onWillPop: () async {
        context.read<AddNewNoteCubit>().clear();
        Provider.of<DrawingProvider>(context, listen: false).clearPoints();
        return true;
      },
      child: Scaffold(
        floatingActionButton: AddNoteBottomSheet(
          contentController: contentCon,
          note: widget.note,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: theme.primaryColor,
          ),
          title: Text(
            "Bynote",
            style: TextStyle(fontFamily: "Pacifico", color: theme.primaryColor),
          ),
          actions: [
            ThemeSwitcher(),
          ],
          backgroundColor: theme.backgroundColor,
          // elevation: 0,
        ),
        body: BlocBuilder<AddNewNoteCubit, AddNewNoteState>(
          builder: (context, state) {
            return Container(
              color: theme.backgroundColor,
              height: MediaQuery.of(context).size.height,
              width: double.maxFinite,
              padding: EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                  Center(
                    child: AnimatedContainer(
                      duration: Duration(
                        milliseconds: 500,
                      ),
                      height: state.loading == FormzStatus.submissionInProgress
                          ? 14
                          : 0,
                      width: state.loading == FormzStatus.submissionInProgress? 14:0,
                      child: Transform.scale(
                        scale: 0.5,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: state.isDrawMode
                          ? NeverScrollableScrollPhysics()
                          : AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.note == null
                                ? _buildHeader(theme, context)
                                : SizedBox(),
                            DrawerCanvas(
                              note: widget.note,
                              child: IgnorePointer(
                                ignoring: state.isDrawMode,
                                child: HoverCursor(
                                  cursor: state.isDrawMode
                                      ? Cursor.pointer
                                      : Cursor.text,
                                  child: TextFormField(
                                    enabled: !state.isDrawMode,
                                    controller: contentCon,
                                    readOnly: state.isDrawMode,
                                    style: TextStyle(color: theme.primaryColor),
                                    onChanged: (v) {
                                      if (widget.note != null) {
                                        context
                                            .read<AddNewNoteCubit>()
                                            .onUpdatedNoteContentChanged(v);
                                      }
                                    },
                                    minLines: 20,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        hintText:
                                            "Write or draw your Notes here...",
                                        alignLabelWithHint: true,
                                        labelStyle: TextStyle(
                                          color: theme.primaryColor.withOpacity(
                                            0.7,
                                          ),
                                        ),
                                        hintStyle: TextStyle(
                                          color: theme.primaryColor.withOpacity(
                                            0.5,
                                          ),
                                        ),
                                        border: borderSide,
                                        focusedBorder: borderSide,
                                        enabledBorder: borderSide,
                                        disabledBorder: borderSide),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(CustomTheme theme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.note != null ? "Update Note" : "Add new Note",
              style: TextStyle(
                color: theme.primaryColor.withOpacity(0.6),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AddNewNoteCubit>().clear();
              },
              icon: Icon(
                Icons.close,
                color: theme.primaryColor,
              ))
        ],
      ),
    );
  }
}
