import 'dart:async';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_todolist/core/encrypter.dart';
import 'package:web_todolist/core/network/network_info.dart';
import 'package:web_todolist/modules/auth/repositories/authentication_repository.dart';
import 'package:web_todolist/modules/todo/models/todo.dart';
import 'package:web_todolist/shared/constants.dart';

part 'get_todo_event.dart';
part 'get_todo_state.dart';

final String TODO_CACHE = 'todo-cache';

class GetTodoBloc extends Bloc<GetTodoEvent, GetTodoState> {
  GetTodoBloc({
    this.networkInfo,
    this.sharedPreferences,
    @required this.authRepository,
  }) : super(GetTodoInitial());
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  final AuthenticationRepository authRepository;
  List<Todo> result = [];

  @override
  Stream<GetTodoState> mapEventToState(
    GetTodoEvent event,
  ) async* {
    if (event is GetTodoByDate) {
      yield* _mapGetTodoByDateToState(event);
    }
    if (event is GetAllTodo) {
      yield* _mapGetAllTodoToState(event);
    }
  }

  Stream<GetTodoState> _mapGetAllTodoToState(GetAllTodo event) async* {
    yield GetTodoLoading();
    if (!(await networkInfo.isConnected())) {
      var todos = await sharedPreferences.getString(TODO_CACHE);
      if (todos == null) {
        yield GetTodoLoaded([]);
      }
      yield GetTodoLoaded(todoFromJson(todos));
      return;
    }
    List<Todo> todos = await _getTodos();
    if (todos == null) {
      yield GetTodoLoaded([]);
      return;
    }
    _sortTodosByTime(todos);
    await sharedPreferences.setString(TODO_CACHE, todoToJson(todos));
    yield GetTodoLoaded(todos);
  }

  Stream<GetTodoState> _mapGetTodoByDateToState(GetTodoByDate event) async* {
    yield GetTodoLoading();
    try {
      if (!(await networkInfo.isConnected())) {
        var rawTodos = await sharedPreferences.getString(TODO_CACHE);
        List<Todo> todos;
        if (rawTodos == null) {
          yield GetTodoLoaded([]);
        } else {
          var convertedTodos = todoFromJson(rawTodos);
          todos = _filterTodosByDate(
              convertedTodos, event.date == null ? DateTime.now() : event.date);
        }
        yield GetTodoLoaded(todos);
        return;
      }
      List<Todo> convertedTodos = await _getTodos();
      if (convertedTodos == null) {
        yield GetTodoLoaded([]);
        return;
      }
      List<Todo> todos = _filterTodosByDate(
          convertedTodos, event.date == null ? DateTime.now() : event.date);
      _sortTodosByTime(todos);
      result = todos;
      await sharedPreferences.setString(TODO_CACHE, todoToJson(todos));
      yield GetTodoLoaded(todos);
    } catch (e) {
      print(e);
      yield GetTodoError();
    }
  }

  Future<List<Todo>> _getTodos() async {
    var rawTodos = await FirebaseFirestore.instance
        .collection(TODO_REF)
        .where("userId", isEqualTo: authRepository.currentUser.id)
        .get();
    if (rawTodos.size == 0) {
      return null;
    }
    return rawTodos.docs
        .map(
          (e) => Todo.fromJson(e.data()).copyWith(
              id: e.id,
              content: encryptor.decrypt64(e.data()['content'],
                  iv: encrypt.IV.fromLength(16))),
        )
        .toList();
  }

  void _sortTodosByTime(List<Todo> todos) {
    todos.sort(
        (a, b) => DateTime.parse(a.time).compareTo(DateTime.parse(b.time)));
  }

  List<Todo> _filterTodosByDate(List<Todo> todos, DateTime date) {
    List<Todo> result = todos.where((element) {
      var eDay = DateTime.parse(element.time);
      if (DateTime(
            eDay.year,
            eDay.month,
            eDay.day,
          ) ==
          DateTime(date.year, date.month, date.day)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    return result;
  }
}
