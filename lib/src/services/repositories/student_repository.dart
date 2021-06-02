import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class StudentRepository extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStudent(
      String district, String school, String uid) {
    try {
      return _firestore
          .collection('customers')
          .doc(district)
          .collection('schools')
          .doc(school)
          .collection('students')
          .doc(uid)
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }
}
