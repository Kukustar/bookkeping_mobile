import 'package:bookkeping_mobile/auth/auth_repository.dart';

class AuthState {
  AuthState({
    this.authStatus = AuthStatus.unauthenticated,
    this.error = ''
  });

  final AuthStatus authStatus;
  final String error;

  AuthState copyWith({
    AuthStatus? authStatus,
    String? error
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      error: error ?? this.error
    );
  }
}