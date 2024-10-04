import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanconnection/auth_manager.dart';
import 'package:humanconnection/models/user.dart';
import 'package:humanconnection/views/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingNotificationPermissionView extends StatefulWidget {
  const OnboardingNotificationPermissionView({super.key});

  @override
  State<OnboardingNotificationPermissionView> createState() =>
      OnboardingNotificationPermissionViewState();
}

class OnboardingNotificationPermissionViewState
    extends State<OnboardingNotificationPermissionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("This is a convincing text!"),
            const SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom(
                  overlayColor: Colors.transparent,
                  backgroundColor: Colors.red),
              onPressed: () async {
                HapticFeedback.heavyImpact();
                await completeOnboardingAndShowMainView();
              },
              child: const Text('Lets go!'),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> completeOnboardingAndShowMainView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
    UserData? currentUser = await AuthManager.getCurrentUser();
    if (currentUser != null && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainView(user: currentUser)),
        (Route<dynamic> route) => false,
      );
    }
  }
}
