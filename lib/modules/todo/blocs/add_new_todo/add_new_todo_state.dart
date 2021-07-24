part of 'add_new_todo_cubit.dart';

class AddNewTodoState extends Equatable {
  final FormzStatus loading;
  final bool isImportant;
  final DateTime time;
  const AddNewTodoState({
    this.loading = FormzStatus.pure,
    this.time,
    this.isImportant = false,
  });
  copyWith({
    loading,
    isImportant,
    time,
  }) =>
      AddNewTodoState(
        isImportant: isImportant ?? this.isImportant,
        loading: loading ?? this.loading,
        time: time ?? this.time,
      );
  @override
  List<Object> get props => [loading, isImportant,time];
}
