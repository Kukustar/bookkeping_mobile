import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:bookkeping_mobile/auth/auth_event.dart';
import 'package:bookkeping_mobile/auth/auth_repository.dart';
import 'package:bookkeping_mobile/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({ required AuthRepository repository }) :
        _authRepository = repository,
        super(AuthState()) {
    _authStatusSubscription = _authRepository.authStatus.listen(
            (status)  => add(AuthStatusChanged(status))
    );
    _authErrorSubscription = _authRepository.authError.listen(
            (error) => AuthErrorChanged(error)
    );
    on<LogOut>(_onLogOut);
    on<LoginUser>(_onLoginUser);
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthErrorChanged>(_onAuthErrorChanged);
  }

  final AuthRepository _authRepository;
  late StreamSubscription<AuthStatus> _authStatusSubscription;
  late StreamSubscription<String> _authErrorSubscription;


  Future<void> _onLoginUser(LoginUser event, Emitter<AuthState> emit) async {
    await _authRepository.authUser(event.email, event.password);
  }

  _onLogOut(LogOut event, Emitter<AuthState> emit) async {
    await _authRepository.logOut();
  }

  _onAuthErrorChanged(AuthErrorChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(error: event.error));
  }

  _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(authStatus: event.authStatus));
  }

  @override
  Future<void> close() async {
    _authStatusSubscription.cancel();
    _authErrorSubscription.cancel();
    return super.close();
  }
}