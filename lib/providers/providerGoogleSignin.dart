import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProviderGoogleSignin with ChangeNotifier {
  final googlesignin = GoogleSignIn();
  bool _isSigningIn = false;

  ProviderGoogleSignin() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool issigningin) {
    _isSigningIn = issigningin;
    notifyListeners();
  }

  Future login() async {
    isSigningIn = true;
    var user = await googlesignin.signIn();
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleauth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken,
        idToken: googleauth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      isSigningIn = false;
    }
  }

  Future logout() async {
    await googlesignin.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
