import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  void signIn() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));
    isLoading = false;
    notifyListeners();
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _firebaseAuth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: password)
        .then((user) async {
      _firebaseUser = user.user;

      await _saveUserData(userData);

      onSuccess();

      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();

      isLoading = false;
      notifyListeners();
    });
  }

  void recoverPassword() {}

  bool isLoggedIn() {
    return _firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(_firebaseUser.uid)
        .setData(userData);
  }

  void signOut() async {
    await _firebaseAuth.signOut();
    userData = Map();
    _firebaseUser = null;

    notifyListeners();
  }
}
