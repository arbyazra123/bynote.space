import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';
import 'package:web_todolist/modules/todo/blocs/get_todo/get_todo_bloc.dart';
import 'package:web_todolist/modules/todo/blocs/update_todo_cubit/update_todo_cubit.dart';
import 'package:web_todolist/modules/todo/models/todo.dart';
import 'package:web_todolist/modules/todo/providers/calendar_todo_provider.dart';
import 'package:web_todolist/modules/todo/providers/todo_provider.dart';

class TodoListView extends StatelessWidget {
  final List<Todo> todos;
  final List<TodosByDay> todoByDays;
  const TodoListView({
    Key key,
    this.todos,
    this.todoByDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    var list = todos ?? todoByDays;
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      padding: EdgeInsets.only(
        top: 14,
        bottom: 20,
      ),
      shrinkWrap: true,
      separatorBuilder: (context, index) => SizedBox(
        height: 10,
      ),
      itemBuilder: (context, index) {
        if (todos != null) {
          var data = todos[index];
          var checked = data.done;
          var isItImportant = data.important;
          return _buildTodoItem(data, context, isItImportant, checked, index);
        } else {
          var data = todoByDays[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  DateFormat("EEEE, dd-MM-yyyy").format(data.day),
                  style: TextStyle(color: theme.primaryColor.withOpacity(0.6)),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              ...data.todos.map((e) {
                var checked = e.done;
                var isItImportant = e.important;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _buildTodoItem(e, context, isItImportant, checked,
                      data.todos.indexOf(e)),
                );
              })
            ],
          );
        }
      },
    );
  }

  Widget _buildTodoItem(Todo data, BuildContext context, bool isItImportant,
      bool checked, int index) {
    var todoProvider = Provider.of<TodoProvider>(context, listen: false);
    var calendarProvider =
        Provider.of<CalendarTodoProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        context.read<GetTodoBloc>().result =
            context.read<GetTodoBloc>().result.map((element) {
          if (element.id == data.id) {
            return element.copyWith(done: !checked);
          }
          return element;
        }).toList();
        if (todoProvider.allTodoMode.index == 1 && todoProvider.mode==TodoMode.all) {
          calendarProvider.staticCheckUpdate(!checked, index);
        } else {}
        context.read<UpdateTodoCubit>().checkTodo(data.id, !checked);
      },
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (v) {
          context
              .read<GetTodoBloc>()
              .result
              .removeWhere((element) => element.id == data.id);
          if (todoProvider.allTodoMode.index == 1 && todoProvider.mode==TodoMode.all) {
            calendarProvider.staticRemove(index);
          } else {}
          context.read<UpdateTodoCubit>().deleteTodo(data.id);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: (isItImportant ? Colors.orange[800] : Colors.blue[800])
                  .withOpacity(checked ? 0.5 : 1)),
          child: Row(
            children: [
              Theme(
                data: ThemeData(
                  unselectedWidgetColor: Colors.white,
                ),
                child: Checkbox(
                  value: checked,
                  onChanged: (v) {
                    context.read<GetTodoBloc>().result =
                        context.read<GetTodoBloc>().result.map((element) {
                      if (element.id == data.id) {
                        return element.copyWith(done: v);
                      }
                      return element;
                    }).toList();
                    context.read<UpdateTodoCubit>().checkTodo(data.id, v);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: BorderSide(color: Colors.white, width: 0.5)),
                  checkColor: Colors.white,
                  activeColor: Colors.pink,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Center(
                child: Text(
                  data.content,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      decoration: checked ? TextDecoration.lineThrough : null),
                ),
              )),
              SizedBox(width: 6),
              Text(
                DateFormat("hh:mm").format(
                  DateTime.parse(data.time),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
