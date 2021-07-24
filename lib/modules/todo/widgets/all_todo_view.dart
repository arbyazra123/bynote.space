import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';
import 'package:web_todolist/modules/todo/blocs/get_todo/get_todo_bloc.dart';
import 'package:web_todolist/modules/todo/providers/calendar_todo_provider.dart';
import 'package:web_todolist/modules/todo/providers/todo_provider.dart';
import 'package:web_todolist/modules/todo/widgets/todo_listview.dart';

class AllTodoView extends StatefulWidget {
  const AllTodoView({
    Key key,
  }) : super(key: key);

  @override
  _AllTodoViewState createState() => _AllTodoViewState();
}

class _AllTodoViewState extends State<AllTodoView> {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    var calendar = Provider.of<TodoProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: DefaultTabController(
        length: 3,
        initialIndex: calendar.allTodoMode.index,
        child: Consumer<TodoProvider>(
          builder: (context, value, child) => RefreshIndicator(
            onRefresh: () async {
              return context.read<GetTodoBloc>().add(GetAllTodo());
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  // _buildAllTodoTab(value),
                  TabBar(
                    tabs: [
                      Tab(
                        text: "Past",
                      ),
                      Tab(
                        text: "Today",
                      ),
                      Tab(
                        text: "Upcoming",
                      ),
                    ],
                    labelColor: theme.primaryColor,
                    indicatorColor: theme.primaryColor,
                    onTap: (index) {
                      if (index == 0) {
                        Provider.of<CalendarTodoProvider>(context,
                                listen: false)
                            .sortByPast();
                        value.toggleAllTodoMode(AllTodoMode.past);
                      }
                      if (index == 1) {
                        Provider.of<CalendarTodoProvider>(context,
                                listen: false)
                            .sortByToday();
                        value.toggleAllTodoMode(AllTodoMode.today);
                      }
                      if (index == 2) {
                        Provider.of<CalendarTodoProvider>(context,
                                listen: false)
                            .sortByUpcoming();
                        value.toggleAllTodoMode(AllTodoMode.upcoming);
                      }
                    },
                  ),
                  BlocConsumer<GetTodoBloc, GetTodoState>(
                    listener: (context, state) {
                      if (state is GetTodoLoaded) {
                        Provider.of<CalendarTodoProvider>(context,
                                listen: false)
                            .initTodo(state.result, value.allTodoMode);
                      }
                    },
                    builder: (context, state) {
                      return Consumer<CalendarTodoProvider>(
                        builder: (context, calendarValue, child) =>
                            TodoListView(
                          todos: value.allTodoMode == AllTodoMode.today
                              ? calendarValue.getTodos
                              : null,
                          todoByDays: calendarValue.getTodosByDay,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
