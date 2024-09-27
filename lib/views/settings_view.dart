import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanconnection/auth_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

enum NotificationStatus {
  enabled,
  disabled,
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  NotificationStatus notificationStatus = NotificationStatus.disabled;

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
        notificationStatus = NotificationStatus.enabled;
      } else if (status.isPermanentlyDenied) {
        notificationStatus = NotificationStatus.disabled;
      }
    });
  }

  Future<void> sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'torresomar44@gmail.com',
      query: Uri.encodeFull('Subject=HumanConnection feedback&body='),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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
                  sendEmail();
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
                    capitalize(notificationStatus.toString().split('.').last),
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (notificationStatus == NotificationStatus.disabled)
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Color.fromARGB(0, 40, 107, 183),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  AppSettings.openAppSettings();
                },
                child: const Text('Cancel'),
              ),
            const SizedBox(height: 20),
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
