part of 'bottom_nav_bloc.dart';

abstract class BottomNavState extends Equatable {
  const BottomNavState();

  @override
  List<Object> get props => [];
}

class BottomNavTodo extends BottomNavState {}

class BottomNavPomodoro extends BottomNavState {}

class BottomNavNote extends BottomNavState {}

