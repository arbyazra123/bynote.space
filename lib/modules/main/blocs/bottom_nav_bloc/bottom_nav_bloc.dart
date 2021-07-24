import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavTodo());

  @override
  Stream<BottomNavState> mapEventToState(
    BottomNavEvent event,
  ) async* {
    if (event is GetBottomNavTodo) {
      yield BottomNavTodo();
    } else if (event is GetBottomNavNote) {
      yield BottomNavNote();
    } else if (event is GetBottomNavPomodoro) {
      yield BottomNavPomodoro();
    }
  }
}
