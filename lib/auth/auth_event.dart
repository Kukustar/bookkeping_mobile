import 'package:bookkeping_mobile/auth/auth_repository.dart';

abstract class AuthEvent {}

class LogOut extends AuthEvent {}

class LoginUser extends AuthEvent {
  LoginUser(this._email, this._password);

  final String _email;
  final String _password;

  String get email => _email;
  String get password => _password;
}

class AuthStatusChanged extends AuthEvent {
  AuthStatusChanged(this._authStatus);
  final AuthStatus _authStatus;

  AuthStatus get authStatus => _authStatus;
}

class AuthErrorChanged extends AuthEvent {
  AuthErrorChanged(this._error);
  final String _error;

  String get error => _error;
}