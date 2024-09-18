import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:humanconnection/helpers/notification_service.dart';
import 'package:humanconnection/main.dart';
import 'dart:async';
import 'package:humanconnection/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:humanconnection/views/exploration_details_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/service.dart';
import 'models/exploration.dart';

class AuthManager {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final userIsLoggedInController =
      StreamController<UserData?>.broadcast();
  static Stream<UserData?> get userIsLoggedIn =>
      userIsLoggedInController.stream;

  signIn() async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? auth = await user?.authentication;
    if (auth != null) {
      final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      await _firebaseAuth.signInWithCredential(credential);
      await Service.validateToken(auth.idToken!, (UserData? currentUser) {
        userIsLoggedInController.add(currentUser);
        setupFirebaseMessaging(auth.idToken!);
      });
    }
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void setupFirebaseMessaging(String currentUserToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isPermissionRequested = prefs.getBool('isPermissionRequested');
    if (isPermissionRequested == null || !isPermissionRequested) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      print('authorizationStatus: ${settings.authorizationStatus}');
      await prefs.setBool('isPermissionRequested', true);
    } else {
      print('Notification permission has already been requested.');
    }
    String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      print("fcmToken: ${fcmToken}");
      await Service.saveFCMToken(fcmToken);
      setupForegroundNotifications();
    }
  }

  void setupForegroundNotifications() async {
    print('hellooooooo');
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    setNotificationCountToExplorationUponNewNotificationArriving();
    openExplorationViewOnNotificationTap();
  }

  void setNotificationCountToExplorationUponNewNotificationArriving() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        try {
          print('Got a message whilst in the foreground!');
          var matchedExplorationId = message.data["exploration_id"];
          print('matchedExploration: $matchedExplorationId');
          if (message.notification?.apple?.badge != null) {
            NotificationService().addNotificationToExploration(
                matchedExplorationId,
                int.parse(message.notification!.apple!.badge!));
          }
        } catch (e) {
          print('Error processing message: $e');
          // Handle the error accordingly, e.g., show an alert or log it
        }
      },
      onError: (error) {
        // Handle any errors that occur while listening to messages
        print('Error occurred while listening for messages: $error');
      },
    );
  }

  void openExplorationViewOnNotificationTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var matchedExplorationId = message.data["exploration_id"];
      final provider = NotificationService().provider;
      Exploration? exploration = provider.explorations.firstWhere(
        (exp) => exp.id == matchedExplorationId,
        orElse: () => throw Exception('Failed to find exploration'),
      );
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) =>
              ExplorationDetailsView(exploration: exploration),
        ),
      );
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
