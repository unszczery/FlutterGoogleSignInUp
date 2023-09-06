import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_getter/repository/auth_repository.dart';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<SignUpEvent>(_mapRegisterEventToState,
        transformer: bloc_concurrency.sequential());
    on<SignInEvent>(_mapLoginEventToState,
        transformer: bloc_concurrency.sequential());
    on<GoogleSignInEvent>(_mapGoogleSignInEventToState,
        transformer: bloc_concurrency.sequential());
    on<SignOutEvent>(_mapSignOutEventToState,
        transformer: bloc_concurrency.sequential());
  }

  Future<void> _mapRegisterEventToState(
      SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signUp(email: event.email, password: event.password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
      emit(UnAuthenticated());
    }
  }

  Future<void> _mapLoginEventToState(
      SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signIn(email: event.email, password: event.password);

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
      emit(UnAuthenticated());
    }
  }

  Future<void> _mapGoogleSignInEventToState(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.singInWithGoogle();
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
      emit(UnAuthenticated());
    }
  }

  Future<void> _mapSignOutEventToState(
      SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.signOut();
    emit(UnAuthenticated());
  }
}

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final SharedPreferences sharedPreferences;
//   final FlutterSecureStorage sucureStorage;

//   AuthBloc({required this.sharedPreferences, required this.sucureStorage})
//       : super(AuthInitial()) {
//     on<RegisterEvent>(_mapRegisterEventToState,
//         transformer: bloc_concurrency.sequential());
//     on<LoginEvent>(_mapLoginEventToState,
//         transformer: bloc_concurrency.sequential());
//   }

//   Future<void> _mapRegisterEventToState(
//       RegisterEvent event, Emitter<AuthState> emit) async {
//     emit(AuthLoading());
//     try {
//       final email = event.email;
//       final password = event.password;
//       sharedPreferences.setString('email', email);
//       sharedPreferences.setString('password', password);
//       emit(AuthSuccess());
//       sharedPreferences.setBool('isLoggedIn', true);
//     } catch (e) {
//       emit(AuthFailure(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _mapLoginEventToState(
//       LoginEvent event, Emitter<AuthState> emit) async {
//     emit(AuthLoading());
//     try {
//       final email = event.email;
//       final password = event.password;
//       final savedEmail = sharedPreferences.getString('email');
//       final savedPassword = sharedPreferences.getString('password');
//       if (email == savedEmail && password == savedPassword) {
//         emit(AuthSuccess());
//         sharedPreferences.setBool('isLoggedIn', true);
//       } else {
//         emit(AuthFailure(errorMessage: 'Invalid email or password'));
//       }
//     } catch (e) {
//       emit(AuthFailure(errorMessage: e.toString()));
//     }
//   }
// }
