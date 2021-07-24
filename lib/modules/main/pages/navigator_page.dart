import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_todolist/modules/main/blocs/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:web_todolist/modules/main/widgets/navigator_template.dart';
import 'package:web_todolist/modules/notes/pages/note_page.dart';
import 'package:web_todolist/modules/pomodoro/pages/pomodoro_page.dart';
import 'package:web_todolist/modules/todo/pages/todo_page.dart';

class NavigatorPage extends StatelessWidget {
  const NavigatorPage({Key key}) : super(key: key);
  static Page page() => MaterialPage<void>(child: NavigatorPage());
  @override
  Widget build(BuildContext context) {
    return NavigatorTemplate(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        if (state is BottomNavTodo) {
          return TodoPage();
        } else if (state is BottomNavNote) {
          return NotesPage();
        } else if (state is BottomNavPomodoro) {
          return PomodoroPage();
        } else {
          return Center(child: Text('Undefined Page'));
        }
      },
    );
  }
}
