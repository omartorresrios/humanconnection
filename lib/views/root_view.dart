import 'package:flutter/material.dart';
import 'package:humanconnection/auth_manager.dart';
import 'package:humanconnection/models/current_user.dart';
import 'package:humanconnection/views/login_view.dart';
import 'package:humanconnection/views/main_view.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<CurrentUserInfo?>(
        stream: AuthManager.userIsLoggedIn,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainView(userPictureUrl: snapshot.data!.picture);
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}
