import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:async';

class Auth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignin = GoogleSignIn();
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

  static FirebaseUser user;

  static Future<bool> googleSignIn() async {
    bool isSingedIn = false;
    GoogleSignInAccount googleSignInAccount = await googleSignin.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    await auth
        .signInWithGoogle(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken)
        .then((user) {
      print("Auth googleSignIn! User signed in: User id is: ${user.uid}");
      isSingedIn = true;
    }).catchError((error) {
      print("Auth googleSignIn! Something went wrong! ${error.toString()}");
    });

    return isSingedIn;
  }

  static Future<bool> emailSignIn(String email, String password) async {
    bool isSignedIn = false;

    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      print("Auth emailSignIn! User signed in: User id is: ${user.uid}");
      isSignedIn = true;
    }).catchError((error) {
      print("Auth emailSignIn! Something went wrong! ${error.toString()}");
    });

    return isSignedIn;
  }

  static Future<bool> createUser(String email, String password) async {
    bool isCreated = false;

    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) {
      print("Auth createUser! User created: User id is ${user.uid}");
      isCreated = true;
    }).catchError((error) {
      print("Auth createUser! Something went wrong! ${error.toString()}");
    });

    return isCreated;
  }

  static Future<bool> checkSignIn() async {
    user = await auth.currentUser().catchError((error) {
      print("Auth checkSignIn! Something went wrong! ${error.toString()}");
    });

    if (user != null) {
      print("Auth checkSignIn! uid: ${user.uid} email: ${user.email}");
      analytics.logLogin();
      return true;
    } else {
      print("Auth checkSignIn! User is NOT signed in");
    }

    return false;
  }

  static Future<bool> signOut() async {
    bool isSignedOut = false;

    await auth.signOut().then((b) {
      print("Auth signOut! User signed out");
      isSignedOut = true;
    }).catchError((error) {
      print("Auth signOut! Something went wrong! ${error.toString()}");
    });

    return isSignedOut;
  }

  static Future<bool> sendPasswordResetEmail(String email) async {
    bool isSent = false;
    await auth.sendPasswordResetEmail(email: email).then((b) {
      print("Auth sendPasswordResendEmail! Reset e-mail sent");
      isSent = true;
    }).catchError((error) {
      print("Auth sendPasswordResendEmail! Something went wrong! ${error
          .toString()}");
    });

    return isSent;
  }
}
