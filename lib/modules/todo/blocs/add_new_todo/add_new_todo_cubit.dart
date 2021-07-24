import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:web_todolist/core/encrypter.dart';
import 'package:web_todolist/core/network/network_info.dart';
import 'package:web_todolist/modules/auth/repositories/authentication_repository.dart';
import 'package:web_todolist/modules/todo/blocs/get_todo/get_todo_bloc.dart';
import 'package:web_todolist/modules/todo/models/todo.dart';
import 'package:web_todolist/shared/constants.dart';

part 'add_new_todo_state.dart';

class AddNewTodoCubit extends Cubit<AddNewTodoState> {
  AddNewTodoCubit({
    this.networkInfo,
    @required this.authRepository, 
    this.sharedPreferences,
  }) : super(AddNewTodoState());
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  final AuthenticationRepository authRepository;
  onImprotantChanged(bool v) {
    emit(state.copyWith(isImportant: v));
  }

  onTimeChanged(DateTime v) {
    emit(state.copyWith(time: v));
  }

  add(Todo todo) async {
    emit(state.copyWith(loading: FormzStatus.submissionInProgress));
    var id = Uuid().v4();
    var newTodo = todo.copyWith(
      id: id,
      important: state.isImportant,
      content: encryptor.encrypt(todo.content,iv: encrypt.IV.fromLength(16)).base64,
      userId: authRepository.currentUser.id,
      time: state.time.toIso8601String(),
    );
    try {
      var todos;
      var rawTodos = await sharedPreferences.getString(TODO_CACHE);
      if (rawTodos != null) {
        todos = todoFromJson(rawTodos);
      } else {
        todos = <Todo>[];
      }
      todos.add(newTodo);
      await sharedPreferences.setString(TODO_CACHE, todoToJson(todos));
      if (!(await networkInfo.isConnected())) {
        emit(state.copyWith(loading: FormzStatus.submissionSuccess));
        emit(state.copyWith(loading: FormzStatus.pure));
        return;
      }
      await FirebaseFirestore.instance
          .collection(TODO_REF)
          .add(newTodo.toJson());
      emit(state.copyWith(loading: FormzStatus.submissionSuccess));
      emit(state.copyWith(loading: FormzStatus.pure));
    } catch (e) {
      emit(state.copyWith(loading: FormzStatus.submissionFailure));
      emit(state.copyWith(loading: FormzStatus.pure));
    }
  }
}
