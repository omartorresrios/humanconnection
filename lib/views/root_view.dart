import 'package:flutter/material.dart';
import 'package:humanconnection/auth_manager.dart';
import 'package:humanconnection/views/login_view.dart';
import 'package:humanconnection/views/main_view.dart';
import '../models/user.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  _RootViewState createState() => _RootViewState();
}

class _RootViewState extends State<RootView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // The app has been opened or brought to the foreground
      print('App is in the foreground');
      // Perform any action needed when the app is opened
    } else if (state == AppLifecycleState.paused) {
      // The app is in the background
      print('App is in the background');
    }
  }

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
