import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/studentvue_repository.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  final CollectionReference user = FirebaseFirestore.instance
      .collection('customers')
      .doc('lcps')
      .collection('schools')
      .doc('independence')
      .collection('students');

  String uid = '';

  Future<void> createStudentInDatabase(Student student, String uid) async {
    await user.doc(uid).set(student.toMap());
  }

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

  Future<String> signUp({String email, String password, String domain}) async {
    try {
      Student student = Student();
      String username = email.substring(0, email.indexOf('@'));

      await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => uid = value.user.uid);

      await StudentVueClient(username, password, domain)
          .loadStudentData()
          .then((value) => student = value);

      await createStudentInDatabase(student, uid);

      return 'Sign up successful';
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }
}
