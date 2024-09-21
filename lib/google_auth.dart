import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  static User? user = FirebaseAuth.instance.currentUser;

  static Future<User?> signinWithGoogle() async {
    try {
      final googleAccount = await GoogleSignIn().signIn();
      if (googleAccount == null) {
        // The user canceled the sign-in
        return null;
      }
      final googleAuth = await googleAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Error during Google sign-in: $e');
      return null;
    }
  }

  static Future<void> signoutWithGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      print('Error during Google sign-out: $e');
    }
  }
}