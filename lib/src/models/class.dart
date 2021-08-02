import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/student.dart';

class Class {
  String? id;
  String? name;
  String? roomNumber;
  String? teacherId;
  int? block;
  int? markingPeriod;
  List<StudentInClass>? students;
  List<Assignment>? assignments;

  Class({
    this.id,
    this.name,
    this.block,
    this.markingPeriod,
    this.roomNumber,
    this.teacherId,
    this.students,
    this.assignments,
  });

  Class copyWith({
    String? id,
    String? name,
    String? roomNumber,
    String? teacherId,
    int? block,
    int? markingPeriod,
    List<StudentInClass>? students,
    List<Assignment>? assignments,
  }) {
    return Class(
      id: id ?? this.id,
      name: name ?? this.name,
      block: block ?? this.block,
      markingPeriod: markingPeriod ?? this.markingPeriod,
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
      'markingPeriod': markingPeriod,
      'roomNumber': roomNumber,
      'teacherId': teacherId,
      'students': students?.map((x) => x.toMap()).toList(),
      'assignments': assignments?.map((x) => x.toMap()).toList(),
    };
  }

  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      id: map['id'],
      name: map['name'],
      block: map['block'],
      markingPeriod: map['markingPeriod'],
      roomNumber: map['roomNumber'],
      teacherId: map['teacherId'],
      students: List<StudentInClass>.from(
          map['students']?.map((x) => StudentInClass.fromMap(x))),
      assignments: List<Assignment>.from(
          map['assignments']?.map((x) => Assignment.fromMap(x))),
    );
  }

  factory Class.fromDocumentSnapshot(
    DocumentSnapshot doc,
    List<Assignment> assignments,
  ) {
    return Class(
      id: doc['id'],
      name: doc['name'],
      block: doc['block'],
      markingPeriod: doc['markingPeriod'],
      roomNumber: doc['roomNumber'],
      teacherId: doc['teacherId'],
      assignments: assignments,
      students: List<StudentInClass>.from(
          doc['students']?.map((x) => StudentInClass.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Class.fromJson(String source) => Class.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Class(id: $id, name: $name, block: $block, markingPeriod: $markingPeriod, roomNumber: $roomNumber, teacherId: $teacherId, students: $students, assignments: $assignments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Class &&
        other.id == id &&
        other.name == name &&
        other.block == block &&
        other.markingPeriod == markingPeriod &&
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
        markingPeriod.hashCode ^
        roomNumber.hashCode ^
        teacherId.hashCode ^
        students.hashCode ^
        assignments.hashCode;
  }
}
