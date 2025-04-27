import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:web_todolist/modules/todo/blocs/get_todo/get_todo_bloc.dart';

enum TodoMode { all, calendar }

enum AllTodoMode { past, today, upcoming }

extension AllTodoModeExt on AllTodoMode {
  int get index {
    var idx = 0;
    switch (this) {
      case AllTodoMode.past:
        idx = 0;
        break;
      case AllTodoMode.today:
        idx = 1;
        break;
      case AllTodoMode.upcoming:
        idx = 2;
        break;
    }
    return idx;
  }
}

class TodoProvider extends ChangeNotifier {
  TodoMode mode = TodoMode.calendar;
  AllTodoMode allTodoMode = AllTodoMode.today;

  toggleAllTodoMode(AllTodoMode mode) {
    this.allTodoMode = mode;
    notifyListeners();
  }

  toggle(BuildContext context) {
    if (mode == TodoMode.all) {
      mode = TodoMode.calendar;
      context.read<GetTodoBloc>().add(GetTodoByDate(date: DateTime.now()));
    } else {
      context.read<GetTodoBloc>().add(GetAllTodo());
      mode = TodoMode.all;
    }
    notifyListeners();
  }
}
