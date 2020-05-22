import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_inventory/models/usermodel.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  UserModel user;

  bool isLoggedIn = false;

  Future<void> signInAutomatically() async {
    if (_googleSignIn.currentUser != null) {
      try {
        GoogleSignInAccount googleSignInAccount =
            await _googleSignIn.signInSilently();

        if (googleSignInAccount != null) {
          var user =
              await _getUserModelUsingGoogleSignInAccount(googleSignInAccount);
          if (user == null) {
            isLoggedIn = false;
          } else {
            isLoggedIn = true;
          }
        } else {
          isLoggedIn = false;
        }
      } catch (error) {
        print(error);
      }
    } else {
      isLoggedIn = false;
      return;
    }

    notifyListeners();
  }

  UserModel _userModelFromFirebaseUser(FirebaseUser fbUser) {
    user = fbUser != null
        ? UserModel(
            uid: fbUser.uid,
            name: fbUser.displayName,
            photourl: fbUser.photoUrl,
          )
        : null;

    return user;
  }

  Stream<UserModel> get userStream {
    return _auth.onAuthStateChanged.map<UserModel>(_userModelFromFirebaseUser);
    //  var account = googleSignIn.onCurrentUserChanged;
    //  return account==null?
  }

  Future<UserModel> _getUserModelUsingGoogleSignInAccount(
      GoogleSignInAccount googleSignInAccount) async {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    return _userModelFromFirebaseUser(user);
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    var user = await _getUserModelUsingGoogleSignInAccount(googleSignInAccount);

    if (user == null) {
      isLoggedIn = false;
    } else {
      isLoggedIn = true;
    }

    notifyListeners();
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    isLoggedIn = false;
    notifyListeners();
  }
}
