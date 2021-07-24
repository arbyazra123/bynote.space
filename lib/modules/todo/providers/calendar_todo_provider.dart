import 'package:flutter/material.dart';
import 'package:web_todolist/modules/todo/models/todo.dart';
import 'package:web_todolist/modules/todo/providers/todo_provider.dart';

class CalendarTodoProvider extends ChangeNotifier {
  List<Todo> _raw=[];
  List<Todo> _todos=[];
  List<TodosByDay> _todosByDay=[];

  List<Todo> get getTodos => _todos;
  List<TodosByDay> get getTodosByDay => _todosByDay;

  initTodo(List<Todo> todos, AllTodoMode mode) {
    _raw = todos;
    _todos = todos;
    if (mode == AllTodoMode.today)
      sortByToday();
    else if (mode == AllTodoMode.past)
      sortByPast();
    else
      sortByUpcoming();
    notifyListeners();
  }

  staticCheckUpdate(bool update,int index){
    _todos[index].copyWith(done: update);
    notifyListeners();
  }

  staticRemove(int index){
    _todos.removeAt(index);
    notifyListeners();
  }

  sortByPast() {
    _sort(AllTodoMode.past);
    notifyListeners();
  }

  sortByToday() {
    _sort(AllTodoMode.today);
    notifyListeners();
  }

  sortByUpcoming() {
    _sort(AllTodoMode.upcoming);
    notifyListeners();
  }

  void _sort(AllTodoMode mode) {
    _todos = _raw.where((element) {
      var date = DateTime.parse(element.time);
      var convertedDate = DateTime(date.year, date.month, date.day);
      var today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      if (mode == AllTodoMode.past) {
        if (convertedDate.isBefore(today))
          return true;
        else
          return false;
      } else if (mode == AllTodoMode.today) {
        if (convertedDate.isAtSameMomentAs(today))
          return true;
        else
          return false;
      } else {
        if (convertedDate.isAfter(today))
          return true;
        else
          return false;
      }
    }).toList();
    var _todosSet = _todos
        .map((element) {
          var date = DateTime.parse(element.time);
          var convertedDate = DateTime(date.year, date.month, date.day);
          return convertedDate.toIso8601String();
        })
        .toList()
        .toSet()
        .toList();
    _todosByDay = _todosSet
        .map(
          (e) => TodosByDay(
            day: DateTime.parse(e),
            todos: _todos.where(
              (element) {
                var date = DateTime.parse(element.time);
                var convertedDate = DateTime(date.year, date.month, date.day);
                if (convertedDate.isAtSameMomentAs(DateTime.parse(e))) {
                  return true;
                } else
                  return false;
              },
            ).toList(),
          ),
        )
        .toList();
  }
}

class TodosByDay {
  final DateTime day;
  final List<Todo> todos;

  TodosByDay({this.day, this.todos});

  @override
  String toString() {
    return """ 
      day : ${day.toString()},
      list : [ ${todos.toString()} ]
    """;
  }
}
