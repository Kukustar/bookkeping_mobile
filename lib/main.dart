import 'package:bookkeping_mobile/screens/home/home_screen.dart';
import 'package:bookkeping_mobile/screens/login/login_screen.dart';
import 'package:bookkeping_mobile/service/core/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp( const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Future<bool> get checkAccessToken async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? expireDateString = prefs.getString('expire_date');

    if (ApiService().isAccessTokenValid(expireDateString)) {
      return true;
    } else if (ApiService().isCanUpdateAccessToken(expireDateString)) {
      ApiService().updateAccessToken();
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkAccessToken,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData) {
          if (snapshot.data == true) {
            return  MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData.light(),
              home: HomeScreen(),
              // home: HomeScreen(),
            );
          } else {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData.light(),
              home: const LoginScreen(),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      }
    );
  }
}

