// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stockapp/constants/routes.dart';
import 'package:stockapp/services/auth/auth_exceptions.dart';
import 'package:stockapp/services/auth/auth_service.dart';
import 'package:stockapp/utilities/show_error_dialogue.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );

                final user = AuthService.firebase().currentUser;

                if (user != null && user.isEmailVerified) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else if (user == null) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                } else if (!user.isEmailVerified) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await showErrorDialogue(
                  context,
                  'User not found',
                );
              } on WrongPasswordAuthException {
                await showErrorDialogue(
                  context,
                  'Wrong password',
                );
              } on InvalidCredentialsAuthException {
                await showErrorDialogue(
                  context,
                  'Invalid Email or password',
                );
              } on GenericAuthException {
                await showErrorDialogue(
                  context,
                  'Some Authentication Error',
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("Don't have an account? register here !!")),
          ElevatedButton(
              onPressed: () async {
                // await AuthService.signInWithGoogle(context: context);
              },
              child: const Text('Sign in with Google')),
        ],
      ),
    );
  }
}
