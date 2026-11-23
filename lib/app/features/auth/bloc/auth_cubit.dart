import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/firestore/user_store.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthInProgress extends AuthState {}

final class AuthSuccess extends AuthState {
  const AuthSuccess({required this.email, this.profile});

  final String email;
  final UserProfile? profile;

  @override
  List<Object> get props => [email, ?profile];
}

final class AuthFailure extends AuthState {
  const AuthFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

/// Вход, регистрация и выход через Firebase Authentication,
/// профиль пользователя сохраняется в Cloud Firestore.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._auth, this._userStore) : super(AuthInitial());

  final FirebaseAuth _auth;
  final UserStore _userStore;

  Future<void> signIn(String email, String password) async {
    emit(AuthInProgress());
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      final profile = user == null ? null : await _userStore.readProfile(user.uid);
      emit(AuthSuccess(email: user?.email ?? email.trim(), profile: profile));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(message: _describe(e)));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthInProgress());
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        emit(const AuthFailure(message: 'Не удалось создать пользователя'));
        return;
      }
      await _userStore.saveProfile(uid: user.uid, email: user.email ?? email.trim());
      final profile = await _userStore.readProfile(user.uid);
      emit(AuthSuccess(email: user.email ?? email.trim(), profile: profile));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(message: _describe(e)));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(AuthInitial());
  }

  String _describe(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-email' => 'Неверный формат почты',
      'user-disabled' => 'Пользователь заблокирован',
      'user-not-found' => 'Пользователь не найден',
      'wrong-password' => 'Неверный пароль',
      'invalid-credential' => 'Неверная почта или пароль',
      'email-already-in-use' => 'Такая почта уже зарегистрирована',
      'weak-password' => 'Слишком простой пароль (минимум 6 символов)',
      'operation-not-allowed' => 'Вход по почте и паролю не включён в Firebase',
      _ => e.message ?? e.code,
    };
  }
}
