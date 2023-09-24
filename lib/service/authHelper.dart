import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';


class AuthHelper {
  AuthHelper._();
  static AuthHelper authHelper = AuthHelper._();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;

    } catch(signUpError) {
      if(signUpError is PlatformException) {
        if(signUpError.code == 'The email address is already in use by another account.') {
          // 'This email has alread been registered';
        }
      }
    }
  }



  Future<User?> login(String email, String password) async {
    UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  logout() async {
    await firebaseAuth.signOut();
  }

  User? getCurrentUserId() {
    return firebaseAuth.currentUser;
  }
}