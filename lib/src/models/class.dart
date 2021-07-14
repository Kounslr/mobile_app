import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/models/student.dart';

class Class {
  String? className;
  String? roomNumber;
  String? pctGrade;
  String? letterGrade;
  StaffMember? teacher;
  Block? block;
  List<Assignment>? assignments;

  Class({
    this.className,
    this.roomNumber,
    this.pctGrade,
    this.letterGrade,
    this.teacher,
    this.block,
    this.assignments,
  });

  Class copyWith({
    String? className,
    String? roomNumber,
    String? pctGrade,
    String? letterGrade,
    StaffMember? teacher,
    Block? block,
    List<Assignment>? assignments,
  }) {
    return Class(
      className: className ?? this.className,
      roomNumber: roomNumber ?? this.roomNumber,
      pctGrade: pctGrade ?? this.pctGrade,
      letterGrade: letterGrade ?? this.letterGrade,
      teacher: teacher ?? this.teacher,
      block: block ?? this.block,
      assignments: assignments ?? this.assignments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'roomNumber': roomNumber,
      'pctGrade': pctGrade,
      'letterGrade': letterGrade,
      'teacher': teacher?.toMap(),
      'block': block?.toMap(),
    };
  }

  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      className: map['className'],
      roomNumber: map['roomNumber'],
      pctGrade: map['pctGrade'],
      letterGrade: map['letterGrade'],
      teacher: StaffMember.fromMap(map['teacher']),
      block: Block.fromMap(map['block']),
    );
  }

  factory Class.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Class(
      className: doc['className'],
      roomNumber: doc['roomNumber'],
      pctGrade: doc['pctGrade'],
      letterGrade: doc['letterGrade'],
      teacher: StaffMember.fromDocumentSnapshot(doc['teacher']),
      block: Block.fromDocumentSnapshot(doc['block']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Class.fromJson(String source) => Class.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Class(className: $className, roomNumber: $roomNumber, pctGrade: $pctGrade, letterGrade: $letterGrade, teacher: $teacher, block: $block, assignments: $assignments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Class &&
        other.className == className &&
        other.roomNumber == roomNumber &&
        other.pctGrade == pctGrade &&
        other.letterGrade == letterGrade &&
        other.teacher == teacher &&
        other.block == block &&
        listEquals(other.assignments, assignments);
  }

  @override
  int get hashCode {
    return className.hashCode ^
        roomNumber.hashCode ^
        pctGrade.hashCode ^
        letterGrade.hashCode ^
        teacher.hashCode ^
        block.hashCode ^
        assignments.hashCode;
  }
}

class ClassM {
  String? id;
  String? name;
  String? roomNumber;
  String? teacherId;
  int? block;
  List<StudentM>? students;
  List<AssignmentM>? assignments;

  ClassM({
    this.id,
    this.name,
    this.block,
    this.roomNumber,
    this.teacherId,
    this.students,
    this.assignments,
  });

  ClassM copyWith({
    String? id,
    String? name,
    String? roomNumber,
    String? teacherId,
    int? block,
    List<StudentM>? students,
    List<AssignmentM>? assignments,
  }) {
    return ClassM(
      id: id ?? this.id,
      name: name ?? this.name,
      block: block ?? this.block,
      roomNumber: roomNumber ?? this.roomNumber,
      teacherId: teacherId ?? this.teacherId,
      students: students ?? this.students,
      assignments: assignments ?? this.assignments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'block': block,
      'roomNumber': roomNumber,
      'teacherId': teacherId,
      'students': students?.map((x) => x.toMapId()).toList(),
      'assignments': assignments?.map((x) => x.toMap()).toList(),
    };
  }

  factory ClassM.fromMap(Map<String, dynamic> map) {
    return ClassM(
      id: map['id'],
      name: map['name'],
      block: map['block'],
      roomNumber: map['roomNumber'],
      teacherId: map['teacherId'],
      students:
          List<StudentM>.from(map['students']?.map((x) => StudentM.fromMap(x))),
      assignments: List<AssignmentM>.from(
          map['assignments']?.map((x) => AssignmentM.fromMap(x))),
    );
  }

  factory ClassM.fromDocumentSnapshot(
    DocumentSnapshot doc,
    List<AssignmentM> assignments,
  ) {
    return ClassM(
      id: doc['id'],
      name: doc['name'],
      block: doc['block'],
      roomNumber: doc['roomNumber'],
      teacherId: doc['teacherId'],
      students: List<StudentM>.from(
          doc['students']?.map((x) => StudentM.fromMapId(x))),
      assignments: assignments,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassM.fromJson(String source) => ClassM.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassM(id: $id, name: $name, block: $block, roomNumber: $roomNumber, teacherId: $teacherId, students: $students, assignments: $assignments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClassM &&
        other.id == id &&
        other.name == name &&
        other.block == block &&
        other.roomNumber == roomNumber &&
        other.teacherId == teacherId &&
        listEquals(other.students, students) &&
        listEquals(other.assignments, assignments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        block.hashCode ^
        roomNumber.hashCode ^
        teacherId.hashCode ^
        students.hashCode ^
        assignments.hashCode;
  }
}
