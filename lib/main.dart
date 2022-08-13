import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:bookkeping_mobile/auth/auth_repository.dart';
import 'package:bookkeping_mobile/purchase/purchase_bloc.dart';
import 'package:bookkeping_mobile/purchase/purchase_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookkeping_mobile/auth/auth_bloc.dart';
import 'package:bookkeping_mobile/auth/auth_state.dart';
import 'package:bookkeping_mobile/screens/home/home_screen.dart';
import 'package:bookkeping_mobile/screens/login/login_screen.dart';
import 'package:bookkeping_mobile/splash_page.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }
  runApp(App(
      authRepository: AuthRepository(),
      purchaseRepository: PurchaseRepository(),
  )
  );
}

class App extends StatelessWidget {
  App({
    Key? key,
    required this.authRepository,
    required this.purchaseRepository
  }) : super(key: key);


  final AuthRepository authRepository;
  final PurchaseRepository purchaseRepository;

  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: purchaseRepository)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(repository: authRepository)
          ),
          BlocProvider<PurchaseBloc>(
              create: (_) => PurchaseBloc(
                  purchaseRepository: purchaseRepository,
                  authRepository: authRepository
              )
          )
        ],
        child: MaterialApp(
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: [
            const Locale('ru'),
          ],
          onGenerateRoute: (_) => SplashPage.route(),
          navigatorKey: _navigatorKey,
          builder: (context, child) {
            return BlocListener<AuthBloc, AuthState>(
                child: child,
                listener: (context, state) {
                  switch (state.authStatus) {
                    case AuthStatus.authenticated:
                      _navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => HomeScreen()
                          ),
                              (route) => false
                      );
                      break;
                    case AuthStatus.unauthenticated:
                      _navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()
                          ),
                              (route) => false
                      );
                      break;
                    default:
                      break;
                  }
                }
            );
          },
        ),
      ),
    );
  }
}

