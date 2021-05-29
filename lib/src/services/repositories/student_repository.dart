import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kounslr/src/config/locator.dart';
import 'dart:async';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/firestore_repository.dart';

class StudentRepository extends ChangeNotifier {
  FirestoreRepository _api = locator<FirestoreRepository>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStudent(
      String district, String school, String uid) {
    try {
      var _doc = _firestore
          .collection('customers')
          .doc(district)
          .collection('schools')
          .doc(school)
          .collection('students')
          .doc(uid)
          .snapshots();
      return _doc;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<QuerySnapshot> fetchStudentsAsStream() {
    return _api.streamDataCollection();
  }

  Future<Student> getStudentById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Student.fromMap(doc.data());
  }

  Future removeStudent(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateStudent(Student data, String id) async {
    await _api.updateDocument(data.toMap(), id);
    return;
  }

  // Future addStudent(Student data) async {
  //   var result = await _api.addDocument(data.toMap());

  //   return;
  // }
}
