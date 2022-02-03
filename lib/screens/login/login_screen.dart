import 'dart:convert';

import 'package:bookkeping_mobile/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  void sendLoginRequest() async {
    try {
      http.Response response = await http.post(
        Uri.parse('http://localhost:3003/api/token/'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'username': emailEditingController.text,
          'password': passwordEditingController.text
        }
      );

      if (response.statusCode == 401) {
        var jsonResponse = json.decode(response.body);
        final String errorText = jsonResponse['detail'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorText)),
        );
      }

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        final String accessToken = jsonResponse['access'];
        final String refreshToken = jsonResponse['refresh'];

        final SharedPreferences prefs = await _prefs;
        await prefs.setString('access', accessToken);
        await prefs.setString('refresh', refreshToken);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
        );
      }
    } catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailEditingController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter email';
                  }
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: passwordEditingController,
                obscuringCharacter: '*',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter password';
                  }
                },
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 20))
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print('send request');
                            sendLoginRequest();
                          }
                        },
                        child: Text('LOGIN')
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
  
}