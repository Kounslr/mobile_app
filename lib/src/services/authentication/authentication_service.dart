import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    Navigator.pop(context);
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Sign in successful';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password, String id}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await DatabaseService(uid: (FirebaseAuth.instance.currentUser).uid)
          .initialUpdateUserData(id: id);

      return 'Sign up successful';
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }
}

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference user = FirebaseFirestore.instance
      .collection('customers')
      .doc('lcps')
      .collection('schools')
      .doc('independence')
      .collection('students');

  Future<void> initialUpdateUserData({String id}) async {
    await user.doc(uid).set({
      'id': id,
    });
  }
}
