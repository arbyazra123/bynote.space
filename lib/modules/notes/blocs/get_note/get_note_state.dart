part of 'get_note_bloc.dart';

abstract class GetNoteState extends Equatable {
  const GetNoteState();
  
  @override
  List<Object> get props => [];
}

class GetNoteInitial extends GetNoteState {}
class GetNoteLoading extends GetNoteState {}
class GetNoteLoaded extends GetNoteState {
  final List<Note> result;

  GetNoteLoaded(this.result);
}
class GetNoteError extends GetNoteState {}
