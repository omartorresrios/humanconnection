import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthManager {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  signIn() async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? auth = await user?.authentication;
    if (auth != null) {
      final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      return await _firebaseAuth.signInWithCredential(credential);
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  signOut() async {
    _firebaseAuth.signOut();
  }
}
