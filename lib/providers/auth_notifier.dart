import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthNotifier with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Status _status = Status.Unauthenticated;
  User? _user;

  Status get status => _status;
  User? get user => _user;
  AuthNotifier() {
    _auth.authStateChanges().listen((User? firebaseUser) {
      debugPrint('auth changed. current user = $firebaseUser');
      if (firebaseUser == null) {
        _user = null;
        _status = Status.Unauthenticated;
      } else {
        _user = firebaseUser;
        _status = Status.Authenticated;
      }
      notifyListeners();
    });
  }
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  void signOut()  {
    _user = null;
    _status = Status.Unauthenticated;
    notifyListeners();
    _auth.signOut();
}

}

enum Status { Unauthenticated, Authenticating, Authenticated }
