import 'package:flutter/material.dart';
import 'package:stockapp/services/auth/auth_service.dart';

class EmailVerifyView extends StatelessWidget {
  const EmailVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email verification'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Please verify your email by clicking button below.'),
            ElevatedButton(
                onPressed: () async {
                  final user = AuthService.firebase().currentUser;
                  if (user != null && !user.isEmailVerified) {
                    await AuthService.firebase().sendEmailVerification();
                  }
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login/', (route) => false);
                },
                child: const Text('Verify')),
          ],
        ),
      ),
    );
  }
}
