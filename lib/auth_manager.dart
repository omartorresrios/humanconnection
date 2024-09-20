import 'package:firebase_auth/firebase_auth.dart';
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
    String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      print("fcmToken: ${fcmToken}");
      await Service.saveFCMToken(fcmToken);
    }
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
