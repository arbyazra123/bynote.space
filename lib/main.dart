import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/app.dart';
import 'package:web_todolist/core/bloc_observer.dart';
import 'package:web_todolist/modules/main/blocs/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:web_todolist/modules/main/providers/calendar_provider.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';

import 'factory_injector.dart';
import 'modules/auth/blocs/authentication/authentication_bloc.dart';
import 'modules/auth/blocs/login/login_cubit.dart';
import 'modules/notes/blocs/add_new_note/add_new_note_cubit.dart';
import 'modules/notes/blocs/get_note/get_note_bloc.dart';
import 'modules/notes/providers/drawing_provider.dart';
import 'modules/todo/blocs/add_new_todo/add_new_todo_cubit.dart';
import 'modules/todo/blocs/get_todo/get_todo_bloc.dart';
import 'modules/todo/blocs/update_todo_cubit/update_todo_cubit.dart';
import 'modules/todo/providers/calendar_todo_provider.dart';
import 'modules/todo/providers/todo_provider.dart';

void main() async {
  Bloc.observer = CustomBlocObserver();
  await FactoryInjector.inject();
  await Firebase.initializeApp();
  runApp(
    ScreenUtilInit(
      designSize: Size(360, 490),
      builder: () => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => gi<BottomNavBloc>(),
          ),
          BlocProvider(
            create: (context) => gi<GetTodoBloc>()..add(GetTodoByDate(date: DateTime.now())),
          ),
          BlocProvider(
            create: (context) => gi<AddNewTodoCubit>(),
          ),
          BlocProvider(
            create: (context) => gi<UpdateTodoCubit>(),
          ),
          BlocProvider(
            create: (context) => gi<AddNewNoteCubit>(),
          ),
          BlocProvider(
            create: (context) => gi<GetNoteBloc>()..add(GetNote()),
          ),
          BlocProvider(
            create: (context) => gi<AuthenticationBloc>(),
          ),
          BlocProvider(
            create: (context) => gi<LoginCubit>(),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => gi<ThemeSwitcherProvider>(),
            ),
            ChangeNotifierProvider(
              create: (context) => gi<CalendarProvider>(),
            ),
            ChangeNotifierProvider(
              create: (context) => gi<DrawingProvider>(),
            ),
            ChangeNotifierProvider(
              create: (context) => gi<TodoProvider>(),
            ),
            ChangeNotifierProvider(
              create: (context) => gi<CalendarTodoProvider>(),
            ),
          ],
          child: App()
        ),
      ),
    ),
  );
}
