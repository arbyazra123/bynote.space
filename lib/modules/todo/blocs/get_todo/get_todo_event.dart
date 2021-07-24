part of 'get_todo_bloc.dart';

abstract class GetTodoEvent extends Equatable {
  const GetTodoEvent();

  @override
  List<Object> get props => [];
}

class GetTodoByDate extends GetTodoEvent {
  final DateTime date;

  GetTodoByDate({this.date});
  @override
  List<Object> get props => [date];
}

class GetAllTodo extends GetTodoEvent {}
