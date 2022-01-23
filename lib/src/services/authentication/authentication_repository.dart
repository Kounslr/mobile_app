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

  CollectionReference classesRef(String schoolName) {
    return FirebaseFirestore.instance.collection('schools/$schoolName/classes');
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
      return 'Error signing out. Please try again.';
    }
  }

  Future<String> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      return 'success';
    } catch (e) {
      if (e is FirebaseAuthException) {
        return AuthenticationExceptions.fromFirebaseAuthError(e).toString();
      }
      return 'Error signing in. Please try again.';
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

      if (credential.additionalUserInfo!.isNewUser) {
        await FirebaseFirestore.instance
            .doc('students/${FirebaseAuth.instance.currentUser?.uid}')
            .set({'id': FirebaseAuth.instance.currentUser?.uid, 'hasData': false, 'school': ''});
        return 'new';
      }

      return 'success';
    } catch (e) {
      if (e is FirebaseAuthException) {
        return AuthenticationExceptions.fromFirebaseAuthError(e).toString();
      } else if (e is RangeError) {
        return '';
      }
      return 'Error signing in. Please try again.';
    }
  }

  Future<String> studentVueSignIn(
      {required String username, required String password, required void Function(void Function()) setState}) async {
    try {
      var student = Student();
      String domain = 'portal.lcps.org';
      student = await StudentVueClient(username, password, domain).loadStudentData();

      student.id = FirebaseAuth.instance.currentUser?.uid;

      if (student.studentId == null) return 'Error signing in. Please try again.';

      return await StudentVueClient(username, password, domain)
          .loadInfoToDatabase(student: student, setState: setState, password: password);
    } catch (e) {
      return 'Error signing in. Please try again.';
    }
  }

  Future<String> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .doc('students/${FirebaseAuth.instance.currentUser?.uid}')
          .set({'id': FirebaseAuth.instance.currentUser?.uid, 'hasData': false, 'school': ''});

      return 'success';
    } catch (e) {
      return 'Error signing up. Please try again.';
    }
  }
}
