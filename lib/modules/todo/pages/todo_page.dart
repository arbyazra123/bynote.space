import 'package:formz/formz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:web_todolist/modules/main/providers/calendar_provider.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';
import 'package:web_todolist/modules/todo/blocs/add_new_todo/add_new_todo_cubit.dart';
import 'package:web_todolist/modules/todo/blocs/get_todo/get_todo_bloc.dart';
import 'package:web_todolist/modules/todo/blocs/update_todo_cubit/update_todo_cubit.dart';
import 'package:web_todolist/modules/todo/providers/todo_provider.dart';
import 'package:web_todolist/modules/todo/widgets/all_todo_view.dart';
import 'package:web_todolist/modules/todo/widgets/calendar_todo_view.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    var todoProvider = Provider.of<TodoProvider>(context);
    var calendarProvider = Provider.of<CalendarProvider>(context);
    return BlocListener<UpdateTodoCubit, UpdateTodoState>(
      listener: (context, state) {
        if (state.loading == FormzStatus.submissionSuccess) {
          if (todoProvider.mode == TodoMode.calendar) {
            context.read<GetTodoBloc>().add(GetTodoByDate(date: calendarProvider.currentDate));
          } else {
            context.read<GetTodoBloc>().add(GetAllTodo());
          }
        }
      },
      child: BlocListener<AddNewTodoCubit, AddNewTodoState>(
        listener: (context, state) {
          if (state.loading == FormzStatus.submissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Todo successfully added!",
                  style: TextStyle(
                    color: Colors.pink,
                  )),
            ));
            if (todoProvider.mode == TodoMode.calendar) {
              context.read<GetTodoBloc>().add(GetTodoByDate(date: calendarProvider.currentDate));
            } else {
              context.read<GetTodoBloc>().add(GetAllTodo());
            }
          }
        },
        child: Consumer<TodoProvider>(
          builder: (context, value, child) => Scaffold(
            backgroundColor: theme.backgroundColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14.0, left: 20),
                  child: InkWell(
                    onTap: () {
                      Provider.of<TodoProvider>(context, listen: false)
                          .toggle(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        value.mode != TodoMode.all
                            ? "Switch to All Todo Mode"
                            : "Switch to Calendar Mode",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                value.mode != TodoMode.all ? CalendarTodoView() : AllTodoView(),
                // Expanded(
                //   child: AnimatedCrossFade(
                //     duration: Duration(milliseconds: 500),
                //     firstChild:
                //     secondChild: _buildTodo(calendar, theme, context),
                //     // secondChild: _buildAllTodo(),
                //     crossFadeState: value.mode == TodoMode.all
                //         ? CrossFadeState.showSecond
                //         : CrossFadeState.showFirst,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
