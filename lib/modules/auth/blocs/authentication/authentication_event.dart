part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppLogoutRequested extends AuthenticationEvent {}

class AppUserChanged extends AuthenticationEvent {
  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}