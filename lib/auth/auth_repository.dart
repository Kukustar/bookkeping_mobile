import 'dart:async';

import 'package:bookkeping_mobile/jwt_decode.dart';
import 'package:bookkeping_mobile/service/core/api_service.dart';
import 'package:bookkeping_mobile/service/core/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  authenticated,
  unauthenticated
}

class AuthRepository {
  final _authStatusController = StreamController<AuthStatus>();
  final _authErrorController = StreamController<String>();

  Stream<AuthStatus> get authStatus async* {
    final Future<SharedPreferences> prefsFuture = SharedPreferences.getInstance();
    SharedPreferences prefs = await prefsFuture;
    String? access = prefs.getString('access');
    String? refresh = prefs.getString('refresh');

    AuthStatus status = await checkAndUpdateTokes(access, refresh);
    yield status;

    yield* _authStatusController.stream;
  }

  Stream<String> get authError async* {
    yield* _authErrorController.stream;
  }


  Future<AuthStatus> checkAndUpdateTokes(String? access, String? refresh) async {
    if (access != null && access != '') {
      if (!Jwt.isExpired(access)) {
        return AuthStatus.authenticated;
      }

      if (!Jwt.isExpired(refresh!)) {
        NetworkResponseStatus status = await ApiService().updateAccessToken();
        if (status == NetworkResponseStatus.success) {
          return AuthStatus.authenticated;
        }
      }
      return AuthStatus.unauthenticated;
    }

    return AuthStatus.unauthenticated;
  }

  Future<void> authUser(String email, String password) async {
    NetworkResponse response = await ApiService().authUser(email, password);

    if (response.status == NetworkResponseStatus.success) {
      _authStatusController.add(AuthStatus.authenticated);
    }

    if (response.status == NetworkResponseStatus.failed) {
      if (response.body.containsKey('detail')) {
        _authErrorController.add(response.body['detail']);
      } else {
        _authErrorController.add('Some went wrong');
      }
    }
  }

  Future<void> logOut() async {
    final Future<SharedPreferences> prefsFuture = SharedPreferences.getInstance();
    SharedPreferences prefs = await prefsFuture;
    prefs.remove('access');

    _authStatusController.add(AuthStatus.unauthenticated);
  }
}