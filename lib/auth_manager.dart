import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:humanconnection/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'helpers/service.dart';

class AuthManager {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final userIsLoggedInController =
      StreamController<UserData?>.broadcast();
  static Stream<UserData?> get userIsLoggedIn =>
      userIsLoggedInController.stream;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  signIn() async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? auth = await user?.authentication;
    if (auth != null) {
      final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      await _firebaseAuth.signInWithCredential(credential);
      await Service.validateToken(auth.idToken!, (UserData? currentUser) {
        userIsLoggedInController.add(currentUser);
      });
      setupFirebaseMessaging(auth.idToken!);
    }
  }

  void setupFirebaseMessaging(String currentUserToken) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      setupLocalNotifications();
    } else {
      print('User declined or has not accepted permission');
    }
    String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      await Service.saveFCMToken(fcmToken);
    }
  }

  void setupLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true);

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${message.data}');

      if (message.notification != null) {
        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'your_channel_id',
              'your_channel_name',
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );
      }
    });
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  signOut() async {
    _firebaseAuth.signOut();
    userIsLoggedInController.add(null);
    await Service.signOutInBackend();
  }
}
