import 'package:canton_design_system/canton_design_system.dart';
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

  Future<String> signOut(BuildContext context) async {
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
      var googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return 'failed';

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
      var userData = userDataRef.data();

      if (credential.additionalUserInfo!.isNewUser || userData == null) {
        String id = user!.uid;
        String firstName = toBeginningOfSentenceCase(user.displayName!
            .substring(0, user.displayName!.indexOf(' '))
            .toLowerCase())!;
        String lastName = toBeginningOfSentenceCase(user.displayName!
            .substring(user.displayName!.lastIndexOf(' ') + 1)
            .toLowerCase())!;
        String imageUrl = user.photoURL!;
        await _createUserInDatabase(credential.user!);

        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
            id: id,
            firstName: firstName,
            lastName: lastName,
            imageUrl: imageUrl,
          ),
        );

        return 'new';
      }

      return 'success';
    } catch (e) {
      print(e);
      if (e is FirebaseAuthException) {
        return AuthenticationExceptions.fromFirebaseAuthError(e).toString();
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
    String? domain,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }
}
