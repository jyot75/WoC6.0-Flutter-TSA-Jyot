// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stockapp/constants/routes.dart';
import 'package:stockapp/services/auth/auth_exceptions.dart';
import 'package:stockapp/services/auth/auth_service.dart';
import 'package:stockapp/utilities/show_error_dialogue.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your E-mail'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: 'Enter your Password'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );

                AuthService.firebase().sendEmailVerification();

                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              } on WeakPasswordAuthException {
                await showErrorDialogue(
                  context,
                  'Weak password, Please try to make  strong password',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialogue(
                  context,
                  'Email is already registered',
                );
              } on InvalidEmailAuthException {
                await showErrorDialogue(
                  context,
                  'Email is invalid',
                );
              } on GenericAuthException {
                await showErrorDialogue(
                  context,
                  'Some authentication error',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Already have an account? Login here!")),
        ],
      ),
    );
  }
}
