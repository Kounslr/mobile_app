import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/staff_member.dart';

class SchoolRepository {
  var ref = FirebaseFirestore.instance
      .collection('customers')
      .doc('lcps')
      .collection('schools')
      .doc('independence');

  Future<SchoolM> getSchool() async {
    try {
      var _school = await ref.get();
      var school = SchoolM.fromDocumentSnapshot(_school);

      return school;
    } catch (e) {
      rethrow;
    }
  }

  List<AssignmentM> _assignments = [];
  Future<ClassM> getClass({String? id}) async {
    var _class = await ref.collection('classes').doc(id).get();
    var assignmentsRef =
        await ref.collection('classes').doc(id).collection('assignments').get();

    assignmentsRef.docs.forEach((element) {
      _assignments.add(AssignmentM.fromDocumentSnapshot(element));
    });

    Map<String, AssignmentM> mapFilter = {};
    for (var item in _assignments) {
      mapFilter[item.id!] = item;
    }
    _assignments = mapFilter.values.toList();

    _assignments.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    var schoolClass = ClassM.fromDocumentSnapshot(_class, _assignments);

    return schoolClass;
  }

  Future<StaffMember> getTeacherByClassId(String classId) async {
    var _class = await ref.collection('classes').doc(classId).get();

    String teacherId = _class['teacherId'];
    var teacherDocument = await ref.collection('staff').doc(teacherId).get();

    var _teacher = StaffMember.fromDocumentSnapshot(teacherDocument);

    return _teacher;
  }

  Future<StaffMember> getTeacherByTeacherId(String teacherId) async {
    var teacherDocument = await ref.collection('staff').doc(teacherId).get();
    var _teacher = StaffMember.fromDocumentSnapshot(teacherDocument);

    return _teacher;
  }

  Future<BlockM> getBlockByPeriod(int period) async {
    var _school = await getSchool();

    var _block = _school.currentDay!.blocks!
        .where((element) => element.period == period)
        .toList()[0];

    return _block;
  }
}
