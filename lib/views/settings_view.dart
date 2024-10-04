import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:humanconnection/auth_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum PermissionStatus {
  enabled,
  disabled,
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  PermissionStatus notificationStatus = PermissionStatus.disabled;
  PermissionStatus locationStatus = PermissionStatus.disabled;
  String currentLocation = "";

  @override
  void initState() {
    super.initState();
    checkNotificationPermission();
    checkLocationPermission();
  }

  void updateNotificationStatus() {
    checkNotificationPermission();
  }

  void updateLocationStatus() {
    checkLocationPermission();
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
            const Text("General"),
            TextButton(
              style: TextButton.styleFrom(
                overlayColor: Colors.transparent,
                backgroundColor: Color.fromARGB(255, 111, 149, 184),
                padding: EdgeInsets.zero,
              ),
              onPressed: () async {
                HapticFeedback.heavyImpact();
                await sendEmail();
              },
              child: const Text('Email'),
            ),
            TextButton(
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
            location(),
            Row(
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
            if (notificationStatus == PermissionStatus.disabled)
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
                child: const Text('Enable notifications'),
              ),
            const SizedBox(height: 20),
            const Text("Account"),
            TextButton(
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
            TextButton(
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
          ],
        ),
      ),
    )));
  }

  Widget location() {
    return Row(
      children: [
        const Text(
          "Location",
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        locationStatus == PermissionStatus.disabled
            ? TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Colors.transparent,
                  backgroundColor: Color.fromARGB(255, 111, 149, 184),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () async {
                  HapticFeedback.heavyImpact();
                  AppSettings.openAppSettings();
                },
                child: const Text('Enabled'),
              )
            : Text(
                currentLocation,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
      ],
    );
  }

  Future<void> checkNotificationPermission() async {
    var status = await Permission.notification.status;
    setState(() {
      if (status.isGranted) {
        notificationStatus = PermissionStatus.enabled;
      } else if (status.isPermanentlyDenied) {
        notificationStatus = PermissionStatus.disabled;
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

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    setState(() {
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        locationStatus = PermissionStatus.disabled;
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        locationStatus = PermissionStatus.enabled;
        fetchCityName();
      }
    });
  }

  Future<void> fetchCityName() async {
    String cityName = await getCity();
    setState(() {
      currentLocation = cityName;
    });
  }

  Future<String> getCity() async {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      return placemarks[0].locality ?? "City not found";
    } else {
      return "City not found";
    }
  }
}

Future signOut() async {
  AuthManager().signOut();
}

Future deleteAccount() async {
  AuthManager().deleteAccount();
}
