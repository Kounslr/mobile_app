/*
Kounslr iOS & Android App
Copyright (C) 2021 Kounslr

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:kounslr/src/config/authentication_exceptions.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/studentvue_repository.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  AuthenticationRepository(this._firebaseAuth);

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('customers/lcps/schools/independence/students');

  final CollectionReference classesRef =
      FirebaseFirestore.instance.collection('customers/lcps/schools/independence/classes');

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

  Future<String> signInWithEmailAndPassword({required String email, required String password}) async {
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

      final credential = await FirebaseAuth.instance.signInWithCredential(googleCredential);

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

  Future<String> studentVueSignIn({required String email, required String password}) async {
    try {
      var student = Student();
      String username = email.substring(0, email.indexOf('@'));
      String domain = 'portal.lcps.org';
      student = await StudentVueClient(username, password, domain).loadStudentData();

      student.id = FirebaseAuth.instance.currentUser?.uid;

      if (student.studentId == null) return 'failed';

      await _createStudentInDatabase(student);

      await StudentVueClient(username, password, domain).loadInfoToDatabase(studentID: student.id!);

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
