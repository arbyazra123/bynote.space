import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_todolist/modules/main/blocs/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:web_todolist/modules/notes/blocs/get_note/get_note_bloc.dart';
import 'package:web_todolist/modules/todo/blocs/add_new_todo/add_new_todo_cubit.dart';
import 'package:web_todolist/modules/todo/providers/calendar_todo_provider.dart';
import 'package:web_todolist/modules/todo/providers/todo_provider.dart';

import 'core/network/network_info.dart';
import 'modules/auth/blocs/authentication/authentication_bloc.dart';
import 'modules/auth/blocs/login/login_cubit.dart';
import 'modules/auth/repositories/authentication_repository.dart';
import 'modules/main/providers/calendar_provider.dart';
import 'modules/notes/blocs/add_new_note/add_new_note_cubit.dart';
import 'modules/notes/providers/drawing_provider.dart';
import 'modules/theme/providers/theme_switcher_provider.dart';
import 'modules/todo/blocs/get_todo/get_todo_bloc.dart';
import 'modules/todo/blocs/update_todo_cubit/update_todo_cubit.dart';

final gi = GetIt.instance;

class FactoryInjector {
  static inject() async {
    gi.registerFactory(() => GetTodoBloc(
          networkInfo: gi(),
          sharedPreferences: gi(),
          authRepository: gi()
        ));
    gi.registerFactory(() => AddNewTodoCubit(
          networkInfo: gi(),
          authRepository: gi(),
          sharedPreferences: gi(),
        ));
    gi.registerFactory(() => UpdateTodoCubit(
          networkInfo: gi(),
          sharedPreferences: gi(),
          authRepository: gi()
        ));
    gi.registerFactory(() => AddNewNoteCubit(
          networkInfo: gi(),
          sharedPreferences: gi(),
          authRepository: gi()
        ));
    gi.registerFactory(() => GetNoteBloc(
          networkInfo: gi(),
          sharedPreferences: gi(),
          authRepository: gi(),
        ));
    gi.registerFactory(() => BottomNavBloc());
    gi.registerFactory(
        () => AuthenticationBloc(authenticationRepository: gi()));
    gi.registerFactory(() => LoginCubit(authenticationRepository: gi()));

    //providers
    gi.registerFactory(() => ThemeSwitcherProvider());
    gi.registerFactory(() => DrawingProvider());
    gi.registerFactory(() => CalendarProvider());
    gi.registerFactory(() => TodoProvider());
    gi.registerFactory(() => CalendarTodoProvider());

    gi.registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepository(sharedPreferences: gi()));
    gi.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(gi()));

    //External
    final sharedPreferences = await SharedPreferences.getInstance();
    gi.registerLazySingleton(() => sharedPreferences);
    gi.registerLazySingleton(() => Connectivity());
  }
}
