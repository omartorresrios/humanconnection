import 'package:flutter/material.dart';
import '../auth_manager.dart';
import '../models/user.dart';
import 'login_view.dart';
import 'main_view.dart';

class FlowValidatorView extends StatefulWidget {
  const FlowValidatorView({super.key});

  @override
  State<FlowValidatorView> createState() => FlowValidatorViewState();
}

class FlowValidatorViewState extends State<FlowValidatorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserData?>(
        stream: AuthManager.userIsLoggedIn,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainView(user: snapshot.data!);
          } else {
            return const LoginView(onboarding: false);
          }
        },
      ),
    );
  }
}
