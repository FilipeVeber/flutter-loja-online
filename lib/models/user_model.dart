import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signIn(
      {@required String email,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((authResult) async {
      _firebaseUser = authResult.user;

      await _loadCurrentUser();

      onSuccess();

      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });

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

  Future _loadCurrentUser() async {
    if (_firebaseUser == null) {
      _firebaseUser = await _firebaseAuth.currentUser();
    }

    if (_firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(_firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }

    notifyListeners();
  }
}
