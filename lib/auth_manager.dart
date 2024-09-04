import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:humanconnection/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthManager {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final userIsLoggedInController =
      StreamController<UserData?>.broadcast();
  String currentUserAuthenticationToken = "";
  static Stream<UserData?> get userIsLoggedIn =>
      userIsLoggedInController.stream;

  signIn() async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? auth = await user?.authentication;
    if (auth != null) {
      final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      await _firebaseAuth.signInWithCredential(credential);
      await validateToken(auth.idToken!);
      setupFirebaseMessaging(auth.idToken!);
    }
  }

  Future<void> validateToken(String token) async {
    const url = 'http://192.168.1.86:3000/api/users/auth/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'AUTHORIZATION_TOKEN': token},
      );
      if (response.statusCode == 200) {
        var currentUser = parseUser(response.body);
        currentUserAuthenticationToken =
            json.decode(response.body)['authentication_token'];
        userIsLoggedInController.add(currentUser);
      } else {
        print("Token validation failed with status: ${response.toString()}");
        userIsLoggedInController.add(null);
      }
    } catch (e) {
      print("Token validation failed with error: $e");
      userIsLoggedInController.add(null);
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
    } else {
      print('User declined or has not accepted permission');
    }
    String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      await saveFCMToken(fcmToken, currentUserToken);
    }
  }

  Future<void> signOutInBackend() async {
    const url = 'http://192.168.1.86:3000/api/users/auth/logout';
    try {
      await http.post(Uri.parse(url));
    } catch (e) {
      print("Token validation failed with error: $e");
    }
  }

  Future<void> saveFCMToken(String fcmToken, String currentUserToken) async {
    const url = 'http://192.168.1.86:3000/api/users/auth/save_fcm_token';
    try {
      await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'FCM_TOKEN': fcmToken,
        'Authorization': 'Bearer $currentUserAuthenticationToken',
      });
    } catch (e) {
      print("Error when trying to save fcm token: $e");
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  signOut() async {
    _firebaseAuth.signOut();
    userIsLoggedInController.add(null);
    await signOutInBackend();
  }
}
