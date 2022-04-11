
import 'package:bookkeping_mobile/screens/home/home_screen.dart';
import 'package:bookkeping_mobile/service/core/api_service.dart';
import 'package:bookkeping_mobile/service/core/network_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  void sendLoginRequest() async {
    NetworkResponse response = await ApiService().authUser(emailEditingController.text, passwordEditingController.text);

    if (response.status == NetworkResponseStatus.failed) {
      final String errorText = response.body['detail'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorText)),
      );
    }

    if (response.status == NetworkResponseStatus.success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
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
                autocorrect: false,
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
                            sendLoginRequest();
                          }
                        },
                        child: Text('Войти')
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