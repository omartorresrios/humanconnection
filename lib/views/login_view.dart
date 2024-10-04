import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanconnection/auth_manager.dart';
import 'package:humanconnection/views/onboarding/onboarding_location_permission_view.dart';

class LoginView extends StatefulWidget {
  final bool onboarding;

  const LoginView({super.key, required this.onboarding});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Future signIn() async {
    AuthManager().signIn((bool onComplete) {
      if (onComplete && widget.onboarding) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OnboardingLocationPermissionView(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Humanconnection"),
            const SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom(
                  overlayColor: Colors.transparent,
                  backgroundColor: Colors.red),
              onPressed: () {
                HapticFeedback.heavyImpact();
                signIn();
              },
              child: const Text('Sign in'),
            ),
          ],
        ),
      )),
    );
  }
}
