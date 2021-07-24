part of 'add_new_note_cubit.dart';

class AddNewNoteState extends Equatable {
  final FormzStatus loading;
  final bool isDrawMode;
  final List<DrawingPoints> drawing;
  final Note updatedNote;
  const AddNewNoteState({
    this.loading = FormzStatus.pure,
    this.isDrawMode = false,
    this.updatedNote,
    this.drawing = const <DrawingPoints>[],
  });
  copyWith({
    loading,
    isDrawMode,
    drawing,
    updatedNote,
  }) =>
      AddNewNoteState(
        drawing: drawing ?? this.drawing,
        isDrawMode: isDrawMode ?? this.isDrawMode,
        loading: loading ?? this.loading,
        updatedNote: updatedNote??this.updatedNote
      );
  @override
  List<Object> get props => [
        loading,
        isDrawMode,
        drawing,
        updatedNote
      ];
}
