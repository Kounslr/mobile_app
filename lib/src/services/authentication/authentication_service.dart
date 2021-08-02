import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'package:kounslr/src/config/authentication_exceptions.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/chat_repository.dart';
import 'package:kounslr/src/services/repositories/studentvue_repository.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  final CollectionReference userRef = FirebaseFirestore.instance
      .collection('customers')
      .doc('lcps')
      .collection('schools')
      .doc('independence')
      .collection('students');

  Future<void> _createUserInDatabase(User user) async {
    await userRef.doc(user.uid).set({'id': user.uid, 'email': user.email});
  }

  Future<void> _createStudentInDatabase(Student student) async {
    await userRef.doc(student.id).update(student.toMap());
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();

      return 'success';
    } catch (e) {
      if (e is FirebaseAuthException) {
        return AuthenticationExceptions.fromFirebaseAuthError(e).toString();
      }
      return 'failed';
    }
  }

  Future<String> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return 'success';
    } catch (e) {
      if (e is FirebaseAuthException) {
        return AuthenticationExceptions.fromFirebaseAuthError(e).toString();
      }
      return 'failed';
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return '';

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final credential =
          await FirebaseAuth.instance.signInWithCredential(googleCredential);

      var user = FirebaseAuth.instance.currentUser;
      var userDataRef = await userRef.doc(credential.user!.uid).get();

      if (!userDataRef.exists || credential.additionalUserInfo!.isNewUser) {
        await _createUserInDatabase(credential.user!);
        String id = user!.uid;
        String imageUrl = user.photoURL!;

        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
            id: id,
            imageUrl: imageUrl,
          ),
        );

        return 'new';
      }

      return 'success';
    } catch (e) {
      if (e is FirebaseAuthException) {
        return AuthenticationExceptions.fromFirebaseAuthError(e).toString();
      } else if (e is RangeError) {
        return '';
      }
      return 'failed';
    }
  }

  Future<String> studentVueSignIn({
    required String email,
    required String password,
  }) async {
    try {
      var student = Student();
      String username = email.substring(0, email.indexOf('@'));
      String domain = 'portal.lcps.org';
      student =
          await StudentVueClient(username, password, domain).loadStudentData();

      student.id = FirebaseAuth.instance.currentUser?.uid;

      if (student.studentId == null) return 'failed';

      _createStudentInDatabase(student);

      return 'success';
    } catch (e) {
      return 'failed';
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      var user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _createUserInDatabase(user.user!);

      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          id: user.user!.uid,
          imageUrl: '',
        ),
      );
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }
}
