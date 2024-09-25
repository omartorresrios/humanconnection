import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanconnection/auth_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  String notificationStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    checkNotificationPermission();
  }

  void updateNotificationStatus() {
    checkNotificationPermission();
  }

  Future<void> checkNotificationPermission() async {
    var status = await Permission.notification.status;
    setState(() {
      if (status.isGranted) {
        notificationStatus = "Enabled";
      } else if (status.isPermanentlyDenied) {
        notificationStatus = "Disabled";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("General"),
            Container(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Colors.transparent,
                  backgroundColor: Color.fromARGB(255, 111, 149, 184),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                },
                child: const Text('Email'),
              ),
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Colors.transparent,
                  backgroundColor: Color.fromARGB(255, 111, 149, 184),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                },
                child: const Text('Discord or similar'),
              ),
            ),
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    notificationStatus,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Text("Account"),
            Container(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Colors.transparent,
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  signOut();
                },
                child: const Text('Sign Out'),
              ),
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Colors.transparent,
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  deleteAccount();
                },
                child: const Text('Delete account'),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}

Future signOut() async {
  AuthManager().signOut();
}

Future deleteAccount() async {
  AuthManager().deleteAccount();
}
