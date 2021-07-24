part of 'bottom_nav_bloc.dart';

abstract class BottomNavEvent extends Equatable {
  const BottomNavEvent();

  @override
  List<Object> get props => [];
}

class GetBottomNavTodo extends BottomNavEvent {}

class GetBottomNavNote extends BottomNavEvent {}

class GetBottomNavPomodoro extends BottomNavEvent {}

