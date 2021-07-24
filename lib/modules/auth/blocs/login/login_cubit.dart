import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:web_todolist/modules/auth/repositories/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({this.authenticationRepository}) : super(LoginState());

  final AuthenticationRepository authenticationRepository;
  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch(e) {
      print(e.toString());
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    } on NoSuchMethodError catch(e){
      print(e.toString());
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }
  Future<void> logInAnonymously() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await authenticationRepository.logInAnonymously();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch(e) {
      print(e.toString());
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    } on NoSuchMethodError catch(e){
      print(e.toString());
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }
}
