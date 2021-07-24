import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';
import 'package:web_todolist/modules/todo/blocs/get_todo/get_todo_bloc.dart';
import 'package:web_todolist/modules/todo/widgets/header_calendar.dart';
import 'package:web_todolist/modules/todo/widgets/todo_listview.dart';
import 'package:web_todolist/shared/theme.dart';

class CalendarTodoView extends StatefulWidget {
  const CalendarTodoView({Key key}) : super(key: key);

  @override
  _CalendarTodoViewState createState() => _CalendarTodoViewState();
}

class _CalendarTodoViewState extends State<CalendarTodoView> {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    return Expanded(
      child: Column(
        children: [
          HeaderCalendar(),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Divider(
              height: 0,
              color: theme.primaryColor,
              thickness: 0.2,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                return context.read<GetTodoBloc>().add(GetTodoByDate());
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  _buildSwipeRightWarning(theme),
                  _buildTodos(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeRightWarning(CustomTheme theme) {
    return Center(
      child: Text(
        "swipe right to delete a todo",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: theme.primaryColor.withOpacity(0.14),
        ),
      ),
    );
  }

  Widget _buildTodos() {
    return BlocBuilder<GetTodoBloc, GetTodoState>(
      builder: (context, state) {
        if (state is GetTodoError) {
          return Center(
            child: Text("An error occured"),
          );
        }
        if (state is GetTodoLoaded) {
          return TodoListView(
            todos: state.result,
          );
        }
        return TodoListView(
          todos: context.read<GetTodoBloc>().result,
        );
      },
    );
  }
}
