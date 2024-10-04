import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_notifications_permission_view.dart';

class OnboardingLocationPermissionView extends StatefulWidget {
  const OnboardingLocationPermissionView({super.key});

  @override
  State<OnboardingLocationPermissionView> createState() =>
      OnboardingLocationPermissionViewState();
}

class OnboardingLocationPermissionViewState
    extends State<OnboardingLocationPermissionView> {
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
                await requestPermission();
              },
              child: const Text('Allow location'),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'locationGranted',
        permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse);
    if (mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingNotificationPermissionView(),
          ));
    }
  }
}
