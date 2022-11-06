// ignore_for_file: must_be_immutable

import 'package:berchem_pizza_web/blocks/login/auth/auth_provider.dart';
import 'package:berchem_pizza_web/screens/login/login_page.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatelessWidget {
  VerifyEmailView({super.key});
  AuthProvider? provider;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "We've sent you an email with verificaiton link",
              style: TextStyle(fontSize: 15),
            ),
            const Text(
              "Please verify your email",
              style: TextStyle(fontSize: 15),
            ),
            const Text(
              "Didn't get an email?",
              style: TextStyle(fontSize: 15),
            ),
            InkWell(
                onTap: () async {
                  await provider!.sendEmailVerification();
                },
                child: const Text(
                  "Click here to sent again",
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                )),
            InkWell(
                onTap: () async {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text(
                  "Verified your email? Click here to login",
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                )),
          ],
        ),
      ),
    );
  }
}
