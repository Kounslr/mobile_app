import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:kounslr/src/config/authentication_exceptions.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/studentvue_repository.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  AuthenticationRepository(this._firebaseAuth);

  final CollectionReference userRef = FirebaseFirestore.instance
      .collection('customers/lcps/schools/independence/students');

  final CollectionReference classesRef = FirebaseFirestore.instance
      .collection('customers/lcps/schools/independence/classes');

  Future<void> _createUserInDatabase(User user) async {
    await userRef.doc(user.uid).set({'id': user.uid, 'email': user.email});
  }

  Future<void> _createStudentInDatabase(Student student) async {
    await userRef.doc(student.id).update(student.toMap());

    var allClasses = await classesRef.get();

    for (int i = 0; i < allClasses.docs.length; i++) {
      await classesRef.doc(allClasses.docs[i].id).update({
        'students': [
          ...allClasses.docs[i]['students'],
          student.idOnly().toMap(),
        ],
      });

      await userRef
          .doc('${student.id}/classes/${allClasses.docs[i].id}')
          .set(student.toStudentInClass().toMap());

      var assignmentsRef =
          await allClasses.docs[i].reference.collection('assignments').get();

      for (var item in assignmentsRef.docs) {
        await item.reference.update({
          'students': [
            ...item['students'],
            student.toStudentInAssignment().toMap(),
          ],
        });
      }
    }
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

      final googleAuth = await googleUser.authentication;

      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final credential =
          await FirebaseAuth.instance.signInWithCredential(googleCredential);

      var userDataRef = await userRef.doc(credential.user!.uid).get();

      if (!userDataRef.exists || credential.additionalUserInfo!.isNewUser) {
        await _createUserInDatabase(credential.user!);

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

      await _createStudentInDatabase(student);

      return 'success';
    } catch (e) {
      return 'failed';
    }
  }

  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      var user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _createUserInDatabase(user.user!);

      return 'success';
    } catch (e) {
      return 'failed';
    }
  }
}
