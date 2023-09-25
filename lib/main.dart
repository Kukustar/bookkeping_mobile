import 'dart:io';
import 'package:bookkeping_mobile/balance/bloc.dart';
import 'package:bookkeping_mobile/balance/repository.dart';
import 'package:bookkeping_mobile/constants.dart';
import 'package:bookkeping_mobile/deposit/bloc.dart';
import 'package:bookkeping_mobile/deposit/repository.dart';
import 'package:bookkeping_mobile/home/bloc.dart';
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
      balanceRepository: BalanceRepository(),
      depositRepository: DepositRepository(),
  )
  );
}

class App extends StatelessWidget {
  App({
    Key? key,
    required this.authRepository,
    required this.purchaseRepository,
    required this.balanceRepository,
    required this.depositRepository
  }) : super(key: key);


  final AuthRepository authRepository;
  final PurchaseRepository purchaseRepository;
  final BalanceRepository balanceRepository;
  final DepositRepository depositRepository;

  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: purchaseRepository),
        RepositoryProvider.value(value: balanceRepository),
        RepositoryProvider.value(value: depositRepository),
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
          ),
          BlocProvider<BalanceBloc>(
              create: (_) => BalanceBloc(balanceRepository: balanceRepository)
          ),
          BlocProvider<HomeBloc>(
              create: (_) => HomeBloc()
          ),
          BlocProvider<DepositBloc>(
              create: (_) => DepositBloc(
                  repository: depositRepository,
                  authRepository: authRepository
              )
          )
        ],
        child: MaterialApp(
          theme: ThemeData(
              useMaterial3: true,
              textTheme: const TextTheme(
                subtitle1: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400
                ),
                subtitle2: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400
                ),
                bodyText2: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                ),
                bodyText1: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                ),
                headline6: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600
                ),
                headline5: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600
                ),
                headline4: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600
                ),
                caption: TextStyle(
                  fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w100
                ),
                button: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                )
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(greenColor), //button color
                  foregroundColor: MaterialStateProperty.all<Color>(const Color(0xffffffff),),
                ),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: paleGreenColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greenColor)),
                  labelStyle: TextStyle(color: greenColor)),
              scaffoldBackgroundColor: biegeColor,
            appBarTheme: AppBarTheme(
              backgroundColor: biegeColor,
              elevation: 0,
              titleTextStyle: Theme.of(context).textTheme.headline5,
              iconTheme: IconThemeData(
                color: coralColor
              )
            ),
          ),
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

