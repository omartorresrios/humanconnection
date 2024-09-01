import 'package:flutter/material.dart';
import 'package:humanconnection/auth_manager.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  Future signIn() async {
    AuthManager().signIn();
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
              child: GestureDetector(onTap: signIn, child: Text("Sign in"))),
        ),
      ),
    );
  }
}
