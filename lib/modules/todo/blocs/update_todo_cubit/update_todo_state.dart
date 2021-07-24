part of 'update_todo_cubit.dart';

class UpdateTodoState extends Equatable {
  final FormzStatus loading;
  const UpdateTodoState({
    this.loading = FormzStatus.pure,
  });
  copyWith({loading}) => UpdateTodoState(loading: loading ?? this.loading);
  @override
  List<Object> get props => [loading];
}
