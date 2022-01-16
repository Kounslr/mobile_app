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
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/models/student.dart';

class SchoolRepository {
  Future<DocumentReference<Map<String, dynamic>>> get ref async {
    final stdnt = await FirebaseFirestore.instance.doc('students/${FirebaseAuth.instance.currentUser?.uid}').get();
    return FirebaseFirestore.instance.doc('schools/${stdnt.data()!['school']}');
  }

  Future<School> get school async {
    try {
      var _school = await ref;
      var school = School.fromDocumentSnapshot(await _school.get());

      return school;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Future<Student> getStudent(String id) async {
    try {
      var _student = await ref;
      var student = Student.fromDocumentSnapshot(await _student.collection('students').doc(id).get());

      return student;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Future<List<Student>> get getAllStudents async {
    try {
      final _students = await ref;
      final _stdnts = await _students.collection('students').get();
      List<Student> students = [];
      for (var item in _stdnts.docs) {
        if (item.data()['studentId'] != null) {
          students.add(Student.fromDocumentSnapshot(item));
        }
      }

      return students;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  Future<List<Block>> get blocks async {
    try {
      var _school = await school;

      var _blocks = _school.currentDay!.blocks!;

      return _blocks;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

      rethrow;
    }
  }

  List<Assignment> _assignments = [];
  Future<Class> getClass({String? id}) async {
    try {
      final _ref = await ref;

      var _class = await _ref.collection('classes').doc(id).get();
      var assignmentsRef = await _ref.collection('classes').doc(id).collection('assignments').get();

      for (var element in assignmentsRef.docs) {
        _assignments.add(Assignment.fromDocumentSnapshot(element));
      }

      Map<String, Assignment> mapFilter = {};
      for (var item in _assignments) {
        mapFilter[item.id!] = item;
      }
      _assignments = mapFilter.values.toList();

      _assignments.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

      var schoolClass = Class.fromDocumentSnapshot(_class, _assignments);

      return schoolClass;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Class>> getClassesByTeacherId(String teacherId) async {
    try {
      final _ref = await ref;
      var _classes = <Class>[];

      var _classesDocs = await _ref.collection('classes').where('teacherId', isEqualTo: teacherId).get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> item in _classesDocs.docs) {
        final mClass = await getClass(id: item.data()['id']);
        _classes.add(mClass);
      }

      return _classes;
    } catch (e) {
      rethrow;
    }
  }

  Future<StaffMember> getTeacherByClassId(String classId) async {
    final _ref = await ref;
    var _class = await _ref.collection('classes').doc(classId).get();

    String teacherId = _class['teacherId'];
    var teacherDocument = await _ref.collection('staff').doc(teacherId).get();

    var _teacher = StaffMember.fromDocumentSnapshot(teacherDocument);

    return _teacher;
  }

  Future<StaffMember> getTeacherByTeacherId(String teacherId) async {
    if (teacherId == '') return StaffMember();

    final _ref = await ref;

    var teacherDocument = await _ref.collection('staff').doc(teacherId).get();
    var _teacher = StaffMember.fromDocumentSnapshot(teacherDocument);

    return _teacher;
  }

  Future<Block> getBlockByPeriod(int period) async {
    var _school = await school;

    var _block = _school.currentDay!.blocks!.where((element) => element.period == period).first;

    return _block;
  }
}
