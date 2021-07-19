import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<void> _createStudentInDatabase(Student student) async {
    await user.doc(student.id).set(student.toMap());
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      var googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
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
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }
}
