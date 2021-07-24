import 'dart:async';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:web_todolist/core/encrypter.dart';
import 'package:web_todolist/modules/auth/repositories/authentication_repository.dart';
import 'package:web_todolist/shared/extensions.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:web_todolist/core/network/network_info.dart';
import 'package:web_todolist/modules/notes/models/note.dart';
import 'package:web_todolist/modules/notes/widgets/drawer_canvas.dart';
import 'package:web_todolist/shared/constants.dart';

part 'add_new_note_state.dart';

final String NOTE_CACHE = "note_cache";
enum NoteMode { add, update }

class AddNewNoteCubit extends Cubit<AddNewNoteState> {
  AddNewNoteCubit({
    this.networkInfo,
    this.sharedPreferences,
    @required this.authRepository,
  }) : super(AddNewNoteState());
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  final AuthenticationRepository authRepository;
  NoteMode mode = NoteMode.add;
  Timer _debounce;

  onUpdatedNoteContentChanged(String v) {
    emit(state.copyWith(updatedNote: state.updatedNote.copyWith(content: v)));
    _onAutoUpdate();
  }

  onUpdatedNoteChanged(Note note) {
    emit(state.copyWith(updatedNote: note));
  }

  onDrawModeChanged(bool v) {
    emit(state.copyWith(isDrawMode: v));
  }

  onUpdatePoints(List<DrawingPoints> drawingPoints, {bool initial = false}) {
    emit(state.copyWith(drawing: drawingPoints));
    if (initial) return;
    _onAutoUpdate();
  }

  _onAutoUpdate() {
    if (state.updatedNote == null) return;
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(seconds: 2), () {
      emit(state.copyWith(loading: FormzStatus.submissionInProgress));
      update(state.updatedNote);
    });
  }

  clear() {
    emit(
      state.copyWith(
        drawing: <DrawingPoints>[],
        isDrawMode: false,
        loading: FormzStatus.pure,
        updatedNote: null,
      ),
    );
  }

  update(Note note) async {
    emit(state.copyWith(loading: FormzStatus.submissionInProgress));

    try {
      List<DrawingPoint> drawing = _convertDrawingPoints();
      var newNote = note.copyWith(
        createdAt: DateTime.now().toIso8601String(),
        drawingPoints: state.drawing == null ? null : drawing,
        content: encryptor
            .encrypt(
              note.content,
              iv: encrypt.IV.fromLength(16),
            )
            .base64,
      );
      var notes;
      var rawNotes = await sharedPreferences.getString(NOTE_CACHE);
      if (rawNotes != null) {
        notes = noteFromJson(rawNotes);
      } else {
        notes = <Note>[];
      }
      notes = (notes as List<Note>).map((e) {
        if (e.id == note.id) {
          return note;
        }
        return e;
      }).toList();
      await sharedPreferences.setString(NOTE_CACHE, noteToJson(notes));
      if (!(await networkInfo.isConnected())) {
        emit(state.copyWith(loading: FormzStatus.submissionSuccess));
        emit(state.copyWith(loading: FormzStatus.pure));
        return;
      }
      await FirebaseFirestore.instance
          .collection(NOTE_REF)
          .doc(newNote.id)
          .update(newNote.toJson());
      mode = NoteMode.update;
      emit(state.copyWith(loading: FormzStatus.submissionSuccess));
      emit(state.copyWith(loading: FormzStatus.pure));
    } catch (e) {
      print(e);
      emit(state.copyWith(loading: FormzStatus.submissionFailure));
      emit(state.copyWith(loading: FormzStatus.pure));
    }
  }

  add(Note note) async {
    emit(state.copyWith(loading: FormzStatus.submissionInProgress));
    var id = Uuid().v4();
    try {
      List<DrawingPoint> drawing = _convertDrawingPoints();

      var newNote = note.copyWith(
          id: id,
          userId: authRepository.currentUser.id,
          content: encryptor
              .encrypt(note.content, iv: encrypt.IV.fromLength(16))
              .base64,
          createdAt: DateTime.now().toIso8601String(),
          drawingPoints: drawing);

      var notes;
      var rawNotes = await sharedPreferences.getString(NOTE_CACHE);
      if (rawNotes != null) {
        notes = noteFromJson(rawNotes);
      } else {
        notes = <Note>[];
      }
      notes.add(newNote);
      await sharedPreferences.setString(NOTE_CACHE, noteToJson(notes));
      if (!(await networkInfo.isConnected())) {
        emit(state.copyWith(loading: FormzStatus.submissionSuccess));
        emit(state.copyWith(loading: FormzStatus.pure));
        return;
      }
      await FirebaseFirestore.instance
          .collection(NOTE_REF)
          .add(newNote.toJson());
      mode = NoteMode.add;
      emit(state.copyWith(loading: FormzStatus.submissionSuccess));
      emit(state.copyWith(loading: FormzStatus.pure));
    } catch (e) {
      print(e);
      emit(state.copyWith(loading: FormzStatus.submissionFailure));
      emit(state.copyWith(loading: FormzStatus.pure));
    }
  }

  List<DrawingPoint> _convertDrawingPoints() {
    var drawing = state.drawing != null
        ? List<DrawingPoint>.from(state.drawing
            .map(
              (e) => e != null &&
                      e.paint != null &&
                      e.points != null &&
                      e.points.dx != null
                  ? DrawingPoint(
                      points: Points(
                        x: e.points.dx,
                        y: e.points.dy,
                      ),
                      paint: Paint(
                        color: e.paint.color.toHex(),
                        strokeWidth: e.paint.strokeWidth,
                      ),
                    )
                  : DrawingPoint(),
            )
            .toList())
        : <DrawingPoint>[];
    return drawing;
  }
}
