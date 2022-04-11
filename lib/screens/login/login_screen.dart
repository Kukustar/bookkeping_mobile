import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookkeping_mobile/auth/auth_bloc.dart';
import 'package:bookkeping_mobile/auth/auth_event.dart';

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
                            BlocProvider
                                .of<AuthBloc>(context)
                                .add(LoginUser(
                                emailEditingController.text,
                                passwordEditingController.text
                            ));
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