import 'package:flutter/material.dart';
import 'package:humanconnection/auth_manager.dart';
import 'package:humanconnection/views/login_view.dart';
import 'package:humanconnection/views/main_view.dart';
import '../models/user.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserData?>(
        stream: AuthManager.userIsLoggedIn,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainView(user: snapshot.data!);
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}
