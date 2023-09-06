part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class UnAuthenticated extends AuthState {}
