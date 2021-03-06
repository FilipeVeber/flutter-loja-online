import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

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
      firebaseUser = authResult.user;

      await _loadCurrentUser();

      onSuccess();
    }).catchError((e) {
      onFail();
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
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
      firebaseUser = user.user;

      await _saveUserData(userData);

      onSuccess();
    }).catchError((error) {
      onFail();
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  void recoverPassword(String email) {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  void signOut() async {
    await _firebaseAuth.signOut();
    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  Future _loadCurrentUser() async {
    if (firebaseUser == null) {
      firebaseUser = await _firebaseAuth.currentUser();
    }

    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }

    notifyListeners();
  }
}
