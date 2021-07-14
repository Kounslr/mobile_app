import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kounslr/src/models/class.dart';
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

  // String uid = '';

  Future<void> _createStudentInDatabase(
    StudentM student,
    List<Class> classes,
  ) async {
    await user.doc(student.id).set(student.toMap());

    classes.forEach((element) async {
      await user
          .doc(student.id)
          .collection('classes')
          .doc(element.className)
          .set(element.toMap());
    });

    classes.forEach((e) async {
      e.assignments!.forEach((element) async {
        await user
            .doc(student.id)
            .collection('classes')
            .doc(e.className)
            .collection('assignments')
            .doc(element.assignmentName)
            .set(element.toMap());
      });
    });
  }

  Future<void> _updateStudentInDatabase(
    StudentM student,
    List<Class> classes,
  ) async {
    await user.doc(student.id).set(student.toMap());

    classes.forEach((element) async {
      await user
          .doc(student.id)
          .collection('classes')
          .doc(element.className)
          .delete();

      await user
          .doc(student.id)
          .collection('classes')
          .doc(element.className)
          .set(element.toMap());
    });

    classes.forEach((e) async {
      e.assignments!.forEach((element) async {
        await user
            .doc(student.id)
            .collection('classes')
            .doc(e.className)
            .collection('assignments')
            .doc(element.assignmentName)
            .delete();

        await user
            .doc(student.id)
            .collection('classes')
            .doc(e.className)
            .collection('assignments')
            .doc(element.assignmentName)
            .set(element.toMap());
      });
    });
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      var student = StudentM();
      List<Class> classes = [];
      String username = email.substring(0, email.indexOf('@'));
      String domain = 'portal.lcps.org';

      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // .then((value) => uid = value.user!.uid);

      student =
          await StudentVueClient(username, password, domain).loadStudentData();

      classes =
          await StudentVueClient(username, password, domain).loadGradebook();

      await _updateStudentInDatabase(student, classes);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? domain,
  }) async {
    try {
      var student = StudentM();
      List<Class> classes = [];
      String username = email.substring(0, email.indexOf('@'));

      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // .then((value) => {uid = value.user!.uid, student.id = uid});

      student =
          await StudentVueClient(username, password, domain).loadStudentData();

      classes =
          await StudentVueClient(username, password, domain).loadGradebook();

      await _createStudentInDatabase(student, classes);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }
}
