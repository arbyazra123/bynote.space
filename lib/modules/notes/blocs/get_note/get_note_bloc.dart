import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_todolist/core/encrypter.dart';
import 'package:web_todolist/core/network/network_info.dart';
import 'package:web_todolist/modules/auth/repositories/authentication_repository.dart';
import 'package:web_todolist/modules/notes/blocs/add_new_note/add_new_note_cubit.dart';
import 'package:web_todolist/modules/notes/models/note.dart';
import 'package:web_todolist/shared/constants.dart';

part 'get_note_event.dart';
part 'get_note_state.dart';

class GetNoteBloc extends Bloc<GetNoteEvent, GetNoteState> {
  GetNoteBloc({
    this.networkInfo,
    this.sharedPreferences,
    @required this.authRepository,
  }) : super(GetNoteInitial());
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  final AuthenticationRepository authRepository;
  @override
  Stream<GetNoteState> mapEventToState(
    GetNoteEvent event,
  ) async* {
    if (event is GetNote) {
      yield* _mapGetNoteToState();
    }
  }

  Stream<GetNoteState> _mapGetNoteToState() async* {
    yield GetNoteLoading();
    try {
      if (!(await networkInfo.isConnected())) {
        var todos = await sharedPreferences.getString(NOTE_CACHE);
        if (todos == null) {
          yield GetNoteLoaded([]);
        }
        yield GetNoteLoaded(noteFromJson(todos));
        return;
      }
      var rawTodos = await FirebaseFirestore.instance
          .collection(NOTE_REF)
          .where(
            "userId",
            isEqualTo: authRepository.currentUser.id,
          )
          .get();
      if (rawTodos.size == 0) {
        yield GetNoteLoaded([]);
        return;
      }
      var todos = rawTodos.docs
          .map(
            (e) => Note.fromJson(e.data()).copyWith(
              id: e.id,
              content: encryptor.decrypt64(
                e.data()['content'],
                iv: encrypt.IV.fromLength(16),
              ),
            ),
          )
          .toList();
      todos.sort((b, a) =>
          DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));
      await sharedPreferences.setString(NOTE_CACHE, noteToJson(todos));
      yield GetNoteLoaded(todos);
    } catch (e) {
      print(e);
      yield GetNoteError();
    }
  }
}
