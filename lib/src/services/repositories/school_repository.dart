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
import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/models/student.dart';

class SchoolRepository {
  var ref = FirebaseFirestore.instance.collection('customers/lcps/schools').doc('independence');

  Future<School> get school async {
    try {
      var _school = await ref.get();
      var school = School.fromDocumentSnapshot(_school);

      return school;
    } catch (e) {
      rethrow;
    }
  }

  Future<Student> getStudent(String id) async {
    try {
      var _student = await ref.collection('students').doc(id).get();
      var student = Student.fromDocumentSnapshot(_student);

      return student;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Student>> get getAllStudents async {
    try {
      var _students = await ref.collection('students').get();
      List<Student> students = [];
      for (var item in _students.docs) {
        if (item.data()['studentId'] != null) {
          students.add(Student.fromDocumentSnapshot(item));
        }
      }

      return students;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Block>> get blocks async {
    try {
      var _school = await school;

      var _blocks = _school.currentDay!.blocks!;

      return _blocks;
    } catch (e) {
      rethrow;
    }
  }

  List<Assignment> _assignments = [];
  Future<Class> getClass({String? id}) async {
    var _class = await ref.collection('classes').doc(id).get();
    var assignmentsRef = await ref.collection('classes').doc(id).collection('assignments').get();

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
  }

  Future<StaffMember> getTeacherByClassId(String classId) async {
    var _class = await ref.collection('classes').doc(classId).get();

    String teacherId = _class['teacherId'];
    var teacherDocument = await ref.collection('staff').doc(teacherId).get();

    var _teacher = StaffMember.fromDocumentSnapshot(teacherDocument);

    return _teacher;
  }

  Future<StaffMember> getTeacherByTeacherId(String teacherId) async {
    if (teacherId == '') return StaffMember();

    var teacherDocument = await ref.collection('staff').doc(teacherId).get();
    var _teacher = StaffMember.fromDocumentSnapshot(teacherDocument);

    return _teacher;
  }

  Future<Block> getBlockByPeriod(int period) async {
    var _school = await school;

    var _block = _school.currentDay!.blocks!.where((element) => element.period == period).first;

    return _block;
  }
}
