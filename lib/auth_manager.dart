import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:humanconnection/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'helpers/service.dart';

class AuthManager {
  static UserData? _currentUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final userIsLoggedInController =
      StreamController<UserData?>.broadcast();
  static Stream<UserData?> get userIsLoggedIn =>
      userIsLoggedInController.stream;

  static Future<UserData?> getCurrentUser() async {
    return _currentUser;
  }

  signIn(Function(bool) onComplete) async {
    try {
      final GoogleSignInAccount? user = await GoogleSignIn().signIn();
      if (user == null) {
        return;
      }

      final GoogleSignInAuthentication auth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
      await Service.validateToken(auth.idToken!, (UserData? currentUser) {
        userIsLoggedInController.add(currentUser);
        _currentUser = currentUser;
        onComplete(true);
        setupFirebaseMessaging(auth.idToken!);
      });
    } catch (e) {
      print("Error during sign-in: $e");
    }
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void setupFirebaseMessaging(String currentUserToken) async {
    String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      await Service.saveFCMToken(fcmToken);
    }
  }

  signOut() async {
    _firebaseAuth.signOut();
    userIsLoggedInController.add(null);
    await Service.signOutInBackend();
  }

  deleteAccount() async {
    _firebaseAuth.currentUser?.delete();
    userIsLoggedInController.add(null);
    await Service.deleteAccountInBackend();
  }
}
