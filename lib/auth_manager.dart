import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:humanconnection/models/current_user.dart';

class AuthManager {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final userIsLoggedInController =
      StreamController<CurrentUserInfo?>.broadcast();
  static Stream<CurrentUserInfo?> get userIsLoggedIn =>
      userIsLoggedInController.stream;

  signIn() async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? auth = await user?.authentication;
    if (auth != null) {
      final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      await _firebaseAuth.signInWithCredential(credential);
      await validateToken(auth.idToken!);
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
        var currentUser = parseCurrentUser(response.body);
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

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  signOut() async {
    _firebaseAuth.signOut();
    userIsLoggedInController.add(null);
  }
}
