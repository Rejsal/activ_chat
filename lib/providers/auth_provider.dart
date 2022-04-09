import 'package:activ_chat/models/user_model.dart';
import 'package:activ_chat/utils/firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
  loading
}

class AuthProvider with ChangeNotifier {
  final FirestoreHelper _userHelper = FirestoreHelper('users');
  final FirebaseAuth _auth;
  User? _user;
  UserModel? _userInfo;
  Status _status = Status.uninitialized;
  String? _error;

  AuthProvider() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;
  User? get user => _user;
  UserModel? get userInfo => _userInfo;
  String? get error => _error;

  //firebase log in
  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      var auth = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      var userData = await _userHelper.getDocumentById(auth.user?.uid ?? "");
      _userInfo = UserModel.fromFirestore(userData, auth.user?.uid ?? "");
      _user = auth.user;
      _status = Status.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = Status.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  // get user details from email
  Future<UserModel?> getUserDetailFromEmail(String email) async {
    var doc = await _userHelper.getUserDocumentByEmail(email);
    var docList =
        doc.docs.map((doc) => UserModel.fromFirestore(doc, doc.id)).toList();
    if (docList.isNotEmpty) {
      return docList[0];
    } else {
      return null;
    }
  }

  //firebase sign up
  Future<bool> signUp(String username, String email, String password) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      var auth = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var user = UserModel(
          id: auth.user?.uid,
          uid: auth.user?.uid,
          email: auth.user?.email,
          name: username);
      if (auth.user?.uid != null) {
        await _userHelper.addDocumentById(user.toJson(), auth.user?.uid ?? "");
        _userInfo = user;
        _user = auth.user;
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _status = Status.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  //sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _status = Status.unauthenticated;
      notifyListeners();
    } catch (e) {
      notifyListeners();
      throw Exception(e);
    }
  }

  //authentication  state change
  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _status = Status.loading;
    notifyListeners();
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
      notifyListeners();
    } else {
      var userData = await _userHelper.getDocumentById(firebaseUser.uid);
      Future.delayed(const Duration(milliseconds: 50), () {
        _userInfo = UserModel.fromFirestore(userData, firebaseUser.uid);
        _user = firebaseUser;
        _status = Status.authenticated;
        notifyListeners();
      });
    }
  }
}
