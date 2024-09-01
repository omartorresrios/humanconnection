import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:humanconnection/views/login_view.dart';
import 'package:humanconnection/views/main_view.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainView();
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}
