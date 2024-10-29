import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
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

  static setCurrentUser(UserData user) {
    userIsLoggedInController.add(user);
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
    try {
      /// Remove this conditional. Only useful when testing with simulators
      if (!await isSimulator()) {
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await Service.saveFCMToken(fcmToken);
        }
      } else {
        print('Running on iOS simulator. Skipping FCM token retrieval.');
      }
    } catch (e) {
      print('Error retrieving FCM token: $e');
    }
  }

  Future<bool> isSimulator() async {
    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return !iosInfo.isPhysicalDevice;
    }
    return false;
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
