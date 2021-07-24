import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/components/primary_drawer.dart';
import 'package:web_todolist/components/theme_switcher.dart';
import 'package:web_todolist/modules/main/blocs/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:web_todolist/modules/notes/blocs/add_new_note/add_new_note_cubit.dart';
import 'package:web_todolist/modules/notes/pages/add_note_page.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';
import 'package:web_todolist/modules/todo/widgets/add_new_todo_dialog.dart';

class NavigatorTemplate extends StatefulWidget {
  final Widget body;
  NavigatorTemplate({Key key, @required this.body}) : super(key: key);

  @override
  _NavigatorTemplateState createState() => _NavigatorTemplateState();
}

class _NavigatorTemplateState extends State<NavigatorTemplate> {
  int _currentIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BottomNavBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<BottomNavBloc>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        _setCurrentStateBottomNav(state);
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
            title: Text(
              "Bynote",
              style:
                  TextStyle(fontFamily: "Pacifico", color: theme.primaryColor),
            ),
            actions: [
              ThemeSwitcher(),
            ],
            backgroundColor: theme.backgroundColor,
            // elevation: 0,
            leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.grey,
              ),
            ),
          ),
          drawer: PrimaryDrawer(),
          floatingActionButton: (state is BottomNavPomodoro)
              ? Container()
              : FloatingActionButton(
                  onPressed: () {
                    if (state is BottomNavTodo) {
                      _showAddTodoForm();
                    } else if (state is BottomNavNote) {
                      context.read<AddNewNoteCubit>().clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewNotePage(),
                        ),
                      );
                    } else if (state is BottomNavPomodoro) {}
                  },
                  mini: true,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.pink,
                ),
          bottomNavigationBar: _buildBottomNav(),
          body: widget.body,
        );
      },
    );
  }

  void _showAddTodoForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: AddNewTodoDialog(),
      ),
    );
  }

  Widget _buildBottomNav() {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.format_list_numbered,
          ),
          label: "Todo",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.note),
          label: "Note",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          label: "Pomodoro",
        ),
      ],
      // showUnselectedLabels: true,
      backgroundColor: theme.backgroundColor,
      onTap: _onTapItem,
      currentIndex: _currentIndex,
      selectedItemColor: theme.primaryColor,
      unselectedItemColor: theme.primaryColor.withOpacity(0.4),
      // selectedFontSize: 0,
      // unselectedFontSize: 0,

      // unselectedIconTheme: IconThemeData(size: Dimens.dp24),
    );
  }

  void _setCurrentStateBottomNav(BottomNavState state) {
    if (state is BottomNavTodo) {
      _currentIndex = 0;
    } else if (state is BottomNavNote) {
      _currentIndex = 1;
    } else if (state is BottomNavPomodoro) {
      _currentIndex = 2;
    }
  }

  void _onTapItem(int index) {
    switch (index) {
      case 0:
        _bloc.add(GetBottomNavTodo());
        break;
      case 1:
        _bloc.add(GetBottomNavNote());
        break;
      case 2:
        _bloc.add(GetBottomNavPomodoro());
        break;
      default:
    }
  }
}
