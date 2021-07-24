import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_todolist/core/network/network_info.dart';
import 'package:web_todolist/modules/auth/repositories/authentication_repository.dart';
import 'package:web_todolist/modules/todo/blocs/get_todo/get_todo_bloc.dart';
import 'package:web_todolist/modules/todo/models/todo.dart';
import 'package:web_todolist/shared/constants.dart';

part 'update_todo_state.dart';

class UpdateTodoCubit extends Cubit<UpdateTodoState> {
  UpdateTodoCubit({
    this.networkInfo,
    this.sharedPreferences,
    @required this.authRepository, 
  }) : super(UpdateTodoState());
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  final AuthenticationRepository authRepository;

  checkTodo(String id, bool updateStatus) async {
    var rawTodos = todoFromJson(await sharedPreferences.getString(TODO_CACHE));
    var todos = rawTodos.map((e) {
      if (e.id == id) {
        var updated = e.copyWith(done: updateStatus);
        return updated;
      }
      return e;
    }).toList();
    await sharedPreferences.setString(TODO_CACHE, todoToJson(todos));
    if (!(await networkInfo.isConnected())) {
      emit(state.copyWith(loading: FormzStatus.submissionSuccess));
      emit(state.copyWith(loading: FormzStatus.pure));
      return;
    }
    await FirebaseFirestore.instance
        .collection(TODO_REF)
        .doc(id)
        .update({"done": updateStatus});
    emit(state.copyWith(loading: FormzStatus.submissionSuccess));
    emit(state.copyWith(loading: FormzStatus.pure));
  }

  deleteTodo(
    String id,
  ) async {
    var rawTodos = todoFromJson(await sharedPreferences.getString(TODO_CACHE));
    rawTodos.removeWhere((element) => element.id == id);
    await sharedPreferences.setString(TODO_CACHE, todoToJson(rawTodos));
    if (!(await networkInfo.isConnected())) {
      emit(state.copyWith(loading: FormzStatus.submissionSuccess));
      emit(state.copyWith(loading: FormzStatus.pure));
      return;
    }
    await FirebaseFirestore.instance.collection(TODO_REF).doc(id).delete();
    emit(state.copyWith(loading: FormzStatus.submissionSuccess));
    emit(state.copyWith(loading: FormzStatus.pure));
  }
}
